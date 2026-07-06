import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import 'widgets/profile_stat_card.dart';
import 'widgets/account_info_tile.dart';
import 'widgets/preference_tile.dart';
import 'edit_name_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Pour l'instant on garde ces valeurs "en dur" dans le state local.
  // Plus tard elles viendront d'une vraie logique (provider / backend).
  // TODO: remplacer par le vrai nom venant de la page de connexion
  String userName = 'Yacine Amrani';
  bool isDarkMode = false;
  bool notificationsOn = false;
  bool exportChecked = false;

  // Ouvre la page "Modifier le nom" et récupère le nouveau nom si l'utilisateur a enregistré.
  // C'est cette fonction qui met à jour le nom PARTOUT dans la page (header + section compte),
  // car les deux endroits lisent la même variable `userName`.
  Future<void> _openEditName() async {
    final newName = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => EditNameScreen(currentName: userName),
      ),
    );

    if (newName != null && newName.trim().isNotEmpty) {
      setState(() => userName = newName.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('COMPTE'),
                    const SizedBox(height: 12),
                    _buildAccountCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('PRÉFÉRENCES'),
                    const SizedBox(height: 12),
                    _buildPreferencesCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('DONNÉES'),
                    const SizedBox(height: 12),
                    _buildExportCard(),
                    const SizedBox(height: 20),
                    _buildLogoutButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            CustomBottomNavBar(
              currentIndex: 3, // 3 = onglet "Profil"
              onTap: (index) {
                // TODO: naviguer vers Home / Historique / Budgets selon l'index
              },
              onAddTap: () {
                // TODO: naviguer vers la page "Ajouter une dépense"
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---- En-tête fond clair : image en grand format, nom, email, statistiques ----
  Widget _buildHeader() {
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
            // L'image en grand format, en fond, bien visible sur fond clair
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
            // Le contenu (nom, email, stats) par-dessus l'image
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Le nom vient de la variable userName, donc il se met à jour automatiquement
                  Text(
                    userName,
                    style: AppStyles.profileNameStyle.copyWith(color: AppColors.bigtextColor),
                  ),
                  const SizedBox(height: 4),
                  // TODO: remplacer par le vrai email venant de la page de connexion
                  Text(
                    'yacine.amrani@gmail.com',
                    style: AppStyles.profileEmailStyle.copyWith(color: AppColors.smalltextColor),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: ProfileStatCard(
                          value: '247',
                          label: 'Dépenses',
                          valueColor: AppColors.roseColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ProfileStatCard(
                          value: '8',
                          label: 'Mois suivis',
                          valueColor: AppColors.greenColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ProfileStatCard(
                          value: '2 000 €',
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
  Widget _buildAccountCard() {
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
            subtitle: userName,
            onModifierTap: _openEditName,
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          AccountInfoTile(
            icon: Icons.mail_outline,
            iconBackground: AppColors.blueLightColor,
            title: 'email',
            subtitle: 'yacine.amrani@gmail.com',
            onModifierTap: () {
              // TODO: ouvrir la page/modale "modifier l'email"
            },
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          AccountInfoTile(
            icon: Icons.lock_outline,
            iconBackground: AppColors.purpleLightColor,
            title: 'mot de passe',
            subtitle: 'Dernière modif. il y a 3 mois',
            onModifierTap: () {
              // TODO: ouvrir la page/modale "modifier le mot de passe"
            },
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          AccountInfoTile(
            icon: Icons.attach_money,
            iconBackground: AppColors.orangeLightColor,
            title: 'revenu mensuel',
            subtitle: '2 000 € / mois',
            onModifierTap: () {
              // TODO: ouvrir la page/modale "modifier le revenu"
            },
          ),
        ],
      ),
    );
  }

  // ---- Carte "PRÉFÉRENCES" ----
  Widget _buildPreferencesCard() {
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
            subtitle: 'Euro (€)',
            trailing: TextButton(
              onPressed: () {
                // TODO: ouvrir le sélecteur de devise
              },
              child: const Text('Modifier'),
            ),
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          PreferenceTile(
            icon: Icons.wb_sunny_outlined,
            iconBackground: AppColors.orangeLightColor,
            title: 'Apparence',
            subtitle: isDarkMode ? 'Mode sombre' : 'Mode clair',
            trailing: Switch(
              value: isDarkMode,
              activeThumbColor: AppColors.darkmauveColor,
              onChanged: (value) => setState(() => isDarkMode = value),
            ),
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          PreferenceTile(
            icon: Icons.notifications_none,
            iconBackground: AppColors.purpleLightColor,
            title: 'Notifications',
            subtitle: 'Alertes budget activées',
            trailing: Switch(
              value: notificationsOn,
              activeThumbColor: AppColors.darkmauveColor,
              onChanged: (value) => setState(() => notificationsOn = value),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Carte "Exporter mes données" ----
  Widget _buildExportCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
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
          Checkbox(
            value: exportChecked,
            activeColor: AppColors.darkmauveColor,
            onChanged: (value) => setState(() => exportChecked = value ?? false),
          ),
        ],
      ),
    );
  }

  // ---- Bouton "Se déconnecter" ----
  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: déconnecter l'utilisateur et revenir à la première page de l'app
        },
        icon: const Icon(Icons.logout, color: AppColors.darkmauveColor, size: 18),
        label: const Text(
          'Se déconnecter',
          style: TextStyle(
            color: AppColors.darkmauveColor,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.plusJakartaSans,
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