import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.dart';
import '../providers/providers.dart';
import 'exchange_rate_display.dart';

class ExchangeRateSection extends ConsumerWidget {
  final String fromCurrency;
  final String toCurrency;
  final AppLocalizations localizations;

  const ExchangeRateSection({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeRate = ref.watch(exchangeRateProvider);
    final conversionData = ref.watch(conversionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.indicativeExchangeRate,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
        // ExchangeRateDisplay(
        //   fromCurrency: fromCurrency,
        //   toCurrency: toCurrency,
        //   exchangeRate: exchangeRate,
        //   errorMessage: conversionData.errorMessage,
        //   localizations: localizations,
        // ),
        const SizedBox(height: 8),
        ExchangeRateValue(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          exchangeRate: exchangeRate,
          errorMessage: conversionData.errorMessage,
          localizations: localizations,
        ),
      ],
    );
  }
}
