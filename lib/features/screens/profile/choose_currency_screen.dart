import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import 'currency_model.dart';

/// Page "Choisir un devise".
/// Reçoit le code de la devise actuelle via [selectedCode] (ex: 'EUR').
/// Dès qu'on clique sur une devise, on revient direct à la page précédente
/// en renvoyant l'objet Currency choisi (pas besoin de bouton "Enregistrer" ici,
/// comme sur la maquette).
class ChooseCurrencyScreen extends StatefulWidget {
  final String selectedCode;

  const ChooseCurrencyScreen({super.key, required this.selectedCode});

  @override
  State<ChooseCurrencyScreen> createState() => _ChooseCurrencyScreenState();
}

class _ChooseCurrencyScreenState extends State<ChooseCurrencyScreen> {
  late String _selectedCode;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.selectedCode;
  }

  // Filtre la liste selon ce que l'utilisateur tape dans la barre de recherche
  List<Currency> get _filteredCurrencies {
    if (_searchQuery.trim().isEmpty) return availableCurrencies;
    final query = _searchQuery.toLowerCase();
    return availableCurrencies
        .where((c) =>
            c.name.toLowerCase().contains(query) ||
            c.code.toLowerCase().contains(query))
        .toList();
  }

  void _selectCurrency(Currency currency) {
    Navigator.pop(context, currency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildSearchField(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _filteredCurrencies.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.dividerColor),
                  itemBuilder: (context, index) {
                    final currency = _filteredCurrencies[index];
                    final isSelected = currency.code == _selectedCode;
                    return _buildCurrencyRow(currency, isSelected);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
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
          const Text('Choisir un devise', style: AppStyles.editAppBarTitleStyle),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: AppStyles.inputTextStyle,
        decoration: InputDecoration(
          hintText: 'Rechercher une devise...',
          hintStyle: AppStyles.tileSubtitleStyle,
          prefixIcon: const Icon(Icons.search, color: AppColors.smalltextColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCurrencyRow(Currency currency, bool isSelected) {
    return InkWell(
      onTap: () => _selectCurrency(currency),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Radio<String>(
              value: currency.code,
              groupValue: _selectedCode,
              activeColor: AppColors.darkmauveColor,
              onChanged: (_) => _selectCurrency(currency),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currency.name, style: AppStyles.tileTitleStyle),
                  const SizedBox(height: 2),
                  Text('${currency.code} · ${currency.symbol}',
                      style: AppStyles.tileSubtitleStyle),
                ],
              ),
            ),
            Text(
              currency.symbol,
              style: AppStyles.tileTitleStyle.copyWith(
                color: isSelected ? AppColors.darkmauveColor : AppColors.smalltextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}