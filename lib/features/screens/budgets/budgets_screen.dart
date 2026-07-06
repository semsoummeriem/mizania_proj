import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/app_state_scope.dart';
import 'budget_styles.dart';
import 'widgets/budget_category_row.dart';

/// Page "Budget" : permet de répartir le revenu mensuel entre les catégories
/// de dépense, avec des présets de répartition ou une saisie manuelle.
class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  String _selectedPreset = 'Équilibré';

  // NOTE PÉDAGOGIQUE : ces présets sont des valeurs fixes pour l'instant,
  // pas encore de vrai calcul basé sur des pourcentages du revenu.
  // "Équilibré" correspond aux valeurs par défaut déjà dans AppState.
  static const Map<String, double> _balancedPreset = {
    'Nourriture': 400, 'Transport': 150, 'Logement': 500,
    'Loisirs': 200, 'Santé': 100, 'Autres': 120,
  };
  static const Map<String, double> _economPreset = {
    'Nourriture': 300, 'Transport': 100, 'Logement': 500,
    'Loisirs': 100, 'Santé': 100, 'Autres': 50,
  };

  void _applyPreset(String preset, AppState appState) {
    setState(() => _selectedPreset = preset);
    if (preset == 'Équilibré') {
      appState.applyBudgetPreset(_balancedPreset);
    } else if (preset == 'Économe') {
      appState.applyBudgetPreset(_economPreset);
    }
    // "Personnalisé" ne change rien : l'utilisateur ajuste chaque champ manuellement.
  }

  void _saveBudget() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget enregistré avec succès')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final symbol = appState.selectedCurrency.symbol;
    final totalAllocated = appState.totalAllocated;
    final unallocated = appState.unallocatedBudget;
    final progress = appState.monthlyIncome > 0
        ? (totalAllocated / appState.monthlyIncome).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(appState, symbol, unallocated),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('RÉPARTITION SUGGÉRÉE', style: BudgetStyles.sectionTitleStyle),
              ),
              const SizedBox(height: 12),
              _buildPresets(appState),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('BUDGET PAR CATÉGORIE', style: BudgetStyles.sectionTitleStyle),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: appState.budgetCategories
                      .map((category) => BudgetCategoryRow(
                            category: category,
                            monthlyIncome: appState.monthlyIncome,
                            onChanged: (value) {
                              setState(() {
                                appState.updateBudgetAllocation(category.label, value);
                                _selectedPreset = 'Personnalisé';
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              _buildTotalSummary(appState, symbol, totalAllocated, unallocated, progress),
              const SizedBox(height: 20),
              _buildSaveButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---- En-tête : image + carte revenu / non alloué ----
  Widget _buildHeader(AppState appState, String symbol, double unallocated) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      child: Container(
        width: double.infinity,
        color: AppColors.backgroundlightColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/budget_icon.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Définir mon budget', style: BudgetStyles.headerTitleStyle),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkmauveColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('REVENU MENSUEL', style: BudgetStyles.incomeLabelStyle),
                            const SizedBox(height: 4),
                            Text('${appState.monthlyIncome.toStringAsFixed(0)} $symbol', style: BudgetStyles.incomeAmountStyle),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Non alloué', style: BudgetStyles.unallocatedLabelStyle),
                            const SizedBox(height: 4),
                            Text(
                              '${unallocated >= 0 ? '+' : ''}${unallocated.toStringAsFixed(0)} $symbol',
                              style: BudgetStyles.unallocatedAmountStyle.copyWith(
                                color: unallocated >= 0 ? AppColors.greenColor : AppColors.roseColor,
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
          ],
        ),
      ),
    );
  }

  // ---- 3 boutons de présets ----
  Widget _buildPresets(AppState appState) {
    final presets = [
      {'title': '50/30/20', 'subtitle': 'Équilibré'},
      {'title': '70/20/10', 'subtitle': 'Économe'},
      {'title': 'Personnalisé', 'subtitle': 'Manuel'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: presets.map((preset) {
          final label = preset['subtitle']!;
          final isSelected = _selectedPreset == label;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: preset != presets.last ? 8 : 0),
              child: GestureDetector(
                onTap: () => _applyPreset(label, appState),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.darkmauveColor : AppColors.dividerColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        preset['title']!,
                        style: BudgetStyles.presetTitleStyle.copyWith(
                          color: isSelected ? AppColors.darkmauveColor : AppColors.bigtextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(label, style: BudgetStyles.presetSubtitleStyle),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---- Résumé total alloué + barre de progression ----
  Widget _buildTotalSummary(AppState appState, String symbol, double totalAllocated, double unallocated, double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardBackgroundColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total alloué', style: BudgetStyles.totalLabelStyle),
              Text(
                '${totalAllocated.toStringAsFixed(0)} $symbol / ${appState.monthlyIncome.toStringAsFixed(0)} $symbol',
                style: BudgetStyles.totalValueStyle,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                unallocated < 0 ? AppColors.roseColor : AppColors.greenColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            unallocated >= 0
                ? '${unallocated.toStringAsFixed(0)} $symbol non alloués — ils iront en épargne'
                : '${(-unallocated).toStringAsFixed(0)} $symbol de dépassement par rapport au revenu',
            style: BudgetStyles.noteStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _saveBudget,
          icon: const Icon(Icons.check, color: AppColors.whiteColor),
          label: const Text('Enregistrer le budget', style: BudgetStyles.saveButtonStyle),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkmauveColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }
}