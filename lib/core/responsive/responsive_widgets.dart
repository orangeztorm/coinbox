import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// Responsive text widget that adapts to screen size and orientation
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.baseStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle responsiveStyle = baseStyle ?? const TextStyle(fontSize: 16);

    // Adjust font size based on screen info
    double fontSize = responsiveStyle.fontSize ?? 16;
    fontSize = ResponsiveUtils.fontSize(context, fontSize);

    return Text(
      text,
      style: responsiveStyle.copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Widget builder that provides different layouts for different device types
class DeviceTypeBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const DeviceTypeBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = ResponsiveUtils.getScreenInfo(context);

    if (screenInfo.isDesktop) {
      return desktop ?? tablet ?? mobile;
    } else if (screenInfo.isTablet) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

/// Container that adapts its layout based on orientation
class OrientationAwareContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final Decoration? decoration;

  const OrientationAwareContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = ResponsiveUtils.getScreenInfo(context);

    return Container(
      padding: padding ?? ResponsiveUtils.responsivePadding(context),
      margin: margin,
      constraints:
          constraints ??
          BoxConstraints(
            maxHeight: screenInfo.isLandscape
                ? screenInfo.height * 0.9
                : double.infinity,
          ),
      decoration: decoration,
      child: child,
    );
  }
}

/// Responsive card widget
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? color;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 4,
      color: color,
      margin:
          margin ??
          ResponsiveUtils.responsivePadding(
            context,
            horizontal: 8,
            vertical: 8,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, 12),
        ),
      ),
      child: Padding(
        padding: padding ?? ResponsiveUtils.responsivePadding(context),
        child: child,
      ),
    );
  }
}

/// Responsive button widget
class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final IconData? icon;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = ResponsiveUtils.getScreenInfo(context);

    return SizedBox(
      width: double.infinity,
      height: screenInfo.isLandscape ? 45 : 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, 8),
            ),
          ),
          textStyle: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, 16),
            fontWeight: FontWeight.w600,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: ResponsiveUtils.iconSize(context, 20),
                width: ResponsiveUtils.iconSize(context, 20),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: ResponsiveUtils.iconSize(context, 20)),
                    SizedBox(width: ResponsiveUtils.spacing(context, 8)),
                  ],
                  ResponsiveText(
                    text,
                    baseStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Responsive layout builder that provides screen information
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenInfo screenInfo) builder;

  const ResponsiveLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenInfo = ResponsiveUtils.getScreenInfo(context);
        return builder(context, screenInfo);
      },
    );
  }
}
