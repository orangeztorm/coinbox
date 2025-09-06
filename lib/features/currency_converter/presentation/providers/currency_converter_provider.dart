import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coinbox/core/core.dart';
import 'package:coinbox/features/currency_converter/data/data.dart';
import 'package:coinbox/features/currency_converter/domain/domain.dart';

// Core dependencies
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Use the network provider from connectivity_provider
final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => ref.watch(networkCheckProvider),
);

// Data sources
final currencyRemoteDataSourceProvider = Provider<CurrencyRemoteDataSource>(
  (ref) =>
      CurrencyRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider)),
);

// Repository
final currencyRepositoryProvider = Provider(
  (ref) => CurrencyRepositoryImpl(
    remoteDataSource: ref.watch(currencyRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

// Use cases
final getSupportedCurrenciesProvider = Provider(
  (ref) => GetSupportedCurrencies(ref.watch(currencyRepositoryProvider)),
);

final getExchangeRateProvider = Provider(
  (ref) => GetExchangeRate(ref.watch(currencyRepositoryProvider)),
);

final convertCurrencyProvider = Provider(
  (ref) => ConvertCurrency(ref.watch(currencyRepositoryProvider)),
);
