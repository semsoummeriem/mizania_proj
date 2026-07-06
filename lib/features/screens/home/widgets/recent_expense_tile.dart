import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/styles.dart';
import '../../../../core/state/app_state.dart';

/// Une ligne de la liste "Dernières dépenses" : icône + catégorie + date + montant.
class RecentExpenseTile extends StatelessWidget {
  final ExpenseItem expense;
  final String currencySymbol;

  const RecentExpenseTile({
    super.key,
    required this.expense,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.category, style: AppStyles.tileTitleStyle),
                const SizedBox(height: 2),
                Text(expense.date, style: AppStyles.tileSubtitleStyle),
              ],
            ),
          ),
          Text(
            '${expense.amount.toStringAsFixed(0)} $currencySymbol',
            style: AppStyles.expenseAmountStyle,
          ),
        ],
      ),
    );
  }
}