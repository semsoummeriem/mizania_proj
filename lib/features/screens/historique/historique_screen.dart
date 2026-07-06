import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/app_state_scope.dart';
import 'historique_styles.dart';
import 'widgets/expense_tile.dart';
import 'expense_detail_screen.dart';

/// Page "Historique" : liste de toutes les dépenses, groupées par jour,
/// avec navigation par mois, recherche et filtre par catégorie.
class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  // Mois affiché actuellement (par défaut : juin 2026, comme sur la maquette)
  DateTime _displayedMonth = DateTime(2026, 6);
  String _searchQuery = '';
  String _selectedCategory = 'Tout';

  static const List<String> _monthNames = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  // Filtre les dépenses : bon mois + bonne catégorie (si sélectionnée) + recherche texte
  List<Expense> _filteredExpenses(AppState appState) {
    return appState.expenses.where((e) {
      final sameMonth = e.date.year == _displayedMonth.year && e.date.month == _displayedMonth.month;
      final matchesCategory = _selectedCategory == 'Tout' || e.category == _selectedCategory;
      final matchesSearch = _searchQuery.trim().isEmpty ||
          e.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return sameMonth && matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Regroupe les dépenses par jour, avec un libellé "Aujourd'hui", "Hier" ou la date
  Map<String, List<Expense>> _groupByDay(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};
    // NOTE PÉDAGOGIQUE : "aujourd'hui" est fixé à la fin du mois affiché pour
    // coller à la maquette. Plus tard, on utilisera DateTime.now() une fois
    // que les dépenses seront ajoutées en temps réel.
    final referenceToday = DateTime(2026, 6, 30);

    for (final expense in expenses) {
      final dayOnly = DateTime(expense.date.year, expense.date.month, expense.date.day);
      final diff = referenceToday.difference(dayOnly).inDays;

      String label;
      if (diff == 0) {
        label = "Aujourd'hui — ${dayOnly.day} ${_monthNames[dayOnly.month - 1].toLowerCase()}";
      } else if (diff == 1) {
        label = "Hier — ${dayOnly.day} ${_monthNames[dayOnly.month - 1].toLowerCase()}";
      } else {
        label = '${dayOnly.day} ${_monthNames[dayOnly.month - 1].toLowerCase()}';
      }

      grouped.putIfAbsent(label, () => []).add(expense);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final symbol = appState.selectedCurrency.symbol;
    final filtered = _filteredExpenses(appState);
    final grouped = _groupByDay(filtered);

    final totalSpent = filtered.fold<double>(0, (sum, e) => sum + e.amount);
    final revenue = appState.monthlyIncome;
    final balance = revenue - totalSpent;

    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(appState, symbol, totalSpent, revenue, balance),
            const SizedBox(height: 16),
            _buildSearchField(),
            const SizedBox(height: 12),
            _buildCategoryFilters(appState),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('Aucune dépense pour ce mois.'))
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: grouped.entries.expand((entry) {
                        return [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 4),
                            child: Text(entry.key, style: HistoriqueStyles.dateSectionStyle),
                          ),
                          ...entry.value.map(
                            (expense) => ExpenseTile(
                              expense: expense,
                              currencySymbol: symbol,
                              onDetailTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExpenseDetailScreen(expenseId: expense.id),
                                ),
                              ),
                            ),
                          ),
                        ];
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ---- En-tête : image, titre, navigation par mois, 3 stat cards ----
  Widget _buildHeader(AppState appState, String symbol, double totalSpent, double revenue, double balance) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      child: Container(
        width: double.infinity,
        color: AppColors.purpleLightColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/historique_icon.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                children: [
                  const Text('Historique', style: HistoriqueStyles.monthLabelStyle),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _navArrowButton(Icons.chevron_left, _goToPreviousMonth),
                      const SizedBox(width: 16),
                      Text(
                        '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                        style: HistoriqueStyles.monthLabelStyle,
                      ),
                      const SizedBox(width: 16),
                      _navArrowButton(Icons.chevron_right, _goToNextMonth),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _statCard('DÉPENSES', '-${totalSpent.toStringAsFixed(2)} $symbol', AppColors.roseColor)),
                      const SizedBox(width: 8),
                      Expanded(child: _statCard('REVENU', '+${revenue.toStringAsFixed(0)} $symbol', AppColors.greenColor)),
                      const SizedBox(width: 8),
                      Expanded(child: _statCard('SOLDE', '${balance.toStringAsFixed(2)} $symbol', AppColors.amberColor)),
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

  Widget _navArrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: AppColors.darkmauveColor.withValues(alpha: 0.15), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.darkmauveColor, size: 20),
      ),
    );
  }

  Widget _statCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.darkmauveColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(label, style: HistoriqueStyles.statLabelStyle),
          const SizedBox(height: 4),
          Text(value, style: HistoriqueStyles.statValueStyle.copyWith(color: valueColor)),
        ],
      ),
    );
  }

  // ---- Barre de recherche ----
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(color: AppColors.cardBackgroundColor, borderRadius: BorderRadius.circular(16)),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: 'Rechercher une dépense...',
            prefixIcon: Icon(Icons.search, color: AppColors.smalltextColor),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ---- Chips de filtre par catégorie ----
  Widget _buildCategoryFilters(AppState appState) {
    final categories = ['Tout', ...appState.budgetCategories.map((c) => c.label)];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = categories[index];
          final isSelected = label == _selectedCategory;
          return ChoiceChip(
            label: Text(
              label,
              style: HistoriqueStyles.filterChipStyle.copyWith(
                color: isSelected ? AppColors.whiteColor : AppColors.bigtextColor,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.darkmauveColor,
            backgroundColor: AppColors.cardBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
            onSelected: (_) => setState(() => _selectedCategory = label),
          );
        },
      ),
    );
  }
}