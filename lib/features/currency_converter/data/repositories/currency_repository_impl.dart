import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final RepoTryCatchHelper _tryCatchHelper = RepoTryCatchHelper();

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Currency>>> getSupportedCurrencies() async {
    return _tryCatchHelper.tryNetworkAction(
      isConnected: () => networkInfo.isConnected,
      action: () async {
        final currencyModels = await remoteDataSource.getSupportedCurrencies();
        return currencyModels.map((model) => model.toEntity()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, ExchangeRate>> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    return _tryCatchHelper.tryNetworkAction(
      isConnected: () => networkInfo.isConnected,
      action: () async {
        final exchangeRateModel = await remoteDataSource.getExchangeRate(
          fromCurrency,
          toCurrency,
        );
        return exchangeRateModel.toEntity();
      },
    );
  }

  @override
  Future<Either<Failure, ConversionResult>> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    return _tryCatchHelper.tryNetworkAction(
      isConnected: () => networkInfo.isConnected,
      action: () async {
        final result = await remoteDataSource.convertCurrency(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          amount: amount,
        );
        return result.toEntity();
      },
    );
  }

  @override
  Future<Either<Failure, ExchangeRate>> getHistoricalRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime date,
  }) async {
    // This would require a different API endpoint or service
    // For now, return a not implemented failure
    return const Left(InternalServerFailure('501'));
  }
}
