import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/app_state_scope.dart';
import '../notifications/notifications_screen.dart';
import 'widgets/category_breakdown_card.dart';
import 'widgets/recent_expense_tile.dart';

/// Page d'accueil (Home).
/// Reçoit [onSeeAllPressed], une fonction fournie par MainNavigationScreen,
/// pour basculer vers l'onglet "Historique" quand on clique "Voir tout".
class HomeScreen extends StatelessWidget {
  final VoidCallback onSeeAllPressed;

  const HomeScreen({super.key, required this.onSeeAllPressed});

  // Transforme un nombre en texte lisible avec espace tous les 3 chiffres (ex: 2500 -> "2 500")
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

  @override
  Widget build(BuildContext context) {
    // En lisant l'AppState ici, cette page se reconstruit automatiquement
    // dès que le nom, le revenu, ou la devise changent depuis la page Profil.
    final appState = AppStateScope.of(context);
    final firstName = appState.userName.split(' ').first;
    final symbol = appState.selectedCurrency.symbol;
    final remaining = appState.monthlyIncome - appState.totalSpentThisMonth;
    final percentUsed = appState.monthlyIncome > 0
        ? (appState.totalSpentThisMonth / appState.monthlyIncome).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, appState, firstName, symbol),
              const SizedBox(height: 20),
              _buildIncomeCard(appState, symbol, remaining, percentUsed),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Répartition du mois', style: AppStyles.cardSectionTitleStyle),
              ),
              const SizedBox(height: 12),
              CategoryBreakdownCard(
                categories: appState.categoryBreakdown,
                totalAmount: appState.totalSpentThisMonth,
                currencySymbol: symbol,
              ),
              const SizedBox(height: 24),
              _buildRecentExpensesCard(appState, symbol),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---- En-tête : salutation, image, bouton notifications ----
  Widget _buildHeader(
    BuildContext context,
    AppState appState,
    String firstName,
    String symbol,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Container(
        width: double.infinity,
        color: AppColors.backgroundlightColor,
        child: Stack(
          children: [
            Positioned.fill(
  child: Opacity(
    opacity: 0.7,
    child: Image.asset(
      'assets/home_icon.png',
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    ),
  ),
),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Salut,', style: AppStyles.greetingStyle),
                          Text(firstName, style: AppStyles.greetingNameStyle),
                        ],
                      ),
                      _buildNotificationButton(context, appState),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'TOTAL DÉPENSÉ — ${appState.currentMonthLabel.toUpperCase()}',
                    style: AppStyles.totalLabelStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatAmount(appState.totalSpentThisMonth)} $symbol',
                    style: AppStyles.totalAmountStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bouton cloche avec badge rouge = nombre de notifications non lues
  Widget _buildNotificationButton(BuildContext context, AppState appState) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.purpleLightColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.darkmauveColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ),
        if (appState.unreadNotificationsCount > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppColors.roseColor, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '${appState.unreadNotificationsCount}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.whiteColor, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }

  // ---- Carte "Revenu mensuel" avec barre de progression ----
  Widget _buildIncomeCard(AppState appState, String symbol, double remaining, double percentUsed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Revenu mensuel', style: AppStyles.tileTitleStyle),
              Text(
                '${_formatAmount(appState.monthlyIncome)} $symbol',
                style: AppStyles.incomeAmountStyle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentUsed,
              minHeight: 8,
              backgroundColor: AppColors.dividerColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkmauveColor),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(percentUsed * 100).toStringAsFixed(0)}% utilisé', style: AppStyles.percentUsedStyle),
              Text('⚡ Reste : ${_formatAmount(remaining)} $symbol', style: AppStyles.remainingStyle),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Carte "Dernières dépenses" ----
  Widget _buildRecentExpensesCard(AppState appState, String symbol) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dernières dépenses', style: AppStyles.cardSectionTitleStyle),
              GestureDetector(
                onTap: onSeeAllPressed,
                child: const Text('Voir tout', style: AppStyles.linkStyle),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...appState.recentExpenses.map(
            (expense) => RecentExpenseTile(expense: expense, currencySymbol: symbol),
          ),
        ],
      ),
    );
  }
}