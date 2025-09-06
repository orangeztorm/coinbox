import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetExchangeRate {
  final CurrencyRepository repository;
  final UseCaseTryCatchHelper _helper = UseCaseTryCatchHelper();

  GetExchangeRate(this.repository);

  Future<Either<Failure, ExchangeRate>> call({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    return _helper.validateAndExecute(
      validations: [
        _validateCurrency(fromCurrency),
        _validateCurrency(toCurrency),
      ],
      action: () => repository.getExchangeRate(
        fromCurrency: fromCurrency.toUpperCase(),
        toCurrency: toCurrency.toUpperCase(),
      ),
    );
  }

  ValidationFailure? _validateCurrency(String currency) {
    if (currency.isEmpty || currency.length != 3) {
      return const ValidationFailure('Invalid currency code');
    }
    return null;
  }
}
