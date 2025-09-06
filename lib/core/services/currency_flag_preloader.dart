import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'currency_service.dart';
import '../logging/app_logger.dart';

/// Service for preloading currency flags to improve user experience
class CurrencyFlagPreloader {
  // Most commonly used currencies
  static const List<String> _commonCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'INR',
    'KRW',
    'SGD',
    'HKD',
    'MYR',
    'THB',
    'PHP',
    'IDR',
    'BRL',
    'MXN',
    'ARS',
    'COP',
    'PEN',
    'CLP',
    'UYU',
    'PYG',
    'NOK',
    'SEK',
    'DKK',
    'PLN',
    'CZK',
    'HUF',
    'RON',
    'BGN',
    'AED',
    'SAR',
    'QAR',
    'KWD',
    'BHD',
    'OMR',
    'JOD',
    'LBP',
    'ZAR',
    'EGP',
    'MAD',
    'DZD',
    'TND',
    'LYD',
    'NGN',
    'GHS',
  ];

  /// Preload common currency flags
  static Future<void> preloadCommonFlags() async {
    final futures = <Future>[];

    for (final currencyCode in _commonCurrencies) {
      final flagUrl = CurrencyService.getFlagUrl(currencyCode, size: 320);
      if (flagUrl.isNotEmpty) {
        futures.add(_preloadImage(flagUrl, currencyCode));
      }
    }

    // Preload all images concurrently
    await Future.wait(futures, eagerError: false);
  }

  /// Preload specific currency flags
  static Future<void> preloadCurrencies(List<String> currencyCodes) async {
    final futures = <Future>[];

    for (final currencyCode in currencyCodes) {
      final flagUrl = CurrencyService.getFlagUrl(currencyCode, size: 320);
      if (flagUrl.isNotEmpty) {
        futures.add(_preloadImage(flagUrl, currencyCode));
      }
    }

    await Future.wait(futures, eagerError: false);
  }

  /// Preload a single image
  static Future<void> _preloadImage(String url, String currencyCode) async {
    try {
      await DefaultCacheManager().downloadFile(url);
    } catch (e) {
      // Ignore errors for preloading - it's not critical
      AppLogger.debug('Failed to preload flag for $currencyCode: $e');
    }
  }

  /// Clear all cached flags
  static Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
  }

  /// Get cache size (placeholder implementation)
  static Future<int> getCacheSize() async {
    // Note: getCacheSize() is not available in all versions
    // This is a placeholder implementation
    return 0;
  }
}
