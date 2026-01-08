import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: IndustrialInfoApp()));
}

class IndustrialInfoApp extends StatefulWidget {
  const IndustrialInfoApp({super.key});

  @override
  State<IndustrialInfoApp> createState() => _IndustrialInfoAppState();
}

class _IndustrialInfoAppState extends State<IndustrialInfoApp> {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Industrial Information and Conversions',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
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

    // Show main app
    return MaterialApp.router(
      title: 'Industrial Information and Conversions',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
