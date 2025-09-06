import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'responsive_utils.dart';

/// Enhanced responsive text using responsive_framework
class ResponsiveFrameworkText extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveFrameworkText(
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

    // Use responsive_framework's ResponsiveValue for font size
    final baseFontSize = responsiveStyle.fontSize ?? 16;
    final fontSize = rf.ResponsiveValue<double>(
      context,
      defaultValue: baseFontSize, // Default value to prevent null
      conditionalValues: [
        rf.Condition.equals(name: rf.MOBILE, value: baseFontSize),
        rf.Condition.equals(name: rf.TABLET, value: baseFontSize * 1.1),
        rf.Condition.equals(name: rf.DESKTOP, value: baseFontSize * 1.2),
      ],
    ).value;

    return Text(
      text,
      style: responsiveStyle.copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive container using responsive_framework
class ResponsiveFrameworkContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final Decoration? decoration;

  const ResponsiveFrameworkContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = rf.ResponsiveValue<EdgeInsets>(
      context,
      defaultValue: const EdgeInsets.all(16), // Default value
      conditionalValues: [
        const rf.Condition.equals(name: rf.MOBILE, value: EdgeInsets.all(16)),
        const rf.Condition.equals(name: rf.TABLET, value: EdgeInsets.all(20)),
        const rf.Condition.equals(name: rf.DESKTOP, value: EdgeInsets.all(24)),
      ],
    ).value;

    return Container(
      padding: padding ?? responsivePadding,
      margin: margin,
      constraints: constraints,
      decoration: decoration,
      child: child,
    );
  }
}

/// Responsive card using responsive_framework
class ResponsiveFrameworkCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? color;

  const ResponsiveFrameworkCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveElevation = rf.ResponsiveValue<double>(
      context,
      defaultValue: 2, // Default value
      conditionalValues: [
        const rf.Condition.equals(name: rf.MOBILE, value: 2),
        const rf.Condition.equals(name: rf.TABLET, value: 4),
        const rf.Condition.equals(name: rf.DESKTOP, value: 6),
      ],
    ).value;

    final responsiveBorderRadius = rf.ResponsiveValue<double>(
      context,
      defaultValue: 8, // Default value
      conditionalValues: [
        const rf.Condition.equals(name: rf.MOBILE, value: 8),
        const rf.Condition.equals(name: rf.TABLET, value: 12),
        const rf.Condition.equals(name: rf.DESKTOP, value: 16),
      ],
    ).value;

    return Card(
      elevation: elevation ?? responsiveElevation,
      color: color,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
      ),
      child: ResponsiveFrameworkContainer(padding: padding, child: child),
    );
  }
}

/// Responsive button using responsive_framework
class ResponsiveFrameworkButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final IconData? icon;

  const ResponsiveFrameworkButton({
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
    final buttonHeight = rf.ResponsiveValue<double>(
      context,
      defaultValue: 48, // Default value
      conditionalValues: [
        const rf.Condition.equals(name: rf.MOBILE, value: 48),
        const rf.Condition.equals(name: rf.TABLET, value: 52),
        const rf.Condition.equals(name: rf.DESKTOP, value: 56),
      ],
    ).value;

    final fontSize = rf.ResponsiveValue<double>(
      context,
      defaultValue: 16, // Default value
      conditionalValues: [
        const rf.Condition.equals(name: rf.MOBILE, value: 16),
        const rf.Condition.equals(name: rf.TABLET, value: 17),
        const rf.Condition.equals(name: rf.DESKTOP, value: 18),
      ],
    ).value;

    final borderRadius = rf.ResponsiveValue<double>(
      context,
      defaultValue: 8, // Default value
      conditionalValues: [
        const rf.Condition.equals(name: rf.MOBILE, value: 8),
        const rf.Condition.equals(name: rf.TABLET, value: 10),
        const rf.Condition.equals(name: rf.DESKTOP, value: 12),
      ],
    ).value;

    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: fontSize * 1.2),
                    SizedBox(width: ResponsiveUtils.spacing(context, 8)),
                  ],
                  ResponsiveFrameworkText(
                    text,
                    baseStyle: TextStyle(
                      fontSize: fontSize,
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

/// Layout builder that adapts to different screen sizes
class ResponsiveLayoutWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayoutWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return rf.ResponsiveValue<Widget>(
      context,
      defaultValue: mobile, // Default value
      conditionalValues: [
        rf.Condition.equals(name: rf.MOBILE, value: mobile),
        rf.Condition.equals(name: rf.TABLET, value: tablet ?? mobile),
        rf.Condition.equals(
          name: rf.DESKTOP,
          value: desktop ?? tablet ?? mobile,
        ),
      ],
    ).value;
  }
}

/// Responsive grid view
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = rf.ResponsiveValue<int>(
      context,
      defaultValue: 1, // Default value
      conditionalValues: [
        const rf.Condition.equals(name: rf.MOBILE, value: 1),
        const rf.Condition.equals(name: rf.TABLET, value: 2),
        const rf.Condition.equals(name: rf.DESKTOP, value: 3),
      ],
    ).value;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio ?? 1.0,
      mainAxisSpacing: mainAxisSpacing ?? 16,
      crossAxisSpacing: crossAxisSpacing ?? 16,
      children: children,
    );
  }
}
