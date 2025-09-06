import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class ExchangeRateDisplay extends StatelessWidget {
  final String? fromCurrency;
  final String? toCurrency;
  final double? exchangeRate;
  final String? errorMessage;
  final AppLocalizations localizations;

  const ExchangeRateDisplay({
    super.key,
    this.fromCurrency,
    this.toCurrency,
    this.exchangeRate,
    this.errorMessage,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveUtils.fontSize(context, 14);

    // If there's an error message, show it
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context, 16),
          vertical: ResponsiveUtils.spacing(context, 12),
        ),
        child: Column(
          children: [
            Text(
              localizations.indicativeExchangeRate,
              style: AppTheme.exchangeRateLabelStyle.copyWith(
                fontSize: fontSize * 0.9,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[600], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getLocalizedErrorMessage(errorMessage!),
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: fontSize * 0.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // If currencies or exchange rate are missing, don't show anything
    if (fromCurrency == null || toCurrency == null || exchangeRate == null) {
      return const SizedBox.shrink();
    }

    // Normal display when everything is working
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, 16),
        vertical: ResponsiveUtils.spacing(context, 12),
      ),
      child: Text(
        localizations.indicativeExchangeRate,
        style: AppTheme.exchangeRateLabelStyle.copyWith(
          fontSize: fontSize * 0.9,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Converts error keys to localized error messages
  String _getLocalizedErrorMessage(String errorKey) {
    switch (errorKey) {
      case 'networkError':
        return localizations.networkError;
      case 'invalidAmount':
        return localizations.invalidAmount;
      case 'pleaseEnterAmount':
        return localizations.pleaseEnterAmount;
      case 'pleaseEnterValidNumber':
        return localizations.pleaseEnterValidNumber;
      case 'amountMustBeGreaterThanZero':
        return localizations.amountMustBeGreaterThanZero;
      case 'amountIsTooLarge':
        return localizations.amountIsTooLarge;
      case 'pleaseSelectCurrency':
        return localizations.pleaseSelectCurrency;
      case 'pleaseSelectDifferentCurrency':
        return localizations.pleaseSelectDifferentCurrency;
      case 'invalidCurrencyCode':
        return localizations.invalidCurrencyCode;
      default:
        // If it's not a key, return the message as is
        return errorKey;
    }
  }
}

class ExchangeRateValue extends StatelessWidget {
  final String? fromCurrency;
  final String? toCurrency;
  final double? exchangeRate;
  final String? errorMessage;
  final AppLocalizations localizations;

  const ExchangeRateValue({
    super.key,
    this.fromCurrency,
    this.toCurrency,
    this.exchangeRate,
    this.errorMessage,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveUtils.fontSize(context, 18);

    // If there's an error message, show error state
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.spacing(context, 8),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red[600], size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _getLocalizedErrorMessage(errorMessage!),
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: fontSize * 0.9,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If currencies or exchange rate are missing, don't show anything
    if (fromCurrency == null || toCurrency == null || exchangeRate == null) {
      return const SizedBox.shrink();
    }

    // Normal display when everything is working
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, 8),
      ),
      child: Text(
        '1 $fromCurrency = ${exchangeRate!.toStringAsFixed(4)} $toCurrency',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Converts error keys to localized error messages
  String _getLocalizedErrorMessage(String errorKey) {
    switch (errorKey) {
      case 'networkError':
        return localizations.networkError;
      case 'invalidAmount':
        return localizations.invalidAmount;
      case 'pleaseEnterAmount':
        return localizations.pleaseEnterAmount;
      case 'pleaseEnterValidNumber':
        return localizations.pleaseEnterValidNumber;
      case 'amountMustBeGreaterThanZero':
        return localizations.amountMustBeGreaterThanZero;
      case 'amountIsTooLarge':
        return localizations.amountIsTooLarge;
      case 'pleaseSelectCurrency':
        return localizations.pleaseSelectCurrency;
      case 'pleaseSelectDifferentCurrency':
        return localizations.pleaseSelectDifferentCurrency;
      case 'invalidCurrencyCode':
        return localizations.invalidCurrencyCode;
      default:
        // If it's not a key, return the message as is
        return errorKey;
    }
  }
}
