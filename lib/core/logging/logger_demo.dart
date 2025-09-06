import 'package:flutter/foundation.dart';
import 'app_logger.dart';

/// Demo class to showcase the beautiful logging system
/// Run this to see how the logs will appear in your terminal
class LoggerDemo {
  static void runDemo() {
    if (!kDebugMode) return;

    AppLogger.info('🎯 Logger Demo Started');

    // Demo different log levels
    AppLogger.debug('This is a debug message with some detailed information');
    AppLogger.info('Application initialized successfully');
    AppLogger.warning(
      'This is a warning about something that might need attention',
    );

    // Demo API logging
    AppLogger.api(
      'GET',
      'https://api.exchangerate-api.com/v4/latest/USD',
      headers: {'Content-Type': 'application/json'},
      statusCode: 200,
      response: {'success': true, 'data': 'mock response'},
      duration: const Duration(milliseconds: 245),
    );

    // Demo network logging
    AppLogger.network('Currency conversion request', {
      'from': 'USD',
      'to': 'EUR',
      'amount': 100.0,
    });

    // Demo repository logging
    AppLogger.repository('getCurrencies', 'Success', {
      'count': 168,
      'cached': true,
    });

    // Demo use case logging
    AppLogger.useCase('ConvertCurrency', 'Validation passed', {
      'from': 'USD',
      'to': 'EUR',
      'amount': 100.0,
    });

    // Demo UI logging
    AppLogger.ui('CurrencyDropdown', 'Selection changed', {
      'previous': 'USD',
      'selected': 'EUR',
    });

    // Demo error logging with stack trace
    try {
      throw Exception('This is a demo exception to show error formatting');
    } catch (e, s) {
      AppLogger.error('Demo error occurred in currency conversion', e, s);
    }

    // Demo error without stack trace (will auto-generate location)
    AppLogger.error('Validation failed for currency input');

    // Demo warning with location
    AppLogger.warning('API rate limit approaching threshold');

    // Demo critical error
    AppLogger.critical(
      'Critical system error detected',
      Exception('Database connection failed'),
      StackTrace.current,
    );

    AppLogger.info('🏁 Logger Demo Completed');
  }
}

/// Extension to easily run the demo
extension AppLoggerDemo on AppLogger {
  static void runDemo() => LoggerDemo.runDemo();
}
