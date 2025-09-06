import 'dart:async';
import 'package:coinbox/core/core.dart';
import 'package:coinbox/features/currency_converter/domain/domain.dart';
import 'package:coinbox/features/currency_converter/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Provider for managing currency conversion state
final conversionProvider =
    StateNotifierProvider<ConversionNotifier, ConversionData>((ref) {
      final convertCurrencyUseCase = ref.watch(convertCurrencyProvider);
      return ConversionNotifier(convertCurrencyUseCase);
    });

/// Notifier for handling currency conversion logic with debouncing
class ConversionNotifier extends StateNotifier<ConversionData> {
  final ConvertCurrency _convertCurrencyUseCase;
  Timer? _debounceTimer;

  // Debounce duration - wait 500ms after user stops typing
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  ConversionNotifier(this._convertCurrencyUseCase)
    : super(ConversionData.initial());

  /// Updates the from amount and triggers debounced conversion
  void updateFromAmount(String amount) {
    if (amount == state.fromAmount) return;

    state = state.copyWith(fromAmount: amount);
    _debouncedConvert();
  }

  /// Updates the from currency and triggers conversion if possible
  void updateFromCurrency(Currency currency) {
    if (currency == state.fromCurrency) return;

    state = state.copyWith(fromCurrency: currency);
    _debouncedConvert();
  }

  /// Updates the to currency and triggers conversion if possible
  void updateToCurrency(Currency currency) {
    if (currency == state.toCurrency) return;

    state = state.copyWith(toCurrency: currency);
    _debouncedConvert();
  }

  /// Swaps the from and to currencies
  void swapCurrencies() {
    final fromCurrency = state.fromCurrency;
    final toCurrency = state.toCurrency;

    if (fromCurrency != null && toCurrency != null) {
      state = state.copyWith(
        fromCurrency: toCurrency,
        toCurrency: fromCurrency,
      );
      _debouncedConvert();
    }
  }

  /// Manually triggers conversion (useful for retry scenarios)
  void convert() {
    _performConversion();
  }

  /// Clears any pending debounced conversion
  void clearDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  /// Debounced conversion - waits for user to stop typing
  void _debouncedConvert() {
    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Only convert if we have valid data
    if (!state.canConvert) {
      AppLogger.debug('Conversion skipped: Invalid data');
      return;
    }

    // Set up new timer
    _debounceTimer = Timer(_debounceDuration, () {
      _performConversion();
    });

    AppLogger.debug('Debounced conversion scheduled');
  }

  /// Performs the actual currency conversion
  Future<void> _performConversion() async {
    if (!state.canConvert) {
      AppLogger.debug('Conversion skipped: Invalid data');
      return;
    }

    final fromAmount = state.fromAmount!;
    final fromCurrency = state.fromCurrency!;
    final toCurrency = state.toCurrency!;

    // Validate amount limit
    final amount = double.tryParse(fromAmount);
    if (amount == null || amount > 999999999.99) {
      AppLogger.error('Conversion failed: Amount cannot exceed 999,999,999.99');
      state = ConversionData.failure(
        fromAmount: fromAmount,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        errorMessage: 'Amount cannot exceed 999,999,999.99',
      );
      return;
    }

    AppLogger.info(
      'Starting conversion: $fromAmount ${fromCurrency.code} to ${toCurrency.code}',
    );

    // Set loading state
    state = ConversionData.loading(
      fromAmount: fromAmount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );

    try {
      // Perform the conversion
      final result = await _convertCurrencyUseCase(
        fromCurrency: fromCurrency.code,
        toCurrency: toCurrency.code,
        amount: double.parse(fromAmount),
      );

      result.fold(
        (failure) {
          AppLogger.error('Conversion failed: ${failure.message}');
          state = ConversionData.failure(
            fromAmount: fromAmount,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            errorMessage: failure.message,
          );
        },
        (conversionResult) {
          AppLogger.info(
            'Conversion successful: ${conversionResult.convertedAmount}',
          );
          state = ConversionData.success(
            fromAmount: fromAmount,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            convertedAmount: conversionResult.convertedAmount.toStringAsFixed(
              2,
            ),
            exchangeRate: conversionResult.conversionRate,
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during conversion', e, stackTrace);
      state = ConversionData.failure(
        fromAmount: fromAmount,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Provider for getting the current conversion state
final conversionStateProvider = Provider<ConversionState>((ref) {
  return ref.watch(conversionProvider).state;
});

/// Provider for getting the converted amount
final convertedAmountProvider = Provider<String?>((ref) {
  final conversionData = ref.watch(conversionProvider);
  return conversionData.convertedAmount;
});

/// Provider for getting the exchange rate
final exchangeRateProvider = Provider<double?>((ref) {
  final conversionData = ref.watch(conversionProvider);
  return conversionData.exchangeRate;
});

/// Provider for checking if conversion is loading
final isConversionLoadingProvider = Provider<bool>((ref) {
  return ref.watch(conversionProvider).state.isLoading;
});

/// Provider for checking if conversion can be performed
final canConvertProvider = Provider<bool>((ref) {
  return ref.watch(conversionProvider).canConvert;
});
