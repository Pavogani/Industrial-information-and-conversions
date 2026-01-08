import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_provider.dart';
import '../onboarding/onboarding_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Accessibility Section
          _SectionHeader(title: 'Accessibility'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                // Text Size
                ListTile(
                  leading: const Icon(Icons.text_fields),
                  title: const Text('Text Size'),
                  subtitle: Text(_getTextSizeLabel(settings.textScale)),
                  trailing: SizedBox(
                    width: 150,
                    child: Slider(
                      value: settings.textScale,
                      min: 0.8,
                      max: 1.4,
                      divisions: 6,
                      label: _getTextSizeLabel(settings.textScale),
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).setTextScale(value);
                      },
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Large Buttons
                SwitchListTile(
                  secondary: const Icon(Icons.touch_app),
                  title: const Text('Large Touch Targets'),
                  subtitle: const Text('Bigger buttons for gloved hands'),
                  value: settings.largeButtons,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setLargeButtons(value);
                  },
                ),
                const Divider(height: 1),

                // High Contrast
                SwitchListTile(
                  secondary: const Icon(Icons.contrast),
                  title: const Text('High Contrast'),
                  subtitle: const Text('Better visibility in bright light'),
                  value: settings.highContrast,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setHighContrast(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Units Section
          _SectionHeader(title: 'Default Units'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose your preferred unit system'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'imperial',
                          label: Text('Imperial'),
                          icon: Icon(Icons.square_foot),
                        ),
                        ButtonSegment(
                          value: 'metric',
                          label: Text('Metric'),
                          icon: Icon(Icons.straighten),
                        ),
                      ],
                      selected: {settings.defaultUnit},
                      onSelectionChanged: (Set<String> selection) {
                        ref.read(settingsProvider.notifier).setDefaultUnit(selection.first);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    settings.defaultUnit == 'imperial'
                        ? 'Using inches, feet, PSI, °F'
                        : 'Using mm, meters, kPa, °C',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _SectionHeader(title: 'About'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.replay),
                  title: const Text('Replay Tutorial'),
                  subtitle: const Text('View the onboarding guide again'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await OnboardingService.resetOnboarding();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tutorial will show on next app restart'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Preview Section
          _SectionHeader(title: 'Preview'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Text',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is how text will appear with your current settings. '
                    'Adjust the text size slider above to make it easier to read.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: settings.buttonHeight,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.calculate, size: settings.iconSize),
                      label: const Text('Sample Button'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: settings.inputHeight,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Sample Input',
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit, size: settings.iconSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTextSizeLabel(double scale) {
    if (scale <= 0.85) return 'Small';
    if (scale <= 0.95) return 'Default';
    if (scale <= 1.15) return 'Medium';
    if (scale <= 1.25) return 'Large';
    return 'Extra Large';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
