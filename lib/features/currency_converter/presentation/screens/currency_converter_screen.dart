import 'package:flutter/material.dart';
import 'package:coinbox/core/core.dart';
import 'package:coinbox/features/currency_converter/presentation/widgets/widgets.dart';

class CurrencyConverterScreen extends StatelessWidget {
  const CurrencyConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Beautiful gradient background
          Positioned(
            top: -330,
            left: -200,
            child: Container(
              width: 751,
              height: 751,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: ResponsiveLayoutBuilder(
                builder: (context, screenInfo) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: screenInfo.isLandscape ? 10.0 : 30.0),
                        _buildHeader(context, localizations),
                        SizedBox(height: screenInfo.isLandscape ? 16.0 : 40.0),
                        OrientationAwareContainer(
                          child: CurrencyConverterLayout(
                            isLandscape: screenInfo.isLandscape,
                            screenInfo: screenInfo,
                            localizations: localizations,
                          ),
                        ),
                        SizedBox(height: screenInfo.isLandscape ? 16.0 : 40.0),
                        NetworkStatusWidget(localizations: localizations),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          localizations.appTitle,
          style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
            color: AppColors.primaryHeader,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, 10)),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
          child: Text(
            localizations.appSubheader,
            style: AppTheme.subHeaderStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
