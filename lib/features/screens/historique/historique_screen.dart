import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/app_state_scope.dart';
import '../../../core/services/expense_service.dart';
import '../../../core/services/supabase_client.dart';
import 'historique_styles.dart';
import 'widgets/expense_tile.dart';
import 'expense_detail_screen.dart';

/// Une catégorie telle que stockée dans Supabase (table `categories`),
/// convertie en IconData/Color utilisables par Flutter.
class CategoryOption {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// Convertit le nom d'icône stocké en base (ex: "fastfood") en IconData Flutter.
/// Complète cette liste si tu ajoutes de nouvelles catégories avec une autre icône.
IconData iconFromName(String name) {
  switch (name) {
    case 'fastfood':
      return Icons.fastfood_outlined;
    case 'directions_car':
      return Icons.directions_car_outlined;
    case 'local_pharmacy':
      return Icons.local_pharmacy_outlined;
    case 'sports_esports':
      return Icons.sports_esports_outlined;
    default:
      return Icons.category_outlined;
  }
}

/// Convertit une couleur hexadécimale ("#EC4899") stockée en base en Color Flutter.
Color colorFromHex(String hex) {
  final cleaned = hex.replaceAll('#', '');
  return Color(int.parse('FF$cleaned', radix: 16));
}

/// Page "Historique" : liste de toutes les dépenses, groupées par jour,
/// avec navigation par mois, recherche et filtre par catégorie.
class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  final ExpenseService _expenseService = ExpenseService();

  DateTime _displayedMonth = DateTime.now();
  String _searchQuery = '';
  String _selectedCategory = 'Tout';

  bool _isLoading = true;
  List<Expense> _expenses = [];
  List<CategoryOption> _categories = [];

  double _totalSpent = 0;
  double _revenue = 0;
  double _balance = 0;

  static const List<String> _monthNames = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadCategories();
    await _loadData();
  }

  // Charge une seule fois la liste des catégories (pour les chips de filtre
  // et pour convertir category_id <-> nom de catégorie).
  Future<void> _loadCategories() async {
    final data = await supabase.from('categories').select('id, name, icon, color');
    setState(() {
      _categories = List<Map<String, dynamic>>.from(data).map((row) {
        return CategoryOption(
          id: row['id'] as int,
          name: row['name'] as String,
          icon: iconFromName(row['icon'] as String),
          color: colorFromHex(row['color'] as String),
        );
      }).toList();
    });
  }

  // Retrouve l'id Supabase correspondant au nom de catégorie sélectionné dans les chips.
  int? _selectedCategoryId() {
    if (_selectedCategory == 'Tout') return null;
    final match = _categories.where((c) => c.name == _selectedCategory);
    return match.isEmpty ? null : match.first.id;
  }

  // Recharge le résumé (Dépenses/Revenu/Solde) ET la liste des dépenses,
  // en fonction du mois, de la catégorie et de la recherche actuels.
  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final resume = await _expenseService.getResumeMensuel(
      year: _displayedMonth.year,
      month: _displayedMonth.month,
    );

    final rows = await _expenseService.getDepensesDuMois(
      year: _displayedMonth.year,
      month: _displayedMonth.month,
      categoryId: _selectedCategoryId(),
      search: _searchQuery,
    );

    setState(() {
      _totalSpent = (resume['total_depenses'] as num).toDouble();
      _revenue = (resume['revenu_mensuel'] as num).toDouble();
      _balance = (resume['solde'] as num).toDouble();
      _expenses = rows.map(_expenseFromRow).toList();
      _isLoading = false;
    });
  }

  // Convertit une ligne brute Supabase (avec la catégorie jointe) en objet Expense.
  Expense _expenseFromRow(Map<String, dynamic> row) {
    final categoryData = row['categories'] as Map<String, dynamic>?;
    final categoryName = categoryData?['name'] as String? ?? 'Autres';
    final iconName = categoryData?['icon'] as String? ?? 'category';
    final colorHex = categoryData?['color'] as String? ?? '#9E9E9E';
    final color = colorFromHex(colorHex);

    return Expense(
      id: row['id'].toString(),
      description: (row['description'] as String?) ?? '',
      category: categoryName,
      icon: iconFromName(iconName),
      iconBackground: color.withValues(alpha: 0.15),
      date: DateTime.parse(row['date'] as String),
      amount: (row['amount'] as num).toDouble(),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
    _loadData();
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
    _loadData();
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _loadData();
  }

  void _onCategorySelected(String label) {
    setState(() => _selectedCategory = label);
    _loadData();
  }

  // Regroupe les dépenses par jour, avec un libellé "Aujourd'hui", "Hier" ou la date
  Map<String, List<Expense>> _groupByDay(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};
    final today = DateTime.now();
    final referenceToday = DateTime(today.year, today.month, today.day);

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
    final grouped = _groupByDay(_expenses);

    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(symbol),
            const SizedBox(height: 16),
            _buildSearchField(),
            const SizedBox(height: 12),
            _buildCategoryFilters(),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _expenses.isEmpty
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
                                  onDetailTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ExpenseDetailScreen(expenseId: expense.id),
                                      ),
                                    );
                                    // Recharge au retour (au cas où la dépense a été modifiée/supprimée)
                                    _loadData();
                                  },
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
  Widget _buildHeader(String symbol) {
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
                      Expanded(child: _statCard('DÉPENSES', '-${_totalSpent.toStringAsFixed(2)} $symbol', AppColors.roseColor)),
                      const SizedBox(width: 8),
                      Expanded(child: _statCard('REVENU', '+${_revenue.toStringAsFixed(0)} $symbol', AppColors.greenColor)),
                      const SizedBox(width: 8),
                      Expanded(child: _statCard('SOLDE', '${_balance.toStringAsFixed(2)} $symbol', AppColors.amberColor)),
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
          onChanged: _onSearchChanged,
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
  Widget _buildCategoryFilters() {
    final labels = ['Tout', ..._categories.map((c) => c.name)];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = labels[index];
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
            onSelected: (_) => _onCategorySelected(label),
          );
        },
      ),
    );
  }
}