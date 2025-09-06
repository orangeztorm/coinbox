/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
}

/// Exception thrown when there's a network error
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

/// Exception thrown when API key is invalid
class InvalidApiKeyException extends AppException {
  const InvalidApiKeyException(super.message, [super.code]);
}

/// Exception thrown when currency is not supported
class UnsupportedCurrencyException extends AppException {
  const UnsupportedCurrencyException(super.message, [super.code]);
}

/// Exception thrown when rate limit is exceeded
class RateLimitException extends AppException {
  const RateLimitException(super.message, [super.code]);
}
