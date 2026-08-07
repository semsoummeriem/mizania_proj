import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/expense_service.dart';
import '../../../core/services/supabase_client.dart';
import 'historique_styles.dart';
import 'historique_screen.dart' show CategoryOption, iconFromName, colorFromHex;

/// Page "Detail d'une depense".
/// Charge la dépense depuis Supabase à partir de son ID, et permet de :
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
  final ExpenseService _expenseService = ExpenseService();

  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;

  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late double _amount; // pas éditable ici, mais gardé pour ne pas l'écraser à l'enregistrement

  int? _selectedCategoryId;
  String _selectedCategoryName = '';
  IconData _selectedCategoryIcon = Icons.category_outlined;
  Color _selectedCategoryColor = AppColors.darkmauveColor;

  List<CategoryOption> _categories = [];

  static const List<String> _monthNames = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    // Charge la liste des catégories (pour le sélecteur) + la dépense elle-même en parallèle
    final categoriesData = await supabase.from('categories').select('id, name, icon, color');
    final expenseRow = await supabase
        .from('depense')
        .select('id, description, amount, date, category_id, categories(id, name, icon, color)')
        .eq('id', int.parse(widget.expenseId))
        .single();

    final categoryData = expenseRow['categories'] as Map<String, dynamic>?;

    setState(() {
      _categories = List<Map<String, dynamic>>.from(categoriesData).map((row) {
        return CategoryOption(
          id: row['id'] as int,
          name: row['name'] as String,
          icon: iconFromName(row['icon'] as String),
          color: colorFromHex(row['color'] as String),
        );
      }).toList();

      _descriptionController.text = (expenseRow['description'] as String?) ?? '';
      _amount = (expenseRow['amount'] as num).toDouble();
      _selectedDate = DateTime.parse(expenseRow['date'] as String);
      _selectedCategoryId = expenseRow['category_id'] as int?;
      _selectedCategoryName = (categoryData?['name'] as String?) ?? 'Autres';
      _selectedCategoryIcon = iconFromName((categoryData?['icon'] as String?) ?? 'category');
      _selectedCategoryColor = colorFromHex((categoryData?['color'] as String?) ?? '#9E9E9E');

      _isLoading = false;
    });
  }

  Future<void> _pickCategory() async {
    final chosen = await showModalBottomSheet<CategoryOption>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _categories
                .map((c) => ListTile(
                      leading: Icon(c.icon, color: AppColors.darkmauveColor),
                      title: Text(c.name),
                      onTap: () => Navigator.pop(context, c),
                    ))
                .toList(),
          ),
        );
      },
    );
    if (chosen != null) {
      setState(() {
        _selectedCategoryId = chosen.id;
        _selectedCategoryName = chosen.name;
        _selectedCategoryIcon = chosen.icon;
        _selectedCategoryColor = chosen.color;
      });
    }
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

  Future<void> _saveChanges() async {
    if (_selectedCategoryId == null) return;
    setState(() => _isSaving = true);
    try {
      await _expenseService.updateExpense(
        id: int.parse(widget.expenseId),
        amount: _amount,
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
      );
      if (!mounted) return;
      setState(() {
        _isEditing = false;
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dépense mise à jour')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour : $e')),
      );
    }
  }

  Future<void> _confirmDelete() async {
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
      setState(() => _isSaving = true);
      try {
        await _expenseService.deleteExpense(int.parse(widget.expenseId));
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                  _buildCategoryField(),
                  const SizedBox(height: 20),
                  const Text('DATE', style: HistoriqueStyles.dateSectionStyle),
                  const SizedBox(height: 8),
                  _buildDateField(),
                  const SizedBox(height: 32),
                  _buildDeleteButton(),
                  const SizedBox(height: 12),
                  _buildEditButton(),
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

  Widget _buildCategoryField() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _isEditing ? _pickCategory : null,
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
              decoration: BoxDecoration(
                color: _selectedCategoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_selectedCategoryIcon, size: 18, color: AppColors.darkmauveColor),
            ),
            const SizedBox(width: 12),
            Text(_selectedCategoryName, style: HistoriqueStyles.expenseCategoryStyle),
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

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSaving ? null : _confirmDelete,
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

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSaving
            ? null
            : () {
                if (_isEditing) {
                  _saveChanges();
                } else {
                  setState(() => _isEditing = true);
                }
              },
        icon: _isSaving
            ? const SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.whiteColor),
              )
            : Icon(_isEditing ? Icons.check : Icons.edit_outlined, color: AppColors.whiteColor),
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