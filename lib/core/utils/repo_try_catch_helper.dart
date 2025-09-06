import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';
import '../errors/exceptions.dart';
import '../logging/app_logger.dart';

/// Helper class to eliminate repetitive try-catch blocks in repositories
class RepoTryCatchHelper {
  /// Executes an action and converts exceptions to appropriate failures
  Future<Either<Failure, T>> tryAction<T>(Future<T> Function() action) async {
    try {
      final T result = await action();
      return Right(result);
    } on TypeError catch (e, stackTrace) {
      _logError(e, stackTrace);
      return const Left(ParsingFailure('data'));
    } on FormatException catch (e, stackTrace) {
      _logError(e, stackTrace);
      return const Left(ParsingFailure('response format'));
    } on TimeoutException catch (e, stackTrace) {
      _logError(e, stackTrace);
      return const Left(ConnectionTimeoutFailure());
    } on SocketException catch (e, stackTrace) {
      _logError(e, stackTrace);
      return const Left(NoInternetConnectionFailure());
    } on ServerException catch (e, stackTrace) {
      _logError(e, stackTrace);
      return Left(ApiResponseFailure(e.message, e.code));
    } on NetworkException catch (e, stackTrace) {
      _logError(e, stackTrace);
      return Left(NetworkRequestFailure(e.message, e.code));
    } on InvalidApiKeyException catch (e, stackTrace) {
      _logError(e, stackTrace);
      return Left(InvalidApiKeyFailure(e.code));
    } on UnsupportedCurrencyException catch (e, stackTrace) {
      _logError(e, stackTrace);
      return Left(UnsupportedCurrencyFailure('currency', e.code));
    } on RateLimitException catch (e, stackTrace) {
      _logError(e, stackTrace);
      return Left(RateLimitExceededFailure(e.code));
    } catch (e, stackTrace) {
      _logError(e, stackTrace);

      if (e is Failure) {
        return Left(e);
      }

      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  /// Network-aware action that checks connectivity first
  Future<Either<Failure, T>> tryNetworkAction<T>({
    required Future<bool> Function() isConnected,
    required Future<T> Function() action,
  }) async {
    if (await isConnected()) {
      return tryAction(action);
    } else {
      return const Left(NoInternetConnectionFailure());
    }
  }

  void _logError(dynamic error, StackTrace stackTrace) {
    AppLogger.repository('Error occurred', 'Failed with exception', {
      'error': error.toString(),
      'type': error.runtimeType.toString(),
    });
    AppLogger.error('Repository operation failed', error, stackTrace);
  }
}
