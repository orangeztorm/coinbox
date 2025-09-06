import 'package:coinbox/core/core.dart';
import 'package:coinbox/features/currency_converter/data/models/models.dart';

abstract class CurrencyRemoteDataSource {
  Future<List<CurrencyModel>> getSupportedCurrencies();
  Future<ExchangeRateModel> getExchangeRate(
    String baseCurrency,
    String targetCurrency,
  );
  Future<ConversionResultModel> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final ApiClient apiClient;
  final DataSourceTryCatchHelper _helper = DataSourceTryCatchHelper();

  CurrencyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CurrencyModel>> getSupportedCurrencies() async {
    AppLogger.info('Fetching supported currencies from API');
    return _helper.tryApiAction(() async {
      final endpoint = '/${ApiConstants.apiKey}/codes';
      final response = await apiClient.get(endpoint);

      return _helper.parseJsonResponse(response, (json) {
        final supportedCodes = json['supported_codes'] as List<dynamic>;
        final currencies = supportedCodes
            .map((currencyData) => CurrencyModel.fromJson(currencyData))
            .toList();
        AppLogger.info(
          'Successfully fetched ${currencies.length} supported currencies',
        );
        return currencies;
      });
    });
  }

  @override
  Future<ExchangeRateModel> getExchangeRate(
    String baseCurrency,
    String targetCurrency,
  ) async {
    AppLogger.info('Fetching exchange rate: $baseCurrency → $targetCurrency');
    return _helper.tryApiAction(() async {
      final endpoint =
          '/${ApiConstants.apiKey}/pair/$baseCurrency/$targetCurrency';
      final response = await apiClient.get(endpoint);

      return _helper.parseJsonResponse(response, (json) {
        final exchangeRate = ExchangeRateModel.fromJson(json);
        AppLogger.info(
          'Exchange rate fetched: 1 $baseCurrency = ${exchangeRate.rate} $targetCurrency',
        );
        return exchangeRate;
      });
    });
  }

  @override
  Future<ConversionResultModel> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    AppLogger.info('Converting currency: $amount $fromCurrency → $toCurrency');
    return _helper.tryApiAction(() async {
      final endpoint = '/${ApiConstants.apiKey}/pair/$fromCurrency/$toCurrency';
      final response = await apiClient.get(endpoint);

      return _helper.parseJsonResponse(response, (json) {
        final exchangeRate = ExchangeRateModel.fromJson(json);
        final result = ConversionResultModel.fromCalculation(
          baseCode: fromCurrency,
          targetCode: toCurrency,
          baseAmount: amount,
          conversionRate: exchangeRate.rate,
        );
        AppLogger.info(
          'Currency conversion successful: $amount $fromCurrency = ${result.convertedAmount} $toCurrency (rate: ${exchangeRate.rate})',
        );
        return result;
      });
    });
  }
}
