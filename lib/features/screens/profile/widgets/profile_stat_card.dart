import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/styles.dart';

/// Une petite carte violette qui affiche un chiffre + un libellé
/// (ex: "247" / "Dépenses"). Réutilisée 3 fois en haut de la page Profil.
class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.statCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppStyles.statNumberStyle.copyWith(color: valueColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppStyles.statLabelStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}