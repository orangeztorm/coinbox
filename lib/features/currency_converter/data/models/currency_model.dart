import '../../domain/entities/currency.dart';
import '../../../../core/constants/currencies.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({
    required super.code,
    required super.name,
    super.symbol,
    super.flag,
  });

  // Factory constructor for creating from supported currencies JSON
  factory CurrencyModel.fromJson(List<dynamic> json) {
    final code = json[0] as String;
    final name = json[1] as String;
    final currencyInfo = SupportedCurrencies.getCurrencyInfo(code);

    return CurrencyModel(
      code: code,
      name: name,
      symbol: currencyInfo?.symbol ?? '',
      flag: currencyInfo?.flag ?? '',
    );
  }

  // Factory constructor for creating from a Map
  factory CurrencyModel.fromMap(Map<String, dynamic> map) {
    final code = map['code'] as String;
    final currencyInfo = SupportedCurrencies.getCurrencyInfo(code);

    return CurrencyModel(
      code: code,
      name: map['name'] as String,
      symbol: map['symbol'] as String? ?? currencyInfo?.symbol ?? '',
      flag: map['flag'] as String? ?? currencyInfo?.flag ?? '',
    );
  }

  // Convert to JSON (for caching or API requests)
  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'symbol': symbol, 'flag': flag};
  }

  // Convert entity to model
  factory CurrencyModel.fromEntity(Currency currency) {
    return CurrencyModel(
      code: currency.code,
      name: currency.name,
      symbol: currency.symbol,
      flag: currency.flag,
    );
  }

  // Convert model to entity
  Currency toEntity() {
    return Currency(code: code, name: name, symbol: symbol, flag: flag);
  }
}
