import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

/// Page "Modifier le revenu mensuel".
/// Reçoit le revenu actuel via [currentIncome] (un nombre, pas un texte).
/// Renvoie le nouveau revenu (double) à la page précédente si l'utilisateur enregistre.
///
/// NOTE PÉDAGOGIQUE : les pourcentages ci-dessous (25% nourriture, 15% transport,
/// 20% épargne) sont des valeurs fixes pour l'instant, juste pour afficher l'aperçu
/// "Impact sur tes budgets". Plus tard, ces pourcentages viendront des vrais budgets
/// que l'utilisateur aura configurés dans l'app.
class EditIncomeScreen extends StatefulWidget {
  final double currentIncome;

  const EditIncomeScreen({super.key, required this.currentIncome});

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
  late final TextEditingController _incomeController;
  String? _errorText;

  // Pourcentages fixes utilisés pour l'aperçu (à rendre dynamiques plus tard)
  static const double _foodPercent = 0.25;
  static const double _transportPercent = 0.15;
  static const double _savingsPercent = 0.20;

  @override
  void initState() {
    super.initState();
    _incomeController = TextEditingController(text: widget.currentIncome.toStringAsFixed(0));
    _incomeController.addListener(() => setState(() {})); // pour rafraîchir l'aperçu en direct
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  // Lit le texte saisi et le convertit en nombre. Si ce n'est pas un nombre valide, renvoie 0.
  double get _enteredIncome {
    final cleaned = _incomeController.text.replaceAll(' ', '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0;
  }

  String _formatAmount(double value) {
    final raw = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      final remaining = raw.length - i;
      buffer.write(raw[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(' ');
    }
    return buffer.toString();
  }

  void _saveIncome() {
    final value = _enteredIncome;
    if (value <= 0) {
      setState(() => _errorText = 'Merci de saisir un montant valide.');
      return;
    }
    setState(() => _errorText = null);
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final income = _enteredIncome;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Revenu actuel', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildReadonlyField('${_formatAmount(widget.currentIncome)} € / mois'),
                  const SizedBox(height: 20),
                  const Text('Nouveau revenu', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildInputField(),
                  if (_errorText != null) ...[
                    const SizedBox(height: 6),
                    Text(_errorText!, style: AppStyles.errorTextStyle),
                  ] else ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Utilisé pour calculer tes budgets et comparer tes dépenses.',
                      style: AppStyles.helperTextStyle,
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildBudgetImpactBox(income),
                  const SizedBox(height: 28),
                  _buildSaveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      color: AppColors.darkmauveColor,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          ),
          const SizedBox(width: 4),
          const Text('Revenu mensuel', style: AppStyles.editAppBarTitleStyle),
        ],
      ),
    );
  }

  Widget _buildReadonlyField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(value, style: AppStyles.inputTextStyle),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkmauveColor, width: 1.5),
      ),
      child: TextField(
        controller: _incomeController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: AppStyles.inputTextStyle,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixText: '€ ',
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Carte violette claire montrant l'impact du nouveau revenu sur les budgets, en temps réel
  Widget _buildBudgetImpactBox(double income) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purpleLightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Impact sur tes budgets', style: AppStyles.budgetImpactTitleStyle),
          const SizedBox(height: 12),
          _buildBudgetRow('Nourriture', income * _foodPercent),
          const SizedBox(height: 8),
          _buildBudgetRow('Transport', income * _transportPercent),
          const SizedBox(height: 8),
          _buildBudgetRow('Épargne', income * _savingsPercent),
        ],
      ),
    );
  }

  Widget _buildBudgetRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.budgetImpactRowStyle),
        Text('${_formatAmount(amount)} €', style: AppStyles.budgetImpactRowStyle),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveIncome,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkmauveColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Enregistrer', style: AppStyles.buttonTextStyle),
      ),
    );
  }
}