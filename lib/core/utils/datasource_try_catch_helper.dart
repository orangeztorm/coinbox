import 'dart:async';
import 'dart:io';
import '../errors/exceptions.dart';
import '../logging/app_logger.dart';

/// Helper class to eliminate repetitive try-catch blocks in data sources
/// Converts low-level errors to domain-specific exceptions
class DataSourceTryCatchHelper {
  /// Executes an API action and converts errors to appropriate exceptions
  Future<T> tryApiAction<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on TimeoutException catch (e, stackTrace) {
      _logError(e, stackTrace);
      throw const NetworkException('Request timeout');
    } on SocketException catch (e, stackTrace) {
      _logError(e, stackTrace);
      throw const NetworkException('No internet connection');
    } on FormatException catch (e, stackTrace) {
      _logError(e, stackTrace);
      throw ServerException('Invalid response format: ${e.message}');
    } on TypeError catch (e, stackTrace) {
      _logError(e, stackTrace);
      throw ServerException('Failed to parse response data: $e');
    } catch (e, stackTrace) {
      _logError(e, stackTrace);

      // Re-throw if it's already a domain exception
      if (e is ServerException ||
          e is NetworkException ||
          e is InvalidApiKeyException ||
          e is UnsupportedCurrencyException ||
          e is RateLimitException) {
        rethrow;
      }

      // Convert unknown errors to ServerException
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  /// Validates API response and throws appropriate exception if invalid
  void validateApiResponse(Map<String, dynamic> response) {
    if (response['result'] != 'success') {
      final errorType = response['error-type'] as String?;
      final errorMessage =
          response['error-message'] as String? ?? 'Unknown error';

      switch (errorType) {
        case 'invalid-key':
        case 'inactive-account':
          throw InvalidApiKeyException(errorMessage, errorType);
        case 'quota-reached':
          throw RateLimitException('API quota exceeded', errorType);
        case 'unsupported-code':
          throw UnsupportedCurrencyException(errorMessage, errorType);
        case 'malformed-request':
          throw ServerException('Malformed request: $errorMessage', errorType);
        default:
          throw ServerException(errorMessage, errorType);
      }
    }
  }

  /// Parses JSON response with error handling
  T parseJsonResponse<T>(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) parser,
  ) {
    try {
      validateApiResponse(response);
      return parser(response);
    } on FormatException catch (e) {
      throw ServerException('Failed to parse JSON response: ${e.message}');
    } catch (e) {
      if (e is ServerException ||
          e is InvalidApiKeyException ||
          e is UnsupportedCurrencyException ||
          e is RateLimitException) {
        rethrow;
      }
      throw ServerException('Failed to parse response: $e');
    }
  }

  void _logError(dynamic error, StackTrace stackTrace) {
    AppLogger.network('DataSource operation failed', {
      'error': error.toString(),
      'type': error.runtimeType.toString(),
      'layer': 'Data Source',
    });
    AppLogger.error('DataSource exception occurred', error, stackTrace);
  }
}
