// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Conversor de Moneda';

  @override
  String get from => 'De';

  @override
  String get to => 'A';

  @override
  String get amount => 'Cantidad';

  @override
  String get convert => 'Convertir';

  @override
  String get result => 'Resultado';

  @override
  String get selectCurrency => 'Seleccionar Moneda';

  @override
  String get enterAmount => 'Ingrese cantidad';

  @override
  String get conversionResult => 'Resultado de Conversión';

  @override
  String get error => 'Error';

  @override
  String get networkError => 'Error de red. Por favor verifique su conexión.';

  @override
  String get invalidAmount => 'Por favor ingrese una cantidad válida';

  @override
  String get loading => 'Cargando...';

  @override
  String get swapCurrencies => 'Intercambiar monedas';

  @override
  String get lastUpdated => 'Última actualización';

  @override
  String get exchangeRate => 'Tipo de Cambio';

  @override
  String get indicativeExchangeRate => 'Tipo de Cambio Indicativo';

  @override
  String get fromCurrencyLabel => 'De Moneda';

  @override
  String get toCurrencyLabel => 'A Moneda';

  @override
  String get noCurrenciesFound => 'No se encontraron monedas';

  @override
  String get tryDifferentSearch => 'Intenta buscar con un término diferente';

  @override
  String get failedToLoadCurrencies => 'Error al cargar monedas';

  @override
  String get retry => 'Reintentar';

  @override
  String get noInternetConnection => 'Sin conexión a internet';

  @override
  String get networkStatusUnknown => 'Estado de red desconocido';

  @override
  String get amountCannotExceed =>
      'La cantidad no puede exceder 999,999,999.99';

  @override
  String get appSubheader =>
      'Consulta tasas en vivo, configura alertas de tasa, recibe notificaciones y más.';

  @override
  String get pleaseEnterAmount => 'Por favor ingrese una cantidad';

  @override
  String get pleaseEnterValidNumber => 'Por favor ingrese un número válido';

  @override
  String get amountMustBeGreaterThanZero => 'La cantidad debe ser mayor que 0';

  @override
  String get amountIsTooLarge => 'La cantidad es demasiado grande';

  @override
  String get pleaseSelectCurrency => 'Por favor seleccione una moneda';

  @override
  String get pleaseSelectDifferentCurrency =>
      'Por favor seleccione una moneda diferente';

  @override
  String get invalidCurrencyCode => 'Código de moneda inválido';
}
