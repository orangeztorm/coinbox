import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Helper class to eliminate repetitive validation in use cases
class UseCaseTryCatchHelper {
  /// Validates inputs and executes action if validation passes
  Future<Either<Failure, T>> validateAndExecute<T>({
    required List<ValidationFailure?> validations,
    required Future<Either<Failure, T>> Function() action,
  }) async {
    // Check for validation failures
    for (final validation in validations) {
      if (validation != null) {
        return Left(validation);
      }
    }

    // All validations passed, execute the action
    return await action();
  }

  /// Synchronous validation and execution
  Either<Failure, T> validateAndExecuteSync<T>({
    required List<ValidationFailure?> validations,
    required Either<Failure, T> Function() action,
  }) {
    // Check for validation failures
    for (final validation in validations) {
      if (validation != null) {
        return Left(validation);
      }
    }

    // All validations passed, execute the action
    return action();
  }
}
