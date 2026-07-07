import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/app_state_scope.dart';
import 'historique_styles.dart';

/// Page "Detail d'une depense".
/// Reçoit l'ID de la dépense, la retrouve dans AppState, et permet de :
/// - la voir (description, catégorie, date)
/// - la modifier (les champs deviennent éditables)
/// - la supprimer (avec confirmation)
class ExpenseDetailScreen extends StatefulWidget {
  final String expenseId;

  const ExpenseDetailScreen({super.key, required this.expenseId});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  bool _isEditing = false;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late DateTime _selectedDate;

  static const List<String> _monthNames = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  @override
  void initState() {
    super.initState();
    // On initialise les champs une seule fois, à l'ouverture de la page.
    // (fait dans didChangeDependencies pour pouvoir lire l'AppState en toute sécurité)
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = AppStateScope.of(context);
      final expense = appState.expenses.firstWhere((e) => e.id == widget.expenseId);
      _descriptionController = TextEditingController(text: expense.description);
      _selectedCategory = expense.category;
      _selectedDate = expense.date;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickCategory(AppState appState) async {
    final categories = appState.budgetCategories;
    final chosen = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories
                .map((c) => ListTile(
                      leading: Icon(c.icon, color: AppColors.darkmauveColor),
                      title: Text(c.label),
                      onTap: () => Navigator.pop(context, c.label),
                    ))
                .toList(),
          ),
        );
      },
    );
    if (chosen != null) setState(() => _selectedCategory = chosen);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _saveChanges(AppState appState) {
    appState.updateExpense(
      widget.expenseId,
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      date: _selectedDate,
    );
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dépense mise à jour')),
    );
  }

  Future<void> _confirmDelete(AppState appState) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la dépense ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: AppColors.redColor)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      appState.deleteExpense(widget.expenseId);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    if (!_initialized) return const Scaffold(body: SizedBox());

    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DESCRIPTION', style: HistoriqueStyles.dateSectionStyle),
                  const SizedBox(height: 8),
                  _buildDescriptionField(),
                  const SizedBox(height: 20),
                  const Text('CATÉGORIE', style: HistoriqueStyles.dateSectionStyle),
                  const SizedBox(height: 8),
                  _buildCategoryField(appState),
                  const SizedBox(height: 20),
                  const Text('DATE', style: HistoriqueStyles.dateSectionStyle),
                  const SizedBox(height: 8),
                  _buildDateField(),
                  const SizedBox(height: 32),
                  _buildDeleteButton(appState),
                  const SizedBox(height: 12),
                  _buildEditButton(appState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
          const Text(
            "Detail d'une depense",
            style: TextStyle(color: AppColors.whiteColor, fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    if (!_isEditing) {
      return _readonlyBox(_descriptionController.text);
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkmauveColor, width: 1.5),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 2,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryField(AppState appState) {
    final category = appState.budgetCategories.firstWhere(
      (c) => c.label == _selectedCategory,
      orElse: () => appState.budgetCategories.first,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _isEditing ? () => _pickCategory(appState) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: _isEditing ? Border.all(color: AppColors.darkmauveColor, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: category.iconBackground, borderRadius: BorderRadius.circular(10)),
              child: Icon(category.icon, size: 18, color: AppColors.darkmauveColor),
            ),
            const SizedBox(width: 12),
            Text(_selectedCategory, style: HistoriqueStyles.expenseCategoryStyle),
            if (_isEditing) ...[
              const Spacer(),
              const Icon(Icons.expand_more, color: AppColors.smalltextColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    final formatted = '${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}';
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _isEditing ? _pickDate : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: _isEditing ? Border.all(color: AppColors.darkmauveColor, width: 1.5) : null,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: AppColors.darkmauveColor),
            const SizedBox(width: 12),
            Text(formatted, style: HistoriqueStyles.expenseCategoryStyle),
          ],
        ),
      ),
    );
  }

  Widget _readonlyBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: AppColors.cardBackgroundColor, borderRadius: BorderRadius.circular(16)),
      child: Text(value),
    );
  }

  Widget _buildDeleteButton(AppState appState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _confirmDelete(appState),
        icon: const Icon(Icons.delete_outline, color: AppColors.whiteColor),
        label: const Text('Supprimer la depense', style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkmauveColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildEditButton(AppState appState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (_isEditing) {
            _saveChanges(appState);
          } else {
            setState(() => _isEditing = true);
          }
        },
        icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined, color: AppColors.whiteColor),
        label: Text(
          _isEditing ? 'Enregistrer les modifications' : 'Modifier la depense',
          style: const TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkmauveColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}