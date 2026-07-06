import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/app_state_scope.dart';
import 'widgets/profile_stat_card.dart';
import 'widgets/account_info_tile.dart';
import 'widgets/preference_tile.dart';
import 'edit_name_screen.dart';
import 'edit_email_screen.dart';
import 'edit_password_screen.dart';
import 'edit_income_screen.dart';
import 'currency_model.dart';
import 'choose_currency_screen.dart';
import 'export_profile_pdf.dart';
import '../auth/splash_screen.dart';

/// Page Profil.
/// IMPORTANT : cette page ne stocke plus le nom, l'email, le revenu, etc.
/// dans ses propres variables. Elle lit et modifie tout ça directement dans
/// l'AppState (via AppStateScope.of(context)), pour que la Home (et toute
/// future page) affiche toujours les mêmes valeurs à jour.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
    final appState = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(appState),
              const SizedBox(height: 24),
              _buildSectionTitle('COMPTE'),
              const SizedBox(height: 12),
              _buildAccountCard(context, appState),
              const SizedBox(height: 24),
              _buildSectionTitle('PRÉFÉRENCES'),
              const SizedBox(height: 12),
              _buildPreferencesCard(context, appState),
              const SizedBox(height: 24),
              _buildSectionTitle('DONNÉES'),
              const SizedBox(height: 12),
              _buildExportCard(context, appState),
              const SizedBox(height: 20),
              _buildLogoutButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Navigation vers les pages de modification ----

  Future<void> _openEditName(BuildContext context, AppState appState) async {
    final newName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => EditNameScreen(currentName: appState.userName)),
    );
    if (newName != null && newName.trim().isNotEmpty) {
      appState.updateUserName(newName.trim());
    }
  }

  Future<void> _openEditEmail(BuildContext context, AppState appState) async {
    final newEmail = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => EditEmailScreen(currentEmail: appState.userEmail)),
    );
    if (newEmail != null && newEmail.trim().isNotEmpty) {
      appState.updateUserEmail(newEmail.trim());
    }
  }

  Future<void> _openEditPassword(BuildContext context, AppState appState) async {
    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const EditPasswordScreen()),
    );
    if (success == true) {
      appState.markPasswordUpdated();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mot de passe mis à jour avec succès')),
        );
      }
    }
  }

  Future<void> _openEditIncome(BuildContext context, AppState appState) async {
    final newIncome = await Navigator.push<double>(
      context,
      MaterialPageRoute(builder: (_) => EditIncomeScreen(currentIncome: appState.monthlyIncome)),
    );
    if (newIncome != null && newIncome > 0) {
      appState.updateMonthlyIncome(newIncome);
    }
  }

  Future<void> _openChooseCurrency(BuildContext context, AppState appState) async {
    final newCurrency = await Navigator.push<Currency>(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseCurrencyScreen(selectedCode: appState.selectedCurrency.code),
      ),
    );
    if (newCurrency != null) {
      appState.updateCurrency(newCurrency);
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

  Future<void> _exportData(AppState appState) async {
    await exportProfilePdf(
      name: appState.userName,
      email: appState.userEmail,
      expensesCount: '247',
      monthsTracked: '8',
      monthlyIncomeFormatted: '${_formatAmount(appState.monthlyIncome)} ${appState.selectedCurrency.symbol}',
      currencyLabel: '${appState.selectedCurrency.name} (${appState.selectedCurrency.symbol})',
      appearanceLabel: appState.isDarkMode ? 'Mode sombre' : 'Mode clair',
      notificationsLabel: appState.notificationsOn ? 'Activées' : 'Désactivées',
      passwordLastUpdateLabel: appState.passwordLastUpdateLabel,
    );
  }

  // ---- En-tête fond clair : image en grand format, nom, email, statistiques ----
  Widget _buildHeader(AppState appState) {
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
                opacity: 0.6,
                child: Image.asset(
                  'assets/profil_icon.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appState.userName,
                    style: AppStyles.profileNameStyle.copyWith(color: AppColors.bigtextColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appState.userEmail,
                    style: AppStyles.profileEmailStyle.copyWith(color: AppColors.smalltextColor),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: ProfileStatCard(
                          value: '247',
                          label: 'Dépenses',
                          valueColor: AppColors.roseColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: ProfileStatCard(
                          value: '8',
                          label: 'Mois suivis',
                          valueColor: AppColors.greenColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ProfileStatCard(
                          value: '${_formatAmount(appState.monthlyIncome)} ${appState.selectedCurrency.symbol}',
                          label: 'Revenu / mois',
                          valueColor: AppColors.amberColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(title, style: AppStyles.sectionTitleStyle),
    );
  }

  // ---- Carte "COMPTE" ----
  Widget _buildAccountCard(BuildContext context, AppState appState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          AccountInfoTile(
            icon: Icons.badge_outlined,
            iconBackground: AppColors.purpleLightColor,
            title: 'nom',
            subtitle: appState.userName,
            onModifierTap: () => _openEditName(context, appState),
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          AccountInfoTile(
            icon: Icons.mail_outline,
            iconBackground: AppColors.blueLightColor,
            title: 'email',
            subtitle: appState.userEmail,
            onModifierTap: () => _openEditEmail(context, appState),
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          AccountInfoTile(
            icon: Icons.lock_outline,
            iconBackground: AppColors.purpleLightColor,
            title: 'mot de passe',
            subtitle: appState.passwordLastUpdateLabel,
            onModifierTap: () => _openEditPassword(context, appState),
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          AccountInfoTile(
            icon: Icons.attach_money,
            iconBackground: AppColors.orangeLightColor,
            title: 'revenu mensuel',
            subtitle: '${_formatAmount(appState.monthlyIncome)} ${appState.selectedCurrency.symbol} / mois',
            onModifierTap: () => _openEditIncome(context, appState),
          ),
        ],
      ),
    );
  }

  // ---- Carte "PRÉFÉRENCES" ----
  Widget _buildPreferencesCard(BuildContext context, AppState appState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          PreferenceTile(
            icon: Icons.currency_exchange,
            iconBackground: AppColors.greenLightColor,
            title: 'Devise',
            subtitle: '${appState.selectedCurrency.name} (${appState.selectedCurrency.symbol})',
            trailing: TextButton(
              onPressed: () => _openChooseCurrency(context, appState),
              child: const Text('Modifier'),
            ),
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          PreferenceTile(
            icon: Icons.wb_sunny_outlined,
            iconBackground: AppColors.orangeLightColor,
            title: 'Apparence',
            subtitle: appState.isDarkMode ? 'Mode sombre' : 'Mode clair',
            trailing: Switch(
              value: appState.isDarkMode,
              activeColor: AppColors.darkmauveColor,
              onChanged: (value) => appState.setDarkMode(value),
            ),
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          PreferenceTile(
            icon: Icons.notifications_none,
            iconBackground: AppColors.purpleLightColor,
            title: 'Notifications',
            subtitle: 'Alertes budget activées',
            trailing: Switch(
              value: appState.notificationsOn,
              activeColor: AppColors.darkmauveColor,
              onChanged: (value) => appState.setNotificationsOn(value),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Carte "Exporter mes données" ----
  Widget _buildExportCard(BuildContext context, AppState appState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _exportData(appState),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.greenLightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.download_outlined, color: AppColors.greenColor, size: 20),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('Exporter mes données', style: AppStyles.tileTitleStyle),
              ),
              const Icon(Icons.chevron_right, color: AppColors.smalltextColor),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Bouton "Se déconnecter" ----
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout, color: AppColors.darkmauveColor, size: 18),
        label: const Text(
          'Se déconnecter',
          style: TextStyle(
            color: AppColors.darkmauveColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cardBackgroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}