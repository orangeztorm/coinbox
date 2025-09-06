import 'package:intl/intl.dart';
import '../constants/currencies.dart';

class CurrencyFormatter {
  static final Map<String, NumberFormat> _formatters = {};

  /// Format currency amount with proper symbol and decimal places
  static String formatCurrency(
    double amount,
    String currencyCode, {
    String? locale,
  }) {
    final key = '${currencyCode}_${locale ?? 'en'}';

    if (!_formatters.containsKey(key)) {
      _formatters[key] = NumberFormat.currency(
        locale: locale ?? 'en_US',
        symbol: SupportedCurrencies.getCurrencySymbol(currencyCode),
        decimalDigits: _getDecimalPlaces(currencyCode),
      );
    }

    return _formatters[key]!.format(amount);
  }

  /// Format currency amount without symbol
  static String formatAmount(
    double amount,
    String currencyCode, {
    String? locale,
  }) {
    final decimalPlaces = _getDecimalPlaces(currencyCode);
    final formatter = NumberFormat.decimalPattern(locale ?? 'en_US');
    formatter.minimumFractionDigits = decimalPlaces;
    formatter.maximumFractionDigits = decimalPlaces;

    return formatter.format(amount);
  }

  /// Get decimal places for a currency
  static int _getDecimalPlaces(String currencyCode) {
    // Currencies that don't use decimal places
    const noDecimalCurrencies = ['JPY', 'KRW', 'VND', 'CLP'];

    if (noDecimalCurrencies.contains(currencyCode.toUpperCase())) {
      return 0;
    }

    return 2;
  }

  /// Parse currency string to double
  static double? parseCurrency(String value) {
    if (value.isEmpty) return null;

    // Remove currency symbols and spaces
    final cleanValue = value
        .replaceAll(RegExp(r'[^\d.,\-+]'), '')
        .replaceAll(',', '.');

    return double.tryParse(cleanValue);
  }

  /// Format exchange rate
  static String formatExchangeRate(
    double rate,
    String fromCurrency,
    String toCurrency,
  ) {
    final formatter = NumberFormat('#,##0.######');
    return '1 $fromCurrency = ${formatter.format(rate)} $toCurrency';
  }

  /// Format percentage change
  static String formatPercentageChange(double percentage) {
    final formatter = NumberFormat('+#,##0.00%;-#,##0.00%');
    return formatter.format(percentage / 100);
  }
}
