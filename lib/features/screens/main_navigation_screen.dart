import 'package:flutter/material.dart';
import '../../core/widgets/custom_bottom_nav_bar.dart';
import '../../core/state/app_state_scope.dart';
import 'home/home_screen.dart';
import 'historique/historique_screen.dart';
import 'budgets/budgets_screen.dart';
import 'profile/profile_screen.dart';
import '../gestion/screens/gestion.dart';

/// Page "coquille" : contient la barre de navigation en bas et bascule entre
/// les 4 onglets (Home, Historique, Budgets, Profil).
///
/// On utilise IndexedStack au lieu de juste afficher une seule page à la fois :
/// IndexedStack garde TOUTES les pages en mémoire (juste cachées), donc si tu
/// scrolles sur Home puis vas sur Profil puis reviens sur Home, tu retrouves
/// ta position de scroll au lieu de repartir du haut.
///
/// IMPORTANT : comme les pages restent vivantes en permanence, leur
/// chargement initial (loadProfile(), loadBudgetCategories()...) ne se
/// déclenche qu'une seule fois. Il faut donc explicitement forcer un
/// rechargement après toute action qui change les données ailleurs — ici,
/// après l'ajout d'une dépense via le bouton "+", qui influence à la fois
/// les stats du Profil (nombre de dépenses) et le budget (montant dépensé
/// par catégorie, donc les alertes de dépassement).
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _goToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // On donne à HomeScreen une fonction pour aller vers l'onglet Historique
          // quand on clique sur "Voir tout".
          HomeScreen(onSeeAllPressed: () => _goToTab(1)),
          const HistoriqueScreen(),
          const BudgetsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
        onAddTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Gestion()),
          );

          // On rafraîchit le budget (dépenses par catégorie + alertes de
          // dépassement) et les stats du profil, au cas où une dépense a
          // été ajoutée. Un rechargement "pour rien" si l'utilisateur a
          // annulé ne coûte pas grand-chose, donc pas besoin de vérifier
          // précisément si une dépense a été ajoutée.
          if (context.mounted) {
            final appState = AppStateScope.of(context);
            await appState.loadHomeData();
            if (context.mounted) {
              await appState.loadBudgetCategories();
            }
            if (context.mounted) {
              await appState.loadProfile();
            }
          }

          if (result != null && result is int) {
            setState(() => _currentIndex = result);
          }
        },
      ),
    );
  }
}