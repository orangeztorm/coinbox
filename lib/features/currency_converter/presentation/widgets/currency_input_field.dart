import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/core.dart';

class CurrencyInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? selectedCurrency;
  final VoidCallback? onCurrencyTap;
  final bool canEditAmount;
  final AppLocalizations localizations;

  const CurrencyInputField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.onChanged,
    this.selectedCurrency,
    this.onCurrencyTap,
    this.canEditAmount = true,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveUtils.fontSize(context, 16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.exchangeRateLabelStyle.copyWith(
            fontSize: fontSize * 0.85,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, 12)),
        Row(
          children: [
            // Currency selector with flag or placeholder
            GestureDetector(
              onTap: onCurrencyTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  // Keep consistent padding whether selected or not
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedCurrency != null) ...[
                      // Flag image
                      CurrencyFlag(currencyCode: selectedCurrency!, size: 45),
                      SizedBox(width: ResponsiveUtils.spacing(context, 8)),
                      Text(
                        selectedCurrency!,
                        style: AppTheme.currencyCodeStyle.copyWith(
                          fontSize: fontSize,
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.textTertiary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 20,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.spacing(context, 8)),
                      Text(
                        localizations.selectCurrency,
                        style: AppTheme.currencyCodeStyle.copyWith(
                          fontSize: fontSize,
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                    SizedBox(width: ResponsiveUtils.spacing(context, 2)),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing(context, 16)),
            // Amount input
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: canEditAmount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    decimalDigits: 2,
                    enableNegative: false,
                  ),
                  LengthLimitingTextInputFormatter(
                    15,
                  ), // Limit to prevent overflow
                ],
                style: AppTheme.amountStyle.copyWith(fontSize: fontSize * 1.5),
                cursorHeight: fontSize * 1.5,
                onTapUpOutside: (event) {
                  FocusScope.of(context).unfocus();
                },

                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    fontSize: fontSize * 1.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    right: ResponsiveUtils.spacing(context, 11),
                  ),
                ),

                textAlign: TextAlign.right,
                onChanged: (value) {
                  // Check for amount limit and show snackbar if exceeded
                  if (value.isNotEmpty) {
                    // Use the helper method to get clean numeric value
                    final amount = DecimalCurrencyFormatter.getNumericValue(
                      value,
                    );
                    if (amount != null && amount > 999999999.99) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.amountCannotExceed),
                          backgroundColor: Colors.red[600],
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                      // Set to max value
                      controller.text = '999,999,999.99';
                      return;
                    }
                  }
                  final cleanValue = DecimalCurrencyFormatter.getCleanValue(
                    value,
                  );
                  onChanged?.call(cleanValue);
                },
              ),
            ),
          ],
        ),
        // Error message display
        if (errorText != null && errorText!.isNotEmpty) ...[
          SizedBox(height: ResponsiveUtils.spacing(context, 8)),
          Text(
            _getLocalizedErrorMessage(errorText!),
            style: TextStyle(
              color: Colors.red[600],
              fontSize: fontSize * 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  /// Converts error keys to localized error messages
  String _getLocalizedErrorMessage(String errorKey) {
    switch (errorKey) {
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
        return errorKey; // Return the key as fallback
    }
  }
}
