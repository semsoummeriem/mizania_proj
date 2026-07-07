import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/state/app_state.dart';
import '../historique_styles.dart';

/// Une ligne de dépense dans la liste de l'Historique : icône + catégorie +
/// montant + bouton "Voir detail".
class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final String currencySymbol;
  final VoidCallback onDetailTap;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.currencySymbol,
    required this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: expense.iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(expense.icon, size: 18, color: AppColors.darkmauveColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(expense.category, style: HistoriqueStyles.expenseCategoryStyle),
          ),
          Text(
            '-${expense.amount.toStringAsFixed(2)} $currencySymbol',
            style: HistoriqueStyles.expenseAmountStyle,
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onDetailTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkmauveColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Voir detail', style: HistoriqueStyles.detailButtonStyle),
          ),
        ],
      ),
    );
  }
}