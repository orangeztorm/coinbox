import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:coinbox/features/currency_converter/domain/entities/currency.dart';

/// Provider for form validation state
final formValidationProvider =
    StateNotifierProvider<FormValidationNotifier, FormValidationState>((ref) {
      return FormValidationNotifier();
    });

/// Represents the validation state of the form
class FormValidationState extends Equatable {
  final String? amountError;
  final String? fromCurrencyError;
  final String? toCurrencyError;
  final bool isValid;

  const FormValidationState({
    this.amountError,
    this.fromCurrencyError,
    this.toCurrencyError,
    required this.isValid,
  });

  /// Creates initial validation state
  factory FormValidationState.initial() {
    return const FormValidationState(isValid: false);
  }

  /// Creates a copy with updated values
  FormValidationState copyWith({
    String? amountError,
    String? fromCurrencyError,
    String? toCurrencyError,
    bool? isValid,
  }) {
    return FormValidationState(
      amountError: amountError ?? this.amountError,
      fromCurrencyError: fromCurrencyError ?? this.fromCurrencyError,
      toCurrencyError: toCurrencyError ?? this.toCurrencyError,
      isValid: isValid ?? this.isValid,
    );
  }

  /// Returns true if there are any validation errors
  bool get hasErrors {
    return amountError != null ||
        fromCurrencyError != null ||
        toCurrencyError != null;
  }

  @override
  List<Object?> get props => [
    amountError,
    fromCurrencyError,
    toCurrencyError,
    isValid,
  ];
}

/// Notifier for handling form validation logic
class FormValidationNotifier extends StateNotifier<FormValidationState> {
  FormValidationNotifier() : super(FormValidationState.initial());

  /// Validates the amount input
  void validateAmount(String? amount) {
    if (amount == null || amount.isEmpty) {
      state = state.copyWith(amountError: 'pleaseEnterAmount', isValid: false);
      return;
    }

    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      state = state.copyWith(
        amountError: 'pleaseEnterValidNumber',
        isValid: false,
      );
      return;
    }

    if (parsedAmount <= 0) {
      state = state.copyWith(
        amountError: 'amountMustBeGreaterThanZero',
        isValid: false,
      );
      return;
    }

    if (parsedAmount > 999999999) {
      state = state.copyWith(amountError: 'amountIsTooLarge', isValid: false);
      return;
    }

    // Clear amount error
    state = state.copyWith(amountError: null);
    _updateOverallValidity();
  }

  /// Validates the from currency selection
  void validateFromCurrency(Currency? currency) {
    if (currency == null) {
      state = state.copyWith(
        fromCurrencyError: 'pleaseSelectCurrency',
        isValid: false,
      );
      return;
    }

    // Clear from currency error
    state = state.copyWith(fromCurrencyError: null);
    _updateOverallValidity();
  }

  /// Validates the to currency selection
  void validateToCurrency(Currency? currency) {
    if (currency == null) {
      state = state.copyWith(
        toCurrencyError: 'pleaseSelectCurrency',
        isValid: false,
      );
      return;
    }

    // Clear to currency error
    state = state.copyWith(toCurrencyError: null);
    _updateOverallValidity();
  }

  /// Validates that from and to currencies are different
  void validateCurrencyPair(Currency? fromCurrency, Currency? toCurrency) {
    if (fromCurrency != null &&
        toCurrency != null &&
        fromCurrency == toCurrency) {
      state = state.copyWith(
        toCurrencyError: 'pleaseSelectDifferentCurrency',
        isValid: false,
      );
      return;
    }

    // Clear to currency error if currencies are different
    if (state.toCurrencyError == 'pleaseSelectDifferentCurrency') {
      state = state.copyWith(toCurrencyError: null);
      _updateOverallValidity();
    }
  }

  /// Validates the entire form
  void validateForm({
    required String? amount,
    required Currency? fromCurrency,
    required Currency? toCurrency,
  }) {
    validateAmount(amount);
    validateFromCurrency(fromCurrency);
    validateToCurrency(toCurrency);
    validateCurrencyPair(fromCurrency, toCurrency);
  }

  /// Updates the overall validity based on current state
  void _updateOverallValidity() {
    final isValid = !state.hasErrors;
    state = state.copyWith(isValid: isValid);
  }

  /// Clears all validation errors
  void clearErrors() {
    state = FormValidationState.initial();
  }

  /// Resets validation state
  void reset() {
    state = FormValidationState.initial();
  }
}

/// Provider for getting the amount validation error
final amountErrorProvider = Provider<String?>((ref) {
  return ref.watch(formValidationProvider).amountError;
});

/// Provider for getting the from currency validation error
final fromCurrencyErrorProvider = Provider<String?>((ref) {
  return ref.watch(formValidationProvider).fromCurrencyError;
});

/// Provider for getting the to currency validation error
final toCurrencyErrorProvider = Provider<String?>((ref) {
  return ref.watch(formValidationProvider).toCurrencyError;
});

/// Provider for checking if the form is valid
final isFormValidProvider = Provider<bool>((ref) {
  return ref.watch(formValidationProvider).isValid;
});
