import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

/// Barre de navigation réutilisable dans toute l'application.
/// [currentIndex] permet de savoir quel onglet est sélectionné.
/// [onTap] est appelé quand on clique sur Home / Historique / Budgets / Profil.
/// [onAddTap] est appelé quand on clique sur le bouton "+" au milieu.
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(icon: Icons.home_rounded, label: 'Home', index: 0),
          _navItem(icon: Icons.access_time_rounded, label: 'Historique', index: 1),
          _addButton(),
          _navItem(icon: Icons.pie_chart_outline_rounded, label: 'Budgets', index: 2),
          _navItem(icon: Icons.person_outline_rounded, label: 'Profil', index: 3),
        ],
      ),
    );
  }

  Widget _navItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = currentIndex == index;
    final Color color = isSelected ? AppColors.darkmauveColor : AppColors.smalltextColor;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(label, style: AppStyles.statLabelStyle.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: onAddTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.darkmauveColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: AppColors.whiteColor, size: 26),
      ),
    );
  }
}