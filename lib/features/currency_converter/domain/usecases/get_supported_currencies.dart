import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

class GetSupportedCurrencies {
  final CurrencyRepository repository;

  GetSupportedCurrencies(this.repository);

  Future<Either<Failure, List<Currency>>> call() async {
    return await repository.getSupportedCurrencies();
  }
}
