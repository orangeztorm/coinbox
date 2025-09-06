import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

/// Utility class for responsive design calculations using responsive_framework
class ResponsiveUtils {
  /// Calculate responsive font size using responsive_framework scaling
  static double fontSize(BuildContext context, double baseSize) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double scaleFactor = 1.0;

    // Use responsive_framework's scaling capabilities
    if (rf.ResponsiveBreakpoints.of(context).isDesktop) {
      scaleFactor = 1.2;
    } else if (rf.ResponsiveBreakpoints.of(context).isTablet) {
      scaleFactor = 1.1;
    } else {
      scaleFactor = 1.0;
    }

    // Scale down for landscape mode to save vertical space
    if (isLandscape) {
      scaleFactor *= 0.85;
    }

    return baseSize * scaleFactor;
  }

  /// Get responsive value based on device type
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (rf.ResponsiveBreakpoints.of(context).isDesktop) {
      return desktop ?? tablet ?? mobile;
    } else if (rf.ResponsiveBreakpoints.of(context).isTablet) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Calculate responsive spacing using device type
  static double spacing(BuildContext context, double baseSpacing) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double spacing = responsiveValue(
      context,
      mobile: baseSpacing,
      tablet: baseSpacing * 1.2,
      desktop: baseSpacing * 1.4,
    );

    // Scale down spacing for landscape mode to save vertical space
    if (isLandscape) {
      spacing *= 0.8;
    }

    return spacing;
  }

  /// Get responsive padding based on device type and orientation
  static EdgeInsets responsivePadding(
    BuildContext context, {
    double horizontal = 16.0,
    double vertical = 16.0,
  }) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final horizontalPadding = responsiveValue(
      context,
      mobile: horizontal,
      tablet: horizontal * 1.3,
      desktop: horizontal * 1.6,
    );

    final verticalPadding = responsiveValue(
      context,
      mobile: vertical,
      tablet: vertical * 1.1,
      desktop: vertical * 1.2,
    );

    return EdgeInsets.symmetric(
      horizontal: isLandscape ? horizontalPadding * 1.2 : horizontalPadding,
      vertical: isLandscape ? verticalPadding * 0.8 : verticalPadding,
    );
  }

  /// Get responsive border radius
  static double borderRadius(BuildContext context, double baseRadius) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double radius = responsiveValue(
      context,
      mobile: baseRadius,
      tablet: baseRadius * 1.2,
      desktop: baseRadius * 1.4,
    );

    // Scale down border radius for landscape mode
    if (isLandscape) {
      radius *= 0.9;
    }

    return radius;
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, double baseSize) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double iconSize = responsiveValue(
      context,
      mobile: baseSize,
      tablet: baseSize * 1.15,
      desktop: baseSize * 1.3,
    );

    // Scale down icon size for landscape mode
    if (isLandscape) {
      iconSize *= 0.9;
    }

    return iconSize;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get screen type information using responsive_framework
  static ScreenInfo getScreenInfo(BuildContext context) {
    final responsiveBreakpoints = rf.ResponsiveBreakpoints.of(context);
    final size = MediaQuery.of(context).size;

    return ScreenInfo(
      width: size.width,
      height: size.height,
      isLandscape: MediaQuery.of(context).orientation == Orientation.landscape,
      isMobile: responsiveBreakpoints.isMobile,
      isTablet: responsiveBreakpoints.isTablet,
      isDesktop: responsiveBreakpoints.isDesktop,
      deviceType: responsiveBreakpoints.isMobile
          ? 'mobile'
          : responsiveBreakpoints.isTablet
          ? 'tablet'
          : 'desktop',
    );
  }

  /// Get responsive column count for grids
  static int getColumnCount(BuildContext context) {
    return responsiveValue(context, mobile: 1, tablet: 2, desktop: 3);
  }

  /// Get responsive aspect ratio
  static double getAspectRatio(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 16 / 9,
      tablet: 4 / 3,
      desktop: 21 / 9,
    );
  }
}

/// Screen information data class
class ScreenInfo {
  final double width;
  final double height;
  final bool isLandscape;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final String deviceType;

  const ScreenInfo({
    required this.width,
    required this.height,
    required this.isLandscape,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.deviceType,
  });

  bool get isPortrait => !isLandscape;
}
