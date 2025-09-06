import '../../domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.baseCode,
    required super.targetCode,
    required super.rate,
    required super.lastUpdate,
    required super.nextUpdate,
  });

  // Factory constructor for creating from conversion API JSON response
  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      baseCode: json['base_code'] as String,
      targetCode: json['target_code'] as String,
      rate: (json['conversion_rate'] as num).toDouble(),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(
        (json['time_last_update_unix'] as int) * 1000,
      ),
      nextUpdate: DateTime.fromMillisecondsSinceEpoch(
        (json['time_next_update_unix'] as int) * 1000,
      ),
    );
  }

  // Convert to JSON (for caching or API requests)
  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCode,
      'target_code': targetCode,
      'conversion_rate': rate,
      'time_last_update_unix': lastUpdate.millisecondsSinceEpoch ~/ 1000,
      'time_next_update_unix': nextUpdate.millisecondsSinceEpoch ~/ 1000,
    };
  }

  // Convert entity to model
  factory ExchangeRateModel.fromEntity(ExchangeRate exchangeRate) {
    return ExchangeRateModel(
      baseCode: exchangeRate.baseCode,
      targetCode: exchangeRate.targetCode,
      rate: exchangeRate.rate,
      lastUpdate: exchangeRate.lastUpdate,
      nextUpdate: exchangeRate.nextUpdate,
    );
  }

  // Convert model to entity
  ExchangeRate toEntity() {
    return ExchangeRate(
      baseCode: baseCode,
      targetCode: targetCode,
      rate: rate,
      lastUpdate: lastUpdate,
      nextUpdate: nextUpdate,
    );
  }
}
