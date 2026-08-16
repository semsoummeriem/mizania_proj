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
import '../../../core/services/profile_service.dart';

/// Page Profil.
/// IMPORTANT : cette page ne stocke plus le nom, l'email, le revenu, etc.
/// dans ses propres variables. Elle lit et modifie tout ça directement dans
/// l'AppState (via AppStateScope.of(context)), pour que la Home (et toute
/// future page) affiche toujours les mêmes valeurs à jour.
///
/// Elle est en StatefulWidget uniquement pour pouvoir déclencher le
/// chargement des données Supabase (appState.loadProfile()) au premier
/// affichage, si ce n'est pas déjà fait ailleurs (ex: au splash screen).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = AppStateScope.of(context);
      // On ne recharge que si ce n'est pas déjà fait (évite un appel
      // réseau inutile à chaque fois qu'on revient sur cet onglet).
      if (appState.userName == '...' && !appState.isProfileLoading) {
        appState.loadProfile();
      }
    });
  }

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
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: appState.isProfileLoading && appState.userName == '...'
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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

  // ---- Petit helper pour afficher une erreur sous forme de SnackBar ----
  void _showError(BuildContext context, Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.redColor),
    );
  }

  // ---- Navigation vers les pages de modification ----

  Future<void> _openEditName(BuildContext context, AppState appState) async {
    final newName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => EditNameScreen(currentName: appState.userName)),
    );
    if (newName != null && newName.trim().isNotEmpty) {
      try {
        await appState.updateUserName(newName.trim());
      } catch (e) {
        if (context.mounted) _showError(context, e);
      }
    }
  }

  Future<void> _openEditEmail(BuildContext context, AppState appState) async {
    final newEmail = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => EditEmailScreen(currentEmail: appState.userEmail)),
    );
    if (newEmail != null && newEmail.trim().isNotEmpty) {
      try {
        await appState.updateUserEmail(newEmail.trim());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Un email de confirmation a été envoyé à ta nouvelle adresse.'),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) _showError(context, e);
      }
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
      try {
        await appState.updateMonthlyIncome(newIncome);
      } catch (e) {
        if (context.mounted) _showError(context, e);
      }
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
      try {
        await appState.updateCurrency(newCurrency);
      } catch (e) {
        if (context.mounted) _showError(context, e);
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    await ProfileService().signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _exportData(BuildContext context, AppState appState) async {
    await exportProfilePdf(
      name: appState.userName,
      email: appState.userEmail,
      expensesCount: appState.expensesCount.toString(),
      monthsTracked: appState.monthsFollowed.toString(),
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
                      Expanded(
                        child: ProfileStatCard(
                          value: appState.expensesCount.toString(),
                          label: 'Dépenses',
                          valueColor: AppColors.roseColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ProfileStatCard(
                          value: appState.monthsFollowed.toString(),
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
              activeThumbColor: AppColors.darkmauveColor,
              onChanged: (value) async {
                try {
                  await appState.setDarkMode(value);
                } catch (e) {
                  if (context.mounted) _showError(context, e);
                }
              },
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
              activeThumbColor: AppColors.darkmauveColor,
              onChanged: (value) async {
                try {
                  await appState.setNotificationsOn(value);
                } catch (e) {
                  if (context.mounted) _showError(context, e);
                }
              },
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
        onTap: () => _exportData(context, appState),
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