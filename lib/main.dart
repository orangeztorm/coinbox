import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'core/core.dart';
import 'features/features.dart';

void main() {
  // Configure logger based on environment
  LoggerConfig.configureForDevelopment();

  // Log app startup
  AppLogger.info('🚀 Coinbox Currency Converter starting up');
  AppLogger.debug(
    'Environment: ${const String.fromEnvironment('ENVIRONMENT', defaultValue: 'development')}',
  );

  // Initialize image cache manager
  ImageCacheManager.configureCache();

  runApp(const ProviderScope(child: CoinboxApp()));
}

class CoinboxApp extends StatelessWidget {
  const CoinboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coinbox - Currency Converter',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      theme: AppTheme.lightTheme,
      builder: (context, child) => rf.ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const rf.Breakpoint(start: 0, end: 450, name: rf.MOBILE),
          const rf.Breakpoint(start: 451, end: 800, name: rf.TABLET),
          const rf.Breakpoint(start: 801, end: 1920, name: rf.DESKTOP),
          const rf.Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: const ResponsiveAppWrapper(),
    );
  }
}

/// Wrapper widget to ensure ResponsiveValue works properly
class ResponsiveAppWrapper extends StatefulWidget {
  const ResponsiveAppWrapper({super.key});

  @override
  State<ResponsiveAppWrapper> createState() => _ResponsiveAppWrapperState();
}

class _ResponsiveAppWrapperState extends State<ResponsiveAppWrapper> {
  @override
  void initState() {
    super.initState();
    _preloadFlags();
  }

  Future<void> _preloadFlags() async {
    try {
      await CurrencyFlagPreloader.preloadCommonFlags();
      AppLogger.info('✅ Common currency flags preloaded successfully');
    } catch (e) {
      AppLogger.warning('⚠️ Failed to preload currency flags: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.debug('ResponsiveAppWrapper building');

    return const CurrencyConverterScreen();
  }
}
