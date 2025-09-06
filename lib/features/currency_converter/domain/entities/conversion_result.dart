import 'package:equatable/equatable.dart';

class ConversionResult extends Equatable {
  final String baseCode;
  final String targetCode;
  final double baseAmount;
  final double convertedAmount;
  final double conversionRate;
  final DateTime timestamp;

  const ConversionResult({
    required this.baseCode,
    required this.targetCode,
    required this.baseAmount,
    required this.convertedAmount,
    required this.conversionRate,
    required this.timestamp,
  });

  @override
  List<Object> get props => [
    baseCode,
    targetCode,
    baseAmount,
    convertedAmount,
    conversionRate,
    timestamp,
  ];

  @override
  String toString() =>
      'ConversionResult($baseAmount $baseCode = $convertedAmount $targetCode)';
}
