import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// Responsive text styles for the application
class AppTextStyles {
  /// Get responsive headline style
  static TextStyle getHeadlineStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.fontSize(context, 24),
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  /// Get responsive title style
  static TextStyle getTitleStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.fontSize(context, 20),
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }

  /// Get responsive subtitle style
  static TextStyle getSubtitleStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.fontSize(context, 16),
      fontWeight: FontWeight.w500,
      color: Colors.black54,
    );
  }

  /// Get responsive body style
  static TextStyle getBodyStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.fontSize(context, 14),
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    );
  }

  /// Get responsive caption style
  static TextStyle getCaptionStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.fontSize(context, 12),
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    );
  }

  /// Get responsive button text style
  static TextStyle getButtonStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.fontSize(context, 16),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  /// Get responsive input label style
  static TextStyle getInputLabelStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.fontSize(context, 14),
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );
  }

  /// Get responsive error text style
  static TextStyle getErrorStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.fontSize(context, 12),
      fontWeight: FontWeight.normal,
      color: Colors.red,
    );
  }
}
