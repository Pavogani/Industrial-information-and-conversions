import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MaterialType { wood, softMetal, hardMetal, plastic, thinSheet }

extension MaterialTypeExt on MaterialType {
  String get displayName {
    switch (this) {
      case MaterialType.wood:
        return 'Wood / Soft Materials';
      case MaterialType.softMetal:
        return 'Soft Metal (Aluminum, Brass)';
      case MaterialType.hardMetal:
        return 'Hard Metal (Steel, Stainless)';
      case MaterialType.plastic:
        return 'Plastic / PVC';
      case MaterialType.thinSheet:
        return 'Thin Sheet Metal (<1/8")';
    }
  }

  String get tpiGuidance {
    switch (this) {
      case MaterialType.wood:
        return '3-6 TPI for fast cuts, 10-14 TPI for smooth finish';
      case MaterialType.softMetal:
        return '10-14 TPI recommended for clean cuts';
      case MaterialType.hardMetal:
        return '14-24 TPI, use slower feed rate';
      case MaterialType.plastic:
        return '10-14 TPI, moderate speed to prevent melting';
      case MaterialType.thinSheet:
        return '18-32 TPI to prevent grabbing';
    }
  }

  int get minRecommendedTpi {
    switch (this) {
      case MaterialType.wood:
        return 3;
      case MaterialType.softMetal:
        return 10;
      case MaterialType.hardMetal:
        return 14;
      case MaterialType.plastic:
        return 10;
      case MaterialType.thinSheet:
        return 18;
    }
  }

  int get maxRecommendedTpi {
    switch (this) {
      case MaterialType.wood:
        return 14;
      case MaterialType.softMetal:
        return 18;
      case MaterialType.hardMetal:
        return 32;
      case MaterialType.plastic:
        return 18;
      case MaterialType.thinSheet:
        return 32;
    }
  }
}

class SawBladeState {
  final double materialThickness;
  final MaterialType materialType;

  const SawBladeState({
    this.materialThickness = 0.5,
    this.materialType = MaterialType.softMetal,
  });

  // Minimum TPI for 3 teeth in work
  int get minimumTpi {
    if (materialThickness <= 0) return 0;
    return (3 / materialThickness).ceil();
  }

  // Recommended TPI range based on material
  String get recommendedRange {
    final minTpi = minimumTpi.clamp(
      materialType.minRecommendedTpi,
      materialType.maxRecommendedTpi,
    );
    return '$minTpi - ${materialType.maxRecommendedTpi} TPI';
  }

  // Best TPI selection
  int get bestTpi {
    return minimumTpi.clamp(
      materialType.minRecommendedTpi,
      materialType.maxRecommendedTpi,
    );
  }

  SawBladeState copyWith({
    double? materialThickness,
    MaterialType? materialType,
  }) {
    return SawBladeState(
      materialThickness: materialThickness ?? this.materialThickness,
      materialType: materialType ?? this.materialType,
    );
  }
}

class SawBladeNotifier extends StateNotifier<SawBladeState> {
  SawBladeNotifier() : super(const SawBladeState());

  void setThickness(double value) =>
      state = state.copyWith(materialThickness: value);
  void setMaterialType(MaterialType type) =>
      state = state.copyWith(materialType: type);
  void reset() => state = const SawBladeState();
}

final sawBladeProvider =
    StateNotifierProvider<SawBladeNotifier, SawBladeState>((ref) {
  return SawBladeNotifier();
});

class SawBladeCalculator extends ConsumerWidget {
  const SawBladeCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sawBladeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saw Blade TPI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(sawBladeProvider.notifier).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Rule: At least 3 teeth must be in contact with the material at all times for clean, safe cuts.',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Material Type
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Material Type',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<MaterialType>(
                      initialSelection: state.materialType,
                      expandedInsets: EdgeInsets.zero,
                      dropdownMenuEntries: MaterialType.values.map((type) {
                        return DropdownMenuEntry(
                          value: type,
                          label: type.displayName,
                        );
                      }).toList(),
                      onSelected: (value) {
                        if (value != null) {
                          ref
                              .read(sawBladeProvider.notifier)
                              .setMaterialType(value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.materialType.tpiGuidance,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Thickness Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Material Thickness',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _ThicknessInput(
                      value: state.materialThickness,
                      onChanged: (v) =>
                          ref.read(sawBladeProvider.notifier).setThickness(v),
                    ),
                    const SizedBox(height: 12),
                    // Quick select chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _QuickChip(
                            label: '1/16"',
                            value: 0.0625,
                            onTap: () => ref
                                .read(sawBladeProvider.notifier)
                                .setThickness(0.0625)),
                        _QuickChip(
                            label: '1/8"',
                            value: 0.125,
                            onTap: () => ref
                                .read(sawBladeProvider.notifier)
                                .setThickness(0.125)),
                        _QuickChip(
                            label: '1/4"',
                            value: 0.25,
                            onTap: () => ref
                                .read(sawBladeProvider.notifier)
                                .setThickness(0.25)),
                        _QuickChip(
                            label: '3/8"',
                            value: 0.375,
                            onTap: () => ref
                                .read(sawBladeProvider.notifier)
                                .setThickness(0.375)),
                        _QuickChip(
                            label: '1/2"',
                            value: 0.5,
                            onTap: () => ref
                                .read(sawBladeProvider.notifier)
                                .setThickness(0.5)),
                        _QuickChip(
                            label: '3/4"',
                            value: 0.75,
                            onTap: () => ref
                                .read(sawBladeProvider.notifier)
                                .setThickness(0.75)),
                        _QuickChip(
                            label: '1"',
                            value: 1.0,
                            onTap: () => ref
                                .read(sawBladeProvider.notifier)
                                .setThickness(1.0)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Recommended TPI',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.bestTpi}',
                      style:
                          Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                    Text(
                      'Teeth Per Inch',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculation Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    _InfoRow(
                      label: 'Minimum TPI (3-tooth rule)',
                      value: '${state.minimumTpi} TPI',
                    ),
                    _InfoRow(
                      label: 'Material range',
                      value:
                          '${state.materialType.minRecommendedTpi}-${state.materialType.maxRecommendedTpi} TPI',
                    ),
                    _InfoRow(
                      label: 'Recommended range',
                      value: state.recommendedRange,
                    ),
                    const Divider(),
                    Text(
                      'Pro Tips',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    _TipRow(
                        icon: Icons.speed,
                        tip: 'Lower TPI = Faster cut, rougher finish'),
                    _TipRow(
                        icon: Icons.auto_awesome,
                        tip: 'Higher TPI = Slower cut, smoother finish'),
                    _TipRow(
                        icon: Icons.warning_amber,
                        tip: 'Too few teeth = blade grabbing & kickback'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThicknessInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _ThicknessInput({required this.value, required this.onChanged});

  @override
  State<_ThicknessInput> createState() => _ThicknessInputState();
}

class _ThicknessInputState extends State<_ThicknessInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Thickness (inches)',
        border: OutlineInputBorder(),
        suffixText: '"',
      ),
      onChanged: (value) {
        final parsed = double.tryParse(value);
        if (parsed != null && parsed > 0) {
          widget.onChanged(parsed);
        }
      },
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final double value;
  final VoidCallback onTap;

  const _QuickChip({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String tip;

  const _TipRow({required this.icon, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(child: Text(tip, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}
