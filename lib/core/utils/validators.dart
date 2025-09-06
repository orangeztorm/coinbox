import '../constants/app_constants.dart';

class Validators {
  /// Validate currency amount
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }

    final cleanValue = value.replaceAll(',', '.');
    final amount = double.tryParse(cleanValue);

    if (amount == null) {
      return 'Please enter a valid number';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (amount < AppConstants.minAmount) {
      return 'Amount must be at least ${AppConstants.minAmount}';
    }

    if (amount > AppConstants.maxAmount) {
      return 'Amount cannot exceed ${AppConstants.maxAmount}';
    }

    return null;
  }

  /// Validate currency code
  static String? validateCurrencyCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return 'Please select a currency';
    }

    if (code.length != 3) {
      return 'Currency code must be 3 characters';
    }

    return null;
  }

  /// Check if amount is valid for conversion
  static bool isValidAmount(double? amount) {
    if (amount == null) return false;
    return amount > 0 &&
        amount >= AppConstants.minAmount &&
        amount <= AppConstants.maxAmount;
  }

  /// Clean and parse amount string
  static double? parseAmount(String value) {
    if (value.trim().isEmpty) return null;

    final cleanValue = value
        .replaceAll(RegExp(r'[^\d.,\-+]'), '')
        .replaceAll(',', '.');

    final amount = double.tryParse(cleanValue);
    return isValidAmount(amount) ? amount : null;
  }

  /// Format amount for input field
  static String formatAmountForInput(double amount) {
    if (amount == amount.toInt()) {
      return amount.toInt().toString();
    }
    return amount.toString();
  }
}
