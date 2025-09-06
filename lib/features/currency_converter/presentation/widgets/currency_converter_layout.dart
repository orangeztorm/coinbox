import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../providers/providers.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/conversion_data.dart';
import 'currency_input_field.dart';
import 'swap_button.dart';
import 'exchange_rate_section.dart';
import 'currency_picker_modal.dart';

class CurrencyConverterLayout extends ConsumerWidget {
  final bool isLandscape;
  final ScreenInfo screenInfo;
  final AppLocalizations localizations;

  const CurrencyConverterLayout({
    super.key,
    required this.isLandscape,
    required this.screenInfo,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountController = ref.watch(amountControllerProvider);
    final fromCurrency = ref.watch(fromCurrencyProvider);
    final toCurrency = ref.watch(toCurrencyProvider);
    final formActions = ref.watch(formActionsProvider);
    final convertedAmount = ref.watch(convertedAmountProvider);
    final conversionData = ref.watch(conversionProvider);

    // Format the converted amount with commas (e.g., 1,000.00)
    final formattedConvertedAmount =
        convertedAmount != null && convertedAmount.isNotEmpty
        ? NumberFormat('#,##0.00').format(double.tryParse(convertedAmount) ?? 0)
        : '';

    if (isLandscape) {
      return _buildLandscapeLayout(
        context,
        ref,
        amountController,
        fromCurrency,
        toCurrency,
        formActions,
        formattedConvertedAmount,
        conversionData,
      );
    } else {
      return _buildPortraitLayout(
        context,
        ref,
        amountController,
        fromCurrency,
        toCurrency,
        formActions,
        formattedConvertedAmount,
        conversionData,
      );
    }
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    WidgetRef ref,
    TextEditingController amountController,
    Currency? fromCurrency,
    Currency? toCurrency,
    FormActions formActions,
    String formattedConvertedAmount,
    ConversionData conversionData,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context, 20)),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(context, 20),
              ),
            ),
            child: Column(
              children: [
                // Amount input field with integrated currency selector
                CurrencyInputField(
                  controller: amountController,
                  label: localizations.amount,
                  selectedCurrency: fromCurrency?.code,
                  onCurrencyTap: () => _showCurrencyPicker(context, ref, true),
                  onChanged: (value) => formActions.updateAmount(value),
                  errorText: conversionData.errorMessage,
                  localizations: localizations,
                ),

                SizedBox(height: ResponsiveUtils.spacing(context, 24)),

                // Swap button
                SwapButton(onPressed: () => formActions.swapCurrencies()),

                SizedBox(height: ResponsiveUtils.spacing(context, 24)),

                // Conversion result display with tap to change currency
                CurrencyInputField(
                  controller: TextEditingController(
                    text: formattedConvertedAmount,
                  ),
                  label: localizations.amount,
                  selectedCurrency: toCurrency?.code,
                  onCurrencyTap: () => _showCurrencyPicker(context, ref, false),
                  onChanged: (value) => formActions.updateAmount(value),
                  canEditAmount: false,
                  localizations: localizations,
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, 40)),
          ExchangeRateSection(
            fromCurrency: fromCurrency?.code ?? '',
            toCurrency: toCurrency?.code ?? '',
            localizations: localizations,
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    WidgetRef ref,
    TextEditingController amountController,
    Currency? fromCurrency,
    Currency? toCurrency,
    FormActions formActions,
    String formattedConvertedAmount,
    ConversionData conversionData,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CurrencyInputField(
                  controller: amountController,
                  label: localizations.amount,
                  selectedCurrency: fromCurrency?.code,
                  onCurrencyTap: () => _showCurrencyPicker(context, ref, true),
                  onChanged: (value) => formActions.updateAmount(value),
                  errorText: conversionData.errorMessage,
                  localizations: localizations,
                ),

                const SizedBox(height: 16.0),

                SwapButton(onPressed: () => formActions.swapCurrencies()),

                const SizedBox(height: 16.0),

                CurrencyInputField(
                  controller: TextEditingController(
                    text: formattedConvertedAmount,
                  ),
                  label: localizations.amount,
                  selectedCurrency: toCurrency?.code,
                  onCurrencyTap: () => _showCurrencyPicker(context, ref, false),
                  onChanged: (value) => formActions.updateAmount(value),
                  canEditAmount: false,
                  localizations: localizations,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16.0),

          // Right side - Exchange rate section
          SizedBox(
            width: 200,
            child: ExchangeRateSection(
              fromCurrency: fromCurrency?.code ?? '',
              toCurrency: toCurrency?.code ?? '',
              localizations: localizations,
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    WidgetRef ref,
    bool isFromCurrency,
  ) {
    final formActions = ref.read(formActionsProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencyPickerModal(
        isFromCurrency: isFromCurrency,
        onCurrencySelected: (currency) {
          if (isFromCurrency) {
            formActions.updateFromCurrency(currency);
          } else {
            formActions.updateToCurrency(currency);
          }
          Navigator.pop(context);
        },
        localizations: localizations,
      ),
    );
  }
}
