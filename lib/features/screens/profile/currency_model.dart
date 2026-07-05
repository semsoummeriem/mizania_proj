/// Représente une devise : son code (EUR, USD...), son nom complet et son symbole.
class Currency {
  final String code;
  final String name;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });
}

/// Liste des devises proposées dans l'app.
/// Pour en ajouter une nouvelle plus tard, il suffit d'ajouter une ligne ici.
const List<Currency> availableCurrencies = [
  Currency(code: 'EUR', name: 'Euro', symbol: '€'),
  Currency(code: 'USD', name: 'Dollar américain', symbol: '\$'),
  Currency(code: 'GBP', name: 'Livre sterling', symbol: '£'),
  Currency(code: 'DZD', name: 'Dinar algérien', symbol: 'د.ج'),
  Currency(code: 'MAD', name: 'Dirham marocain', symbol: 'د.م'),
  Currency(code: 'CHF', name: 'Franc suisse', symbol: 'Fr'),
  Currency(code: 'JPY', name: 'Yen japonais', symbol: '¥'),
  Currency(code: 'CAD', name: 'Dollar canadien', symbol: 'CA\$'),
  Currency(code: 'CNY', name: 'Yuan chinois', symbol: '¥'),
];