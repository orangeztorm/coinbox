import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String code;
  final String name;
  final String symbol;
  final String flag;

  const Currency({
    required this.code,
    required this.name,
    this.symbol = '',
    this.flag = '',
  });

  factory Currency.empty() => const Currency(
    code: 'USD',
    name: 'Test Currency',
    symbol: 'USD',
    flag: 'flag_usd_40',
  );

  @override
  List<Object> get props => [code, name, symbol, flag];

  @override
  String toString() =>
      'Currency(code: $code, name: $name, symbol: $symbol, flag: $flag)';
}
