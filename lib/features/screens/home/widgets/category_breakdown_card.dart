import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/styles.dart';
import '../../../../core/state/app_state.dart';

/// Carte qui affiche le donut chart des dépenses par catégorie, avec une
/// légende à droite (nom de la catégorie + montant).
class CategoryBreakdownCard extends StatelessWidget {
  final List<CategoryAmount> categories;
  final double totalAmount;
  final String currencySymbol;

  const CategoryBreakdownCard({
    super.key,
    required this.categories,
    required this.totalAmount,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Le donut chart, avec le total affiché au centre grâce à un Stack
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: categories
                        .map((c) => PieChartSectionData(
                              value: c.amount,
                              color: c.color,
                              radius: 18,
                              showTitle: false,
                            ))
                        .toList(),
                    centerSpaceRadius: 34,
                    sectionsSpace: 3,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('total', style: AppStyles.tileSubtitleStyle),
                    Text(
                      totalAmount.toStringAsFixed(0),
                      style: AppStyles.tileTitleStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // La légende : un point de couleur + le nom + le montant, pour chaque catégorie
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories
                  .map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: c.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(c.label, style: AppStyles.legendLabelStyle),
                            ),
                            Text(
                              '${c.amount.toStringAsFixed(0)} $currencySymbol',
                              style: AppStyles.legendAmountStyle,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}