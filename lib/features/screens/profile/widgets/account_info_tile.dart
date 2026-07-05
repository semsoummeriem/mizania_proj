import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/styles.dart';

/// Une ligne dans la carte "COMPTE" : icône + titre + sous-titre + bouton "Modifier".
/// Utilisée pour : nom, email, mot de passe, revenu mensuel.
class AccountInfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onModifierTap;

  const AccountInfoTile({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onModifierTap,
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
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onModifierTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkmauveColor,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Modifier', style: AppStyles.buttonTextStyle),
          ),
        ],
      ),
    );
  }
}