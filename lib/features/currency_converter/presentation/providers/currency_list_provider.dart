import 'package:coinbox/features/currency_converter/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coinbox/features/currency_converter/domain/domain.dart';

final currencyListProvider = FutureProvider<List<Currency>>((ref) async {
  final getSupportedCurrencies = ref.watch(getSupportedCurrenciesProvider);
  final result = await getSupportedCurrencies();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (currencies) => currencies,
  );
});
