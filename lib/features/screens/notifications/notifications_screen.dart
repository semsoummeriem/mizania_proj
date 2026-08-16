import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/app_state_scope.dart';
import 'widgets/notification_tile.dart';

/// Page "Notifications".
/// NOTE PÉDAGOGIQUE : pour l'instant, toutes les notifications sont réparties
/// en 2 groupes fixes ("aujourd'hui" = les 3 premières, "cette semaine" = le
/// reste), juste pour respecter la maquette. Plus tard, il faudrait trier ça
/// par vraie date.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final notifications = appState.notifications;

    // TODO: remplacer cette séparation fixe par un vrai tri par date une fois
    // que les notifications auront une vraie date/heure au lieu d'un texte fixe.
    final todayNotifications = notifications.take(3).toList();
    final weekNotifications = notifications.skip(3).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context, appState),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (todayNotifications.isNotEmpty) ...[
                    const Text("AUJOURD'HUI", style: AppStyles.sectionTitleStyle),
                    const SizedBox(height: 12),
                    ...todayNotifications.map((n) => NotificationTile(notification: n)),
                    const SizedBox(height: 12),
                  ],
                  if (weekNotifications.isNotEmpty) ...[
                    const Text('CETTE SEMAINE', style: AppStyles.sectionTitleStyle),
                    const SizedBox(height: 12),
                    ...weekNotifications.map((n) => NotificationTile(notification: n)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppState appState) {
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
          const Text('Notifications', style: AppStyles.editAppBarTitleStyle),
          if (appState.unreadNotificationsCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${appState.unreadNotificationsCount}',
                style: const TextStyle(color: AppColors.whiteColor, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
          const Spacer(),
          TextButton(
            onPressed: () => appState.markAllNotificationsRead(),
            child: const Text(
              'Tout lire',
              style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}