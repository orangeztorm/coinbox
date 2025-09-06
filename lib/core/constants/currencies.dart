class SupportedCurrencies {
  static const Map<String, CurrencyInfo> currencies = {
    'USD': CurrencyInfo('US Dollar', '\$', '🇺🇸'),
    'EUR': CurrencyInfo('Euro', '€', '🇪🇺'),
    'GBP': CurrencyInfo('British Pound', '£', '🇬🇧'),
    'JPY': CurrencyInfo('Japanese Yen', '¥', '🇯🇵'),
    'AUD': CurrencyInfo('Australian Dollar', 'A\$', '🇦🇺'),
    'CAD': CurrencyInfo('Canadian Dollar', 'C\$', '🇨🇦'),
    'CHF': CurrencyInfo('Swiss Franc', 'Fr', '🇨🇭'),
    'CNY': CurrencyInfo('Chinese Yuan', '¥', '🇨🇳'),
    'SEK': CurrencyInfo('Swedish Krona', 'kr', '🇸🇪'),
    'NZD': CurrencyInfo('New Zealand Dollar', 'NZ\$', '🇳🇿'),
    'MXN': CurrencyInfo('Mexican Peso', '\$', '🇲🇽'),
    'SGD': CurrencyInfo('Singapore Dollar', 'S\$', '🇸🇬'),
    'HKD': CurrencyInfo('Hong Kong Dollar', 'HK\$', '🇭🇰'),
    'NOK': CurrencyInfo('Norwegian Krone', 'kr', '🇳🇴'),
    'TRY': CurrencyInfo('Turkish Lira', '₺', '🇹🇷'),
    'RUB': CurrencyInfo('Russian Ruble', '₽', '🇷🇺'),
    'INR': CurrencyInfo('Indian Rupee', '₹', '🇮🇳'),
    'BRL': CurrencyInfo('Brazilian Real', 'R\$', '🇧🇷'),
    'ZAR': CurrencyInfo('South African Rand', 'R', '🇿🇦'),
    'KRW': CurrencyInfo('South Korean Won', '₩', '🇰🇷'),
  };

  static List<String> get currencyCodes => currencies.keys.toList();

  static CurrencyInfo? getCurrencyInfo(String code) => currencies[code];

  static String getCurrencyName(String code) => currencies[code]?.name ?? code;

  static String getCurrencySymbol(String code) =>
      currencies[code]?.symbol ?? code;

  static String getCurrencyFlag(String code) => currencies[code]?.flag ?? '';
}

class CurrencyInfo {
  final String name;
  final String symbol;
  final String flag;

  const CurrencyInfo(this.name, this.symbol, this.flag);
}
