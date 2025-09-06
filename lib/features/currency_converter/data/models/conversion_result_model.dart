import 'package:coinbox/features/currency_converter/domain/domain.dart';

class ConversionResultModel extends ConversionResult {
  const ConversionResultModel({
    required super.baseCode,
    required super.targetCode,
    required super.baseAmount,
    required super.convertedAmount,
    required super.conversionRate,
    required super.timestamp,
  });

  // Factory constructor for creating from API data and calculation
  factory ConversionResultModel.fromCalculation({
    required String baseCode,
    required String targetCode,
    required double baseAmount,
    required double conversionRate,
  }) {
    return ConversionResultModel(
      baseCode: baseCode,
      targetCode: targetCode,
      baseAmount: baseAmount,
      convertedAmount: baseAmount * conversionRate,
      conversionRate: conversionRate,
      timestamp: DateTime.now(),
    );
  }

  // Factory constructor from JSON (for caching)
  factory ConversionResultModel.fromJson(Map<String, dynamic> json) {
    return ConversionResultModel(
      baseCode: json['base_code'] as String,
      targetCode: json['target_code'] as String,
      baseAmount: (json['base_amount'] as num).toDouble(),
      convertedAmount: (json['converted_amount'] as num).toDouble(),
      conversionRate: (json['conversion_rate'] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  // Convert to JSON (for caching)
  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCode,
      'target_code': targetCode,
      'base_amount': baseAmount,
      'converted_amount': convertedAmount,
      'conversion_rate': conversionRate,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Convert entity to model
  factory ConversionResultModel.fromEntity(ConversionResult result) {
    return ConversionResultModel(
      baseCode: result.baseCode,
      targetCode: result.targetCode,
      baseAmount: result.baseAmount,
      convertedAmount: result.convertedAmount,
      conversionRate: result.conversionRate,
      timestamp: result.timestamp,
    );
  }

  // Convert model to entity
  ConversionResult toEntity() {
    return ConversionResult(
      baseCode: baseCode,
      targetCode: targetCode,
      baseAmount: baseAmount,
      convertedAmount: convertedAmount,
      conversionRate: conversionRate,
      timestamp: timestamp,
    );
  }
}
