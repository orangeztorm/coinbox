import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Comprehensive logging system with different levels
///
/// Note: This logger intentionally uses print() statements for visual terminal output
/// with beautiful formatting, colors, and borders. The print statements are suppressed
/// with lint ignores since they serve a specific purpose for developer experience.
///
/// For production builds, only developer.log() is used for structured logging.
class AppLogger {
  static bool _isEnabled = true;
  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.error;

  /// Enable or disable logging
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Set minimum log level
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Log debug information (development only)
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      final enhancedMessage = _addLocationInfo(message, stackTrace);
      _log(LogLevel.debug, enhancedMessage, error, stackTrace);
    }
  }

  /// Log general information
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  /// Log warnings
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    final enhancedMessage = _addLocationInfo(message, stackTrace);
    _log(LogLevel.warning, enhancedMessage, error, stackTrace);
  }

  /// Log errors
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    final enhancedMessage = _addLocationInfo(message, stackTrace);
    _log(LogLevel.error, enhancedMessage, error, stackTrace);
  }

  /// Log critical errors
  static void critical(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final enhancedMessage = _addLocationInfo(message, stackTrace);
    _log(LogLevel.critical, enhancedMessage, error, stackTrace);
  }

  /// Log network requests and responses
  static void network(String message, [Object? data]) {
    if (kDebugMode) {
      _log(LogLevel.network, message, data, null);
    }
  }

  /// Log API calls with detailed information
  static void api(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    Object? body,
    int? statusCode,
    Object? response,
    Duration? duration,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('🌐 API Call: $method $url');

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('📋 Headers: $headers');
    }

    if (body != null) {
      buffer.writeln('📤 Request Body: $body');
    }

    if (statusCode != null) {
      final emoji = _getStatusEmoji(statusCode);
      buffer.writeln('📊 Status: $emoji $statusCode');
    }

    if (response != null) {
      buffer.writeln('📥 Response: $response');
    }

    if (duration != null) {
      buffer.writeln('⏱️ Duration: ${duration.inMilliseconds}ms');
    }

    _log(LogLevel.network, buffer.toString().trim(), null, null);
  }

  /// Log repository operations
  static void repository(String operation, String result, [Object? data]) {
    if (kDebugMode) {
      _log(LogLevel.debug, '🗄️ Repository: $operation -> $result', data, null);
    }
  }

  /// Log use case operations
  static void useCase(String useCase, String result, [Object? data]) {
    if (kDebugMode) {
      _log(LogLevel.debug, '🎯 UseCase: $useCase -> $result', data, null);
    }
  }

  /// Log UI operations
  static void ui(String component, String action, [Object? data]) {
    if (kDebugMode) {
      _log(LogLevel.debug, '🎨 UI: $component - $action', data, null);
    }
  }

  /// Internal logging method
  static void _log(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    if (!_isEnabled || level.priority < _minLevel.priority) {
      return;
    }

    if (kDebugMode) {
      // In development, use developer.log for better debugging
      developer.log(
        message,
        time: DateTime.now(),
        level: level.priority,
        name: 'Coinbox',
        error: error,
        stackTrace: stackTrace,
      );

      // Also print to console with beautiful formatting
      _printFormattedLog(level, message, error, stackTrace);
    } else {
      // In production, only log errors and critical issues
      if (level.priority >= LogLevel.error.priority) {
        developer.log(
          message,
          time: DateTime.now(),
          level: level.priority,
          name: 'Coinbox',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  /// Print beautifully formatted log to console
  /// Note: Uses print statements intentionally for visual terminal output
  // ignore: avoid_print
  static void _printFormattedLog(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    final timestamp = DateTime.now();
    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}'
        '.${timestamp.millisecond.toString().padLeft(3, '0')}';

    // Calculate the width for the border
    final contentLines = message.split('\n');
    final errorLines = error?.toString().split('\n') ?? [];
    final allLines = [...contentLines, ...errorLines];
    final maxLength = allLines.fold(
      0,
      (max, line) => line.length > max ? line.length : max,
    );
    final borderWidth = (maxLength + 20).clamp(60, 120);

    // Create the border
    final topBorder = '┌${'─' * (borderWidth - 2)}┐';
    final bottomBorder = '└${'─' * (borderWidth - 2)}┘';
    final sideBorder = '│';

    // Color codes for different log levels
    final colorCode = _getColorCode(level);
    final resetColor = '\x1B[0m';

    // Print the formatted log with beautiful borders and colors
    // These print statements are intentional for visual terminal output

    // ignore: avoid_print
    print('$colorCode$topBorder$resetColor');

    // Header with emoji, level, and timestamp
    final header = '${level.emoji} ${level.displayName} - $timeStr';
    final headerPadding = ' ' * ((borderWidth - header.length - 4) ~/ 2);
    // ignore: avoid_print
    print(
      '$colorCode$sideBorder$headerPadding$header$headerPadding$sideBorder$resetColor',
    );

    // Separator line
    // ignore: avoid_print
    print(
      '$colorCode$sideBorder${'─' * (borderWidth - 2)}$sideBorder$resetColor',
    );

    // Message content
    for (final line in contentLines) {
      final paddedLine = ' $line'.padRight(borderWidth - 3);
      // ignore: avoid_print
      print('$colorCode$sideBorder$paddedLine$sideBorder$resetColor');
    }

    // Error details if present
    if (error != null) {
      // ignore: avoid_print
      print(
        '$colorCode$sideBorder${'─' * (borderWidth - 2)}$sideBorder$resetColor',
      );
      // ignore: avoid_print
      print(
        '$colorCode$sideBorder ${_getErrorTypeEmoji(error)} ERROR DETAILS:${' ' * (borderWidth - 18)}$sideBorder$resetColor',
      );

      for (final line in errorLines) {
        final paddedLine = ' $line'.padRight(borderWidth - 3);
        // ignore: avoid_print
        print('$colorCode$sideBorder$paddedLine$sideBorder$resetColor');
      }
    }

    // Stack trace if present (truncated for readability)
    if (stackTrace != null) {
      // ignore: avoid_print
      print(
        '$colorCode$sideBorder${'─' * (borderWidth - 2)}$sideBorder$resetColor',
      );
      // ignore: avoid_print
      print(
        '$colorCode$sideBorder 📍 STACK TRACE:${' ' * (borderWidth - 17)}$sideBorder$resetColor',
      );

      final stackLines = stackTrace
          .toString()
          .split('\n')
          .take(5); // Show only first 5 lines
      for (final line in stackLines) {
        final truncatedLine = line.length > borderWidth - 4
            ? '${line.substring(0, borderWidth - 7)}...'
            : line;
        final paddedLine = ' $truncatedLine'.padRight(borderWidth - 3);
        // ignore: avoid_print
        print('$colorCode$sideBorder$paddedLine$sideBorder$resetColor');
      }

      if (stackTrace.toString().split('\n').length > 5) {
        final moreLines =
            ' ... and ${stackTrace.toString().split('\n').length - 5} more lines';
        final paddedLine = moreLines.padRight(borderWidth - 3);
        // ignore: avoid_print
        print('$colorCode$sideBorder$paddedLine$sideBorder$resetColor');
      }
    }

    // ignore: avoid_print
    print('$colorCode$bottomBorder$resetColor');
    // ignore: avoid_print
    print(''); // Empty line for spacing
  }

  /// Get ANSI color code for log level
  static String _getColorCode(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '\x1B[36m'; // Cyan
      case LogLevel.info:
        return '\x1B[32m'; // Green
      case LogLevel.network:
        return '\x1B[34m'; // Blue
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
      case LogLevel.critical:
        return '\x1B[35m'; // Magenta
    }
  }

  /// Get emoji based on error type
  static String _getErrorTypeEmoji(Object error) {
    final errorType = error.runtimeType.toString().toLowerCase();
    if (errorType.contains('network') || errorType.contains('socket')) {
      return '🌐';
    }
    if (errorType.contains('timeout')) {
      return '⏱️';
    }
    if (errorType.contains('format') || errorType.contains('parsing')) {
      return '📝';
    }
    if (errorType.contains('server')) {
      return '🖥️';
    }
    if (errorType.contains('client')) {
      return '📱';
    }
    if (errorType.contains('auth') || errorType.contains('permission')) {
      return '🔐';
    }
    if (errorType.contains('rate') || errorType.contains('limit')) {
      return '🚦';
    }
    return '❌';
  }

  /// Get appropriate emoji for HTTP status code
  static String _getStatusEmoji(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return '✅';
    if (statusCode >= 300 && statusCode < 400) return '🔀';
    if (statusCode >= 400 && statusCode < 500) return '❌';
    if (statusCode >= 500) return '💥';
    return '❓';
  }

  /// Add location information (file path and line number) to the message
  static String _addLocationInfo(String message, StackTrace? stackTrace) {
    // If no stack trace provided, create one to get current location
    stackTrace ??= StackTrace.current;

    final location = _extractLocationFromStackTrace(stackTrace);
    if (location != null) {
      return '📍 $location\n$message';
    }
    return message;
  }

  /// Extract file path and line number from stack trace
  static String? _extractLocationFromStackTrace(StackTrace stackTrace) {
    try {
      final stackString = stackTrace.toString();
      final lines = stackString.split('\n');

      // Skip the first few lines which are usually the logger itself
      for (int i = 2; i < lines.length && i < 6; i++) {
        final line = lines[i].trim();

        // Look for lines that contain file paths (typically contain .dart)
        if (line.contains('.dart')) {
          // Extract file path and line number using regex
          final regex = RegExp(r'([^/\s]+\.dart):(\d+):(\d+)');
          final match = regex.firstMatch(line);

          if (match != null) {
            final fileName = match.group(1);
            final lineNumber = match.group(2);
            final columnNumber = match.group(3);
            return '$fileName:$lineNumber:$columnNumber';
          }

          // Fallback: try to extract just filename and line number
          final simpleRegex = RegExp(r'([^/\s]+\.dart):(\d+)');
          final simpleMatch = simpleRegex.firstMatch(line);

          if (simpleMatch != null) {
            final fileName = simpleMatch.group(1);
            final lineNumber = simpleMatch.group(2);
            return '$fileName:$lineNumber';
          }

          // If we can't parse it properly, just show the filename
          final dartIndex = line.indexOf('.dart');
          if (dartIndex != -1) {
            final start = line.lastIndexOf('/', dartIndex);
            final end = line.indexOf(':', dartIndex);
            if (start != -1 && end != -1) {
              return line.substring(start + 1, end);
            }
          }
        }
      }
    } catch (e) {
      // If we can't parse the stack trace, just return null
      return null;
    }

    return null;
  }
}

/// Log levels with priorities and display information
enum LogLevel {
  debug(0, 'DEBUG', '🐛'),
  info(1, 'INFO', 'ℹ️'),
  network(1, 'NETWORK', '🌐'),
  warning(2, 'WARNING', '⚠️'),
  error(3, 'ERROR', '❌'),
  critical(4, 'CRITICAL', '💥');

  const LogLevel(this.priority, this.displayName, this.emoji);

  final int priority;
  final String displayName;
  final String emoji;
}

/// Extension methods for easier logging
extension ObjectLogging on Object {
  /// Log this object as debug info
  void logDebug(String message) {
    AppLogger.debug('$runtimeType: $message', this);
  }

  /// Log this object as info
  void logInfo(String message) {
    AppLogger.info('$runtimeType: $message', this);
  }

  /// Log this object as error
  void logError(String message, [StackTrace? stackTrace]) {
    AppLogger.error('$runtimeType: $message', this, stackTrace);
  }
}

/// Extension methods for Exception logging
extension ExceptionLogging on Exception {
  /// Log this exception with context
  void logException(String context, [StackTrace? stackTrace]) {
    AppLogger.error('Exception in $context: $toString()', this, stackTrace);
  }
}

/// Logger configuration for different environments
class LoggerConfig {
  /// Configure logger for development
  static void configureForDevelopment() {
    AppLogger.setEnabled(true);
    AppLogger.setMinLevel(LogLevel.debug);
    AppLogger.info('🚀 Logger configured for development');
  }

  /// Configure logger for production
  static void configureForProduction() {
    AppLogger.setEnabled(true);
    AppLogger.setMinLevel(LogLevel.error);
    AppLogger.info('🔒 Logger configured for production');
  }

  /// Configure logger for testing
  static void configureForTesting() {
    AppLogger.setEnabled(false);
  }
}
