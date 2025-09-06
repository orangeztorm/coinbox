import 'package:equatable/equatable.dart';

/// Base failure class for the application
/// All failures should extend this class instead of throwing exceptions
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final DateTime? timestamp;

  const Failure(this.message, [this.code, this.timestamp]);

  Failure.withTimestamp(this.message, [this.code]) 
      : timestamp = DateTime.now();

  @override
  List<Object?> get props => [message, code, timestamp];

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

// Network-related failures
abstract class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

class ConnectionTimeoutFailure extends NetworkFailure {
  const ConnectionTimeoutFailure([String? code])
    : super('Connection timeout. Please check your internet connection.', code);
}

class NoInternetConnectionFailure extends NetworkFailure {
  const NoInternetConnectionFailure([String? code])
    : super('No internet connection available.', code);
}

class NetworkRequestFailure extends NetworkFailure {
  const NetworkRequestFailure(super.message, [super.code]);
}

// Server-related failures
abstract class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

class InternalServerFailure extends ServerFailure {
  const InternalServerFailure([String? code])
    : super('Internal server error occurred.', code);
}

class InvalidApiKeyFailure extends ServerFailure {
  const InvalidApiKeyFailure([String? code])
    : super('Invalid API key provided.', code);
}

class RateLimitExceededFailure extends ServerFailure {
  const RateLimitExceededFailure([String? code])
    : super('API rate limit exceeded. Please try again later.', code);
}

class UnsupportedCurrencyFailure extends ServerFailure {
  const UnsupportedCurrencyFailure(String currency, [String? code])
    : super('Currency $currency is not supported.', code);
}

class ApiResponseFailure extends ServerFailure {
  const ApiResponseFailure(super.message, [super.code]);
}

// Client-side failures
abstract class ClientFailure extends Failure {
  const ClientFailure(super.message, [super.code]);
}

class ValidationFailure extends ClientFailure {
  const ValidationFailure(super.message, [super.code]);
}

class CacheFailure extends ClientFailure {
  const CacheFailure(super.message, [super.code]);
}

class ParsingFailure extends ClientFailure {
  const ParsingFailure(String dataType, [String? code])
    : super('Failed to parse $dataType data.', code);
}

// General failures
class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'An unknown error occurred.',
    super.code,
  ]);
}
