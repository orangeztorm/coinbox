import 'package:coinbox/features/currency_converter/domain/entities/currency.dart';
import 'package:coinbox/features/currency_converter/domain/entities/conversion_state.dart';

/// Represents the complete state of currency conversion
class ConversionData {
  final ConversionState state;
  final String? fromAmount;
  final Currency? fromCurrency;
  final Currency? toCurrency;
  final String? convertedAmount;
  final double? exchangeRate;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const ConversionData({
    required this.state,
    this.fromAmount,
    this.fromCurrency,
    this.toCurrency,
    this.convertedAmount,
    this.exchangeRate,
    this.errorMessage,
    this.lastUpdated,
  });

  /// Creates initial conversion data
  factory ConversionData.initial() {
    return const ConversionData(state: ConversionState.initial);
  }

  /// Creates loading state
  factory ConversionData.loading({
    required String fromAmount,
    required Currency fromCurrency,
    required Currency toCurrency,
  }) {
    return ConversionData(
      state: ConversionState.loading,
      fromAmount: fromAmount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      lastUpdated: DateTime.now(),
    );
  }

  /// Creates success state
  factory ConversionData.success({
    required String fromAmount,
    required Currency fromCurrency,
    required Currency toCurrency,
    required String convertedAmount,
    required double exchangeRate,
  }) {
    return ConversionData(
      state: ConversionState.success,
      fromAmount: fromAmount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      convertedAmount: convertedAmount,
      exchangeRate: exchangeRate,
      lastUpdated: DateTime.now(),
    );
  }

  /// Creates failure state
  factory ConversionData.failure({
    required String fromAmount,
    required Currency fromCurrency,
    required Currency toCurrency,
    required String errorMessage,
  }) {
    return ConversionData(
      state: ConversionState.failure,
      fromAmount: fromAmount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      errorMessage: errorMessage,
      lastUpdated: DateTime.now(),
    );
  }

  /// Creates a copy with updated values
  ConversionData copyWith({
    ConversionState? state,
    String? fromAmount,
    Currency? fromCurrency,
    Currency? toCurrency,
    String? convertedAmount,
    double? exchangeRate,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return ConversionData(
      state: state ?? this.state,
      fromAmount: fromAmount ?? this.fromAmount,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Returns true if conversion can be performed
  bool get canConvert {
    return fromAmount != null &&
        fromAmount!.isNotEmpty &&
        fromCurrency != null &&
        toCurrency != null &&
        fromCurrency != toCurrency;
  }

  /// Returns true if the conversion data is valid for display
  bool get hasValidData {
    return fromAmount != null && fromCurrency != null && toCurrency != null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConversionData &&
        other.state == state &&
        other.fromAmount == fromAmount &&
        other.fromCurrency == fromCurrency &&
        other.toCurrency == toCurrency &&
        other.convertedAmount == convertedAmount &&
        other.exchangeRate == exchangeRate &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      state,
      fromAmount,
      fromCurrency,
      toCurrency,
      convertedAmount,
      exchangeRate,
      errorMessage,
    );
  }

  @override
  String toString() {
    return 'ConversionData('
        'state: $state, '
        'fromAmount: $fromAmount, '
        'fromCurrency: ${fromCurrency?.code}, '
        'toCurrency: ${toCurrency?.code}, '
        'convertedAmount: $convertedAmount, '
        'exchangeRate: $exchangeRate, '
        'errorMessage: $errorMessage'
        ')';
  }
}
