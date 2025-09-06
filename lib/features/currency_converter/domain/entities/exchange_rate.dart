import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String baseCode;
  final String targetCode;
  final double rate;
  final DateTime lastUpdate;
  final DateTime nextUpdate;

  const ExchangeRate({
    required this.baseCode,
    required this.targetCode,
    required this.rate,
    required this.lastUpdate,
    required this.nextUpdate,
  });

  @override
  List<Object> get props => [
    baseCode,
    targetCode,
    rate,
    lastUpdate,
    nextUpdate,
  ];

  @override
  String toString() =>
      'ExchangeRate(base: $baseCode, target: $targetCode, rate: $rate)';
}
