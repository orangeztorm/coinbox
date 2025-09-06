import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:coinbox/core/core.dart';
import 'package:coinbox/features/currency_converter/presentation/screens/currency_converter_screen.dart';

void main() {
  group('CurrencyConverterScreen Tests', () {
    Widget createTestWidget({Widget? child}) {
      return ProviderScope(
        child: ResponsiveBreakpoints.builder(
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('es', '')],
            home: child ?? const CurrencyConverterScreen(),
          ),
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
      );
    }

    testWidgets('should display app title and subheader', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify app title is displayed
      expect(find.text('Currency Converter'), findsOneWidget);

      // Verify subheader is displayed
      expect(
        find.text(
          'Check live rates, set rate alerts, receive notifications and more.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display gradient background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify that a Container with gradient decoration exists
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).gradient != null,
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display main layout components', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify that the screen contains the main layout components
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsWidgets); // Multiple stacks exist
    });

    testWidgets('should handle responsive layout', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(800, 600)); // Landscape

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the screen still renders correctly in landscape
      expect(find.text('Currency Converter'), findsOneWidget);

      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should display circular gradient container', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify that a circular container with gradient exists
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).shape == BoxShape.circle &&
              (widget.decoration as BoxDecoration).gradient != null,
        ),
        findsOneWidget,
      );
    });
  });
}
