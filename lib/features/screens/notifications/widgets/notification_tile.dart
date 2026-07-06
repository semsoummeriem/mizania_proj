import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/styles.dart';
import '../../../../core/state/app_state.dart';

/// Une ligne de la liste de notifications : icône + titre + message + heure,
/// avec un petit point violet si elle n'est pas encore lue.
class NotificationTile extends StatelessWidget {
  final AppNotification notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // Fond légèrement violet pour les notifications non lues, blanc pour les lues
        color: notification.isRead ? AppColors.cardBackgroundColor : AppColors.purpleLightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notification.iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(notification.icon, size: 18, color: notification.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: AppStyles.notifTitleStyle),
                const SizedBox(height: 3),
                Text(notification.message, style: AppStyles.notifMessageStyle),
                const SizedBox(height: 6),
                Text(notification.time, style: AppStyles.notifTimeStyle),
              ],
            ),
          ),
          if (!notification.isRead) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(color: AppColors.darkmauveColor, shape: BoxShape.circle),
            ),
          ],
        ],
      ),
    );
  }
}