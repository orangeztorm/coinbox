import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class ConvertCurrency {
  final CurrencyRepository repository;
  final UseCaseTryCatchHelper _helper = UseCaseTryCatchHelper();

  ConvertCurrency(this.repository);

  Future<Either<Failure, ConversionResult>> call({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    return _helper.validateAndExecute(
      validations: [
        _validateCurrency(fromCurrency, 'source'),
        _validateCurrency(toCurrency, 'target'),
        _validateAmount(amount),
      ],
      action: () => repository.convertCurrency(
        fromCurrency: fromCurrency.toUpperCase(),
        toCurrency: toCurrency.toUpperCase(),
        amount: amount,
      ),
    );
  }

  ValidationFailure? _validateCurrency(String currency, String type) {
    if (currency.isEmpty || currency.length != 3) {
      return ValidationFailure('Invalid $type currency code');
    }
    return null;
  }

  ValidationFailure? _validateAmount(double amount) {
    if (amount <= 0) {
      return const ValidationFailure('Amount must be greater than 0');
    }

    if (amount < AppConstants.minAmount) {
      return ValidationFailure(
        'Amount must be at least ${AppConstants.minAmount}',
      );
    }

    if (amount > AppConstants.maxAmount) {
      return ValidationFailure(
        'Amount cannot exceed ${AppConstants.maxAmount}',
      );
    }

    return null;
  }
}
