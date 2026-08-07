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
  Currency(code: 'TND', name: 'Dinar tunisien', symbol: 'د.ت'),
  Currency(code: 'EGP', name: 'Livre égyptienne', symbol: 'E£'),
  Currency(code: 'SAR', name: 'Riyal saoudien', symbol: 'ر.س'),
  Currency(code: 'AED', name: 'Dirham des Émirats', symbol: 'د.إ'),
  Currency(code: 'QAR', name: 'Riyal qatari', symbol: 'ر.ق'),
  Currency(code: 'KWD', name: 'Dinar koweïtien', symbol: 'د.ك'),
  Currency(code: 'JOD', name: 'Dinar jordanien', symbol: 'د.ا'),
  Currency(code: 'TRY', name: 'Livre turque', symbol: '₺'),
  Currency(code: 'CHF', name: 'Franc suisse', symbol: 'Fr'),
  Currency(code: 'CAD', name: 'Dollar canadien', symbol: 'CA\$'),
  Currency(code: 'AUD', name: 'Dollar australien', symbol: 'AU\$'),
  Currency(code: 'JPY', name: 'Yen japonais', symbol: '¥'),
  Currency(code: 'CNY', name: 'Yuan chinois', symbol: '¥'),
  Currency(code: 'HKD', name: 'Dollar de Hong Kong', symbol: 'HK\$'),
  Currency(code: 'SGD', name: 'Dollar de Singapour', symbol: 'S\$'),
  Currency(code: 'KRW', name: 'Won sud-coréen', symbol: '₩'),
  Currency(code: 'INR', name: 'Roupie indienne', symbol: '₹'),
  Currency(code: 'RUB', name: 'Rouble russe', symbol: '₽'),
  Currency(code: 'PLN', name: 'Zloty polonais', symbol: 'zł'),
  Currency(code: 'SEK', name: 'Couronne suédoise', symbol: 'kr'),
  Currency(code: 'NOK', name: 'Couronne norvégienne', symbol: 'kr'),
  Currency(code: 'DKK', name: 'Couronne danoise', symbol: 'kr'),
  Currency(code: 'BRL', name: 'Real brésilien', symbol: 'R\$'),
  Currency(code: 'MXN', name: 'Peso mexicain', symbol: 'MX\$'),
  Currency(code: 'ZAR', name: 'Rand sud-africain', symbol: 'R'),
  Currency(code: 'NGN', name: 'Naira nigérian', symbol: '₦'),
  Currency(code: 'XOF', name: 'Franc CFA (UEMOA)', symbol: 'CFA'),
];