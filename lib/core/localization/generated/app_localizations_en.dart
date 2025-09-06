// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Currency Converter';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get amount => 'Amount';

  @override
  String get convert => 'Convert';

  @override
  String get result => 'Result';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get conversionResult => 'Conversion Result';

  @override
  String get error => 'Error';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get invalidAmount => 'Please enter a valid amount';

  @override
  String get loading => 'Loading...';

  @override
  String get swapCurrencies => 'Swap currencies';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String get exchangeRate => 'Exchange Rate';

  @override
  String get indicativeExchangeRate => 'Indicative Exchange Rate';

  @override
  String get fromCurrencyLabel => 'From Currency';

  @override
  String get toCurrencyLabel => 'To Currency';

  @override
  String get noCurrenciesFound => 'No currencies found';

  @override
  String get tryDifferentSearch => 'Try searching with a different term';

  @override
  String get failedToLoadCurrencies => 'Failed to load currencies';

  @override
  String get retry => 'Retry';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get networkStatusUnknown => 'Network status unknown';

  @override
  String get amountCannotExceed => 'Amount cannot exceed 999,999,999.99';

  @override
  String get appSubheader =>
      'Check live rates, set rate alerts, receive notifications and more.';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get amountMustBeGreaterThanZero => 'Amount must be greater than 0';

  @override
  String get amountIsTooLarge => 'Amount is too large';

  @override
  String get pleaseSelectCurrency => 'Please select a currency';

  @override
  String get pleaseSelectDifferentCurrency =>
      'Please select a different currency';

  @override
  String get invalidCurrencyCode => 'Invalid currency code';
}
