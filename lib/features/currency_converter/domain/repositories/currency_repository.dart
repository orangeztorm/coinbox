import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/entities.dart';

abstract class CurrencyRepository {
  /// Get list of supported currencies
  Future<Either<Failure, List<Currency>>> getSupportedCurrencies();

  /// Get exchange rate between two currencies
  Future<Either<Failure, ExchangeRate>> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  });

  /// Convert amount from one currency to another
  Future<Either<Failure, ConversionResult>> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });

  /// Get historical exchange rate (if needed for future features)
  Future<Either<Failure, ExchangeRate>> getHistoricalRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime date,
  });
}
