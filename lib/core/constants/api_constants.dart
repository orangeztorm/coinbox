class ApiConstants {
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String apiKey =
      '5432b7aae90f6301cb2263ed'; // Replace with actual API key
  static const String latestRatesEndpoint = '/latest';
  static const String pairConversionEndpoint = '/pair';
  static const String codesEndpoint = '/codes';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // API endpoints
  static String getLatestRates(String baseCurrency) =>
      '$baseUrl/$apiKey$latestRatesEndpoint/$baseCurrency';

  static String getPairConversion(String from, String to) =>
      '$baseUrl/$apiKey$pairConversionEndpoint/$from/$to';

  static String getSupportedCodes() => '$baseUrl/$apiKey$codesEndpoint';
}
