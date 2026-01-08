import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/providers/settings_provider.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: IndustrialInfoApp()));
}

class IndustrialInfoApp extends ConsumerStatefulWidget {
  const IndustrialInfoApp({super.key});

  @override
  ConsumerState<IndustrialInfoApp> createState() => _IndustrialInfoAppState();
}

class _IndustrialInfoAppState extends ConsumerState<IndustrialInfoApp> {
  bool? _onboardingComplete;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final complete = await OnboardingService.isOnboardingComplete();
    setState(() => _onboardingComplete = complete);
  }

  void _onOnboardingComplete() {
    setState(() => _onboardingComplete = true);
  }

  ThemeData _buildTheme(Brightness brightness, AppSettings settings) {
    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: brightness,
    );

    // Apply high contrast modifications if enabled
    final colorScheme = settings.highContrast
        ? baseColorScheme.copyWith(
            // Increase contrast for better visibility
            primary: brightness == Brightness.light
                ? Colors.blueGrey.shade900
                : Colors.blueGrey.shade100,
            onSurface: brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            surface: brightness == Brightness.light
                ? Colors.white
                : Colors.black,
          )
        : baseColorScheme;

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      // Apply larger touch targets if enabled
      materialTapTargetSize: settings.largeButtons
          ? MaterialTapTargetSize.padded
          : MaterialTapTargetSize.shrinkWrap,
      // Increase visual density for larger buttons
      visualDensity: settings.largeButtons
          ? VisualDensity.comfortable
          : VisualDensity.standard,
      // Apply text scaling to default text theme
      textTheme: settings.highContrast
          ? Typography.material2021().black.apply(
                fontSizeFactor: settings.textScale,
                bodyColor: brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                displayColor: brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    // Wrap with MediaQuery to apply text scaling globally
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(settings.textScale),
      ),
      child: MaterialApp(
        title: 'Industrial Information and Conversions',
        theme: _buildTheme(Brightness.light, settings),
        darkTheme: _buildTheme(Brightness.dark, settings),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: _buildHome(settings),
      ),
    );
  }

  Widget _buildHome(AppSettings settings) {
    // Still checking
    if (_onboardingComplete == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show onboarding
    if (!_onboardingComplete!) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
    }

    // Show main app with settings applied
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(settings.textScale),
      ),
      child: MaterialApp.router(
        title: 'Industrial Information and Conversions',
        theme: _buildTheme(Brightness.light, settings),
        darkTheme: _buildTheme(Brightness.dark, settings),
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
