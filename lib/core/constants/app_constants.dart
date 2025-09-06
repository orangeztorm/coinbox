class AppConstants {
  // App Information
  static const String appName = 'Coinbox';
  static const String appVersion = '1.0.0';

  // Default currencies
  static const String defaultFromCurrency = 'USD';
  static const String defaultToCurrency = 'EUR';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Validation
  static const double maxAmount = 999999999.99;
  static const double minAmount = 0.01;

  // Cache duration (5 minutes)
  static const Duration cacheDuration = Duration(minutes: 5);
}
