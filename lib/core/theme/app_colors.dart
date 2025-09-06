import 'package:flutter/material.dart';

/// Application color palette
/// Defines all colors used throughout the app for consistency
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Brand Colors
  static const Color primaryHeader = Color(0xFF1F2261);
  static const Color primarySubHeader = Color(0xFF808080);
  static const Color white = Color(0xFFFFFFFF);

  // Background Colors
  static const Color background = Color(0xFFF6F6F6);
  static const Color imageBackground = Color(0xFFEAEAFE);
  static const Color formBackground = Color(0xFFEFEFEF);

  // Gradient Colors
  static const Color gradientStart = Color(0xFFEAEAFE);
  static const Color gradientEnd = Color(
    0xFFDDF6F3,
  ); // Note: DDF6F300 is actually a transparent color

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF808080);
  static const Color textTertiary = Color(0xFF989898);
  static const Color textQuaternary = Color(0xFFA1A1A1);
  static const Color textQuinary = Color(0xFF26278D);

  static const Color divider = Color(0xFFE7E7EE);

  // Form Colors
  static const Color formTitle = Color(0xFF989898);
  static const Color exchangeRateLabel = Color(0xFFA1A1A1);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Surface Colors
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocus = primarySubHeader;

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const RadialGradient primaryRadialGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [gradientStart, gradientEnd],
  );
}

/// Extension to add custom colors to ThemeData
extension AppThemeExtension on ThemeData {
  /// Get app-specific colors
  AppColorsExtension get appColors => AppColorsExtension();
}

/// Custom colors extension for easy access
class AppColorsExtension {
  Color get primaryHeader => AppColors.primaryHeader;
  Color get primarySubHeader => AppColors.primarySubHeader;
  Color get background => AppColors.background;
  Color get formBackground => AppColors.formBackground;
  Color get gradientStart => AppColors.gradientStart;
  Color get gradientEnd => AppColors.gradientEnd;
  Color get textPrimary => AppColors.textPrimary;
  Color get textSecondary => AppColors.textSecondary;
  Color get textTertiary => AppColors.textTertiary;
  Color get textQuaternary => AppColors.textQuaternary;
  Color get formTitle => AppColors.formTitle;
  Color get exchangeRateLabel => AppColors.exchangeRateLabel;
  Color get success => AppColors.success;
  Color get error => AppColors.error;
  Color get warning => AppColors.warning;
  Color get info => AppColors.info;
  Color get surface => AppColors.surface;
  Color get surfaceVariant => AppColors.surfaceVariant;
  Color get border => AppColors.border;
  Color get borderFocus => AppColors.borderFocus;
}
