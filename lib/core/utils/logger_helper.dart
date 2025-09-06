import '../logging/app_logger.dart';

/// Legacy logger helper - now delegates to AppLogger
/// @deprecated Use AppLogger directly instead
class LoggerHelper {
  /// @deprecated Use AppLogger.error() instead
  static void log(dynamic error, [StackTrace? stackTrace]) {
    AppLogger.error('$error', error, stackTrace);
  }

  /// @deprecated Use AppLogger.info() instead
  static void logInfo(String message) {
    AppLogger.info(message);
  }

  /// @deprecated Use AppLogger.warning() instead
  static void logWarning(String message) {
    AppLogger.warning(message);
  }
}
