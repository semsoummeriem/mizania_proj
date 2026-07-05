import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/styles.dart';

/// Une ligne dans la carte "PRÉFÉRENCES" : icône + titre + sous-titre + un widget
/// à droite (bouton "Modifier" pour la devise, ou un Switch pour apparence/notifications).
/// Le [trailing] est flexible pour pouvoir réutiliser ce widget avec n'importe quel contrôle.
class PreferenceTile extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final Widget trailing;

  const PreferenceTile({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: AppColors.darkmauveColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.tileTitleStyle),
                const SizedBox(height: 2),
                Text(subtitle, style: AppStyles.tileSubtitleStyle),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}