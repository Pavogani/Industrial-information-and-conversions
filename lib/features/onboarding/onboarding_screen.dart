import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Industrial Info',
      description: 'Your complete mobile reference for industrial information and conversions.',
      icon: Icons.construction,
      color: Colors.blue,
      features: [
        'Calculators for alignment, hydraulics, belts & more',
        'Reference charts always at your fingertips',
        'Welding guides and specifications',
        'Rigging calculations and safety data',
      ],
    ),
    OnboardingPage(
      title: 'Quick Conversions',
      description: 'Convert between imperial and metric units instantly.',
      icon: Icons.swap_horiz,
      color: Colors.blue,
      features: [
        'Length: inches ↔ mm, feet ↔ meters',
        'Temperature: °F ↔ °C',
        'Pressure: PSI ↔ bar ↔ kPa',
        'Weight, volume, and more',
      ],
      navHint: 'Find it in the "Convert" tab',
    ),
    OnboardingPage(
      title: 'Fastener Reference',
      description: 'Look up bolt sizes, wrench sizes, and tap drills.',
      icon: Icons.hardware,
      color: Colors.grey,
      features: [
        'Bolt diameter to wrench size',
        'Tap drill sizes for threads',
        'Decimal equivalents',
        'Metric conversions',
      ],
      navHint: 'Find it in the "Fasteners" tab',
    ),
    OnboardingPage(
      title: 'Industrial Calculators',
      description: '13+ calculators for common industrial tasks.',
      icon: Icons.calculate,
      color: Colors.green,
      features: [
        'Shaft alignment (reverse indicator)',
        'Belt length & pulley RPM',
        'Hydraulic cylinder force',
        'Gear ratios, motor HP, thermal expansion',
        'Conveyor & pump calculations',
      ],
      navHint: 'Find it in the "Calc" tab',
    ),
    OnboardingPage(
      title: 'Welding & Hot Work',
      description: 'Complete welding reference with rod guides and settings.',
      icon: Icons.local_fire_department,
      color: Colors.orange,
      features: [
        'Welding rod selection (6010, 7018, etc.)',
        'Amperage settings by rod size',
        'Weld joint types with diagrams',
        'Preheat calculator for carbon steels',
        'Process comparison (SMAW, MIG, TIG)',
      ],
      navHint: 'Find it in the "Welding" tab',
    ),
    OnboardingPage(
      title: 'Rigging & Lifting',
      description: 'Stay safe with proper load calculations.',
      icon: Icons.fitness_center,
      color: Colors.red,
      features: [
        'Sling working load limits (WLL)',
        'Load angle calculations',
        'Rigging knot references',
        'Chain, wire rope, and synthetic slings',
      ],
      navHint: 'Find it in the "Rigging" tab',
    ),
    OnboardingPage(
      title: 'Reference Materials',
      description: 'Essential charts and specs at your fingertips.',
      icon: Icons.menu_book,
      color: Colors.purple,
      features: [
        'Fraction to decimal conversion',
        'Torque specifications by bolt grade',
        'Pipe thread & schedule charts',
        'O-ring sizes, lubricants, hardness',
        'Wire gauge & drill/tap charts',
      ],
      navHint: 'Find it in the "Ref" tab',
    ),
    OnboardingPage(
      title: 'Global Search',
      description: 'Find any tool or reference quickly.',
      icon: Icons.search,
      color: Colors.teal,
      features: [
        'Search across all features',
        'Quick category navigation',
        'Keyword search for specific topics',
        'Tap the search button anytime!',
      ],
      navHint: 'Tap the floating search button',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: const Text('Skip'),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPageWidget(page: _pages[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _pages[index].color
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: _currentPage == 0 ? 1 : 1,
                    child: FilledButton(
                      onPressed: _nextPage,
                      style: FilledButton.styleFrom(
                        backgroundColor: _pages[_currentPage].color,
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> features;
  final String? navHint;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.features,
    this.navHint,
  });
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),

          // Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 64,
              color: page.color,
            ),
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Features list
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: page.features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: page.color,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Navigation hint
          if (page.navHint != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: page.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, size: 16, color: page.color),
                  const SizedBox(width: 8),
                  Text(
                    page.navHint!,
                    style: TextStyle(
                      color: page.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),
        ],
      ),
    );
  }
}

/// Service to check onboarding status
class OnboardingService {
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', false);
  }
}
