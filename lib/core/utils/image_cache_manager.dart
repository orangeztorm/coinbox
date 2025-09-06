import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Utility class for managing image cache and memory optimization
class ImageCacheManager {
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const int maxCacheObjects = 200;

  /// Clear image cache when memory is low
  static Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
  }

  /// Get cache size in bytes
  static Future<int> getCacheSize() async {
    // Note: getCacheSize() is not available in all versions
    // This is a placeholder implementation
    return 0;
  }

  /// Get cache size in human readable format
  static Future<String> getCacheSizeFormatted() async {
    final size = await getCacheSize();
    if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  /// Clear cache if it exceeds the maximum size
  static Future<void> clearCacheIfNeeded() async {
    final cacheSize = await getCacheSize();
    if (cacheSize > maxCacheSize) {
      await clearCache();
    }
  }

  /// Configure cache settings for optimal performance
  static void configureCache() {
    // This can be called in main() to set up global cache settings
    // The cached_network_image package handles most configuration automatically
  }

  /// Preload important images to cache
  static Future<void> preloadCurrencyFlags(List<String> currencyCodes) async {
    for (final code in currencyCodes) {
      final flagUrl = _getFlagUrl(code);
      if (flagUrl.isNotEmpty) {
        try {
          await DefaultCacheManager().downloadFile(flagUrl);
        } catch (e) {
          // Ignore errors for preloading
        }
      }
    }
  }

  static String _getFlagUrl(String currencyCode) {
    // This should match the logic in CurrencyService
    // For now, using a simplified version
    return 'https://flagpedia.net/data/flags/w320/$currencyCode.webp';
  }
}
