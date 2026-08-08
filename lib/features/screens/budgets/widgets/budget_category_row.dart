import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/state/app_state.dart';
import '../budget_styles.dart';

/// Une ligne "Budget par catégorie" : icône + nom + barre de proportion +
/// champ éditable pour le montant alloué.
class BudgetCategoryRow extends StatefulWidget {
  final BudgetCategory category;
  final double monthlyIncome;
  final String currencySymbol;
  final ValueChanged<double> onChanged;

  const BudgetCategoryRow({
    super.key,
    required this.category,
    required this.monthlyIncome,
    required this.currencySymbol,
    required this.onChanged,
  });

  @override
  State<BudgetCategoryRow> createState() => _BudgetCategoryRowState();
}

class _BudgetCategoryRowState extends State<BudgetCategoryRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.category.allocated.toStringAsFixed(0));
  }

  @override
  void didUpdateWidget(covariant BudgetCategoryRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si le montant a changé depuis l'extérieur (ex: preset appliqué), on met à jour le champ affiché.
    final currentText = widget.category.allocated.toStringAsFixed(0);
    if (_controller.text != currentText && !_controller.selection.isValid) {
      _controller.text = currentText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proportion = widget.monthlyIncome > 0
        ? (widget.category.allocated / widget.monthlyIncome).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.cardBackgroundColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: widget.category.iconBackground, borderRadius: BorderRadius.circular(12)),
            child: Icon(widget.category.icon, size: 18, color: AppColors.darkmauveColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.category.label, style: BudgetStyles.categoryLabelStyle),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: proportion,
                    minHeight: 4,
                    backgroundColor: AppColors.dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(widget.category.accentColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundlightColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                      onChanged: (value) {
                        final parsed = double.tryParse(value);
                        if (parsed != null) widget.onChanged(parsed);
                      },
                    ),
                  ),
                  Text(' ${widget.currencySymbol}', style: BudgetStyles.categoryLabelStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}