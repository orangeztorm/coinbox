import 'package:coinbox/features/currency_converter/domain/domain.dart';
import 'package:coinbox/features/currency_converter/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Provider for managing the amount text controller
final amountControllerProvider = StateProvider<TextEditingController>((ref) {
  final controller = TextEditingController();

  // Don't listen to conversion data changes to avoid overwriting formatted text
  // The controller will be managed by the formatter and user input

  // Clean up controller when provider is disposed
  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});

/// Provider for managing the from currency selection
final fromCurrencyProvider = StateProvider<Currency?>((ref) {
  // Initialize with a default currency (e.g., USD)
  return null; // Will be set when currencies are loaded
});

/// Provider for managing the to currency selection
final toCurrencyProvider = StateProvider<Currency?>((ref) {
  // Initialize with a default currency (e.g., EUR)
  return null; // Will be set when currencies are loaded
});

/// Provider for managing the amount value
final amountProvider = StateProvider<String>((ref) {
  return '';
});

/// Provider that combines form state and validation
final formStateProvider = Provider<FormState>((ref) {
  final amount = ref.watch(amountProvider);
  final fromCurrency = ref.watch(fromCurrencyProvider);
  final toCurrency = ref.watch(toCurrencyProvider);
  final validationState = ref.watch(formValidationProvider);
  final conversionData = ref.watch(conversionProvider);

  return FormState(
    amount: amount,
    fromCurrency: fromCurrency,
    toCurrency: toCurrency,
    validationState: validationState,
    conversionData: conversionData,
  );
});

/// Represents the complete form state
class FormState {
  final String amount;
  final Currency? fromCurrency;
  final Currency? toCurrency;
  final FormValidationState validationState;
  final ConversionData conversionData;

  const FormState({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.validationState,
    required this.conversionData,
  });

  /// Returns true if the form is valid and ready for conversion
  bool get canConvert {
    return validationState.isValid &&
        amount.isNotEmpty &&
        fromCurrency != null &&
        toCurrency != null &&
        fromCurrency != toCurrency;
  }

  /// Returns true if the form has any validation errors
  bool get hasErrors {
    return validationState.hasErrors;
  }

  /// Returns true if conversion is in progress
  bool get isConverting {
    return conversionData.state.isLoading;
  }

  /// Returns the converted amount if available
  String? get convertedAmount {
    return conversionData.convertedAmount;
  }

  /// Returns the exchange rate if available
  double? get exchangeRate {
    return conversionData.exchangeRate;
  }

  /// Returns the error message if conversion failed
  String? get errorMessage {
    return conversionData.errorMessage;
  }
}

/// Provider for form actions (methods to update form state)
final formActionsProvider = Provider<FormActions>((ref) {
  return FormActions(ref);
});

/// Class containing all form actions
class FormActions {
  final Ref ref;

  FormActions(this.ref);

  /// Updates the amount and triggers validation and conversion
  void updateAmount(String amount) {
    // Update the amount provider
    ref.read(amountProvider.notifier).state = amount;

    // Validate the amount
    ref.read(formValidationProvider.notifier).validateAmount(amount);

    // Update conversion data
    ref.read(conversionProvider.notifier).updateFromAmount(amount);
  }

  /// Updates the from currency and triggers validation and conversion
  void updateFromCurrency(Currency currency) {
    // Update the from currency provider
    ref.read(fromCurrencyProvider.notifier).state = currency;

    // Validate the from currency
    ref.read(formValidationProvider.notifier).validateFromCurrency(currency);

    // Validate currency pair
    final toCurrency = ref.read(toCurrencyProvider);
    ref
        .read(formValidationProvider.notifier)
        .validateCurrencyPair(currency, toCurrency);

    // Update conversion data
    ref.read(conversionProvider.notifier).updateFromCurrency(currency);
  }

  /// Updates the to currency and triggers validation and conversion
  void updateToCurrency(Currency currency) {
    // Update the to currency provider
    ref.read(toCurrencyProvider.notifier).state = currency;

    // Validate the to currency
    ref.read(formValidationProvider.notifier).validateToCurrency(currency);

    // Validate currency pair
    final fromCurrency = ref.read(fromCurrencyProvider);
    ref
        .read(formValidationProvider.notifier)
        .validateCurrencyPair(fromCurrency, currency);

    // Update conversion data
    ref.read(conversionProvider.notifier).updateToCurrency(currency);
  }

  /// Swaps the from and to currencies
  void swapCurrencies() {
    final fromCurrency = ref.read(fromCurrencyProvider);
    final toCurrency = ref.read(toCurrencyProvider);

    if (fromCurrency != null && toCurrency != null) {
      // Update providers
      ref.read(fromCurrencyProvider.notifier).state = toCurrency;
      ref.read(toCurrencyProvider.notifier).state = fromCurrency;

      // Update conversion data
      ref.read(conversionProvider.notifier).swapCurrencies();
    }
  }

  /// Manually triggers conversion (useful for retry scenarios)
  void convert() {
    ref.read(conversionProvider.notifier).convert();
  }

  /// Clears all form data and resets to initial state
  void reset() {
    // Reset providers
    ref.read(amountProvider.notifier).state = '';
    ref.read(fromCurrencyProvider.notifier).state = null;
    ref.read(toCurrencyProvider.notifier).state = null;

    // Reset validation
    ref.read(formValidationProvider.notifier).reset();

    // Clear conversion data
    ref.read(conversionProvider.notifier).clearDebounce();
  }

  /// Validates the entire form
  void validateForm() {
    final amount = ref.read(amountProvider);
    final fromCurrency = ref.read(fromCurrencyProvider);
    final toCurrency = ref.read(toCurrencyProvider);

    ref
        .read(formValidationProvider.notifier)
        .validateForm(
          amount: amount,
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
        );
  }
}
