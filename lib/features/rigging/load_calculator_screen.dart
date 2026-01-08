import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/rigging_data.dart';

class LoadCalculatorState {
  final double loadWeight;
  final int numberOfLegs;
  final int slingAngle;
  final String slingType; // 'wire', 'chain', 'synthetic'

  const LoadCalculatorState({
    this.loadWeight = 1000,
    this.numberOfLegs = 2,
    this.slingAngle = 60,
    this.slingType = 'wire',
  });

  double get angleFactor => slingAngleFactors[slingAngle] ?? 0.707;

  double get loadPerLeg {
    if (numberOfLegs == 0) return 0;
    return loadWeight / (numberOfLegs * angleFactor);
  }

  double get requiredWll {
    // Apply 5:1 safety factor
    return loadPerLeg;
  }

  LoadCalculatorState copyWith({
    double? loadWeight,
    int? numberOfLegs,
    int? slingAngle,
    String? slingType,
  }) {
    return LoadCalculatorState(
      loadWeight: loadWeight ?? this.loadWeight,
      numberOfLegs: numberOfLegs ?? this.numberOfLegs,
      slingAngle: slingAngle ?? this.slingAngle,
      slingType: slingType ?? this.slingType,
    );
  }
}

class LoadCalculatorNotifier extends StateNotifier<LoadCalculatorState> {
  LoadCalculatorNotifier() : super(const LoadCalculatorState());

  void setLoadWeight(double value) => state = state.copyWith(loadWeight: value);
  void setNumberOfLegs(int value) => state = state.copyWith(numberOfLegs: value);
  void setSlingAngle(int value) => state = state.copyWith(slingAngle: value);
  void setSlingType(String value) => state = state.copyWith(slingType: value);
  void reset() => state = const LoadCalculatorState();
}

final loadCalculatorProvider =
    StateNotifierProvider<LoadCalculatorNotifier, LoadCalculatorState>((ref) {
  return LoadCalculatorNotifier();
});

class LoadCalculatorScreen extends ConsumerWidget {
  const LoadCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loadCalculatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(loadCalculatorProvider.notifier).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Load Weight Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Load Weight',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _WeightInput(
                      value: state.loadWeight,
                      onChanged: (v) =>
                          ref.read(loadCalculatorProvider.notifier).setLoadWeight(v),
                    ),
                    const SizedBox(height: 12),
                    // Quick select chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [500, 1000, 2000, 5000, 10000].map((w) {
                        return ActionChip(
                          label: Text('${_formatWeight(w.toDouble())} lbs'),
                          onPressed: () => ref
                              .read(loadCalculatorProvider.notifier)
                              .setLoadWeight(w.toDouble()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sling Configuration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sling Configuration',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // Number of Legs
                    Text(
                      'Number of Legs',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 1, label: Text('1')),
                        ButtonSegment(value: 2, label: Text('2')),
                        ButtonSegment(value: 3, label: Text('3')),
                        ButtonSegment(value: 4, label: Text('4')),
                      ],
                      selected: {state.numberOfLegs},
                      onSelectionChanged: (selection) {
                        ref
                            .read(loadCalculatorProvider.notifier)
                            .setNumberOfLegs(selection.first);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sling Angle
                    Text(
                      'Sling Angle from Horizontal',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 90, label: Text('90°')),
                        ButtonSegment(value: 60, label: Text('60°')),
                        ButtonSegment(value: 45, label: Text('45°')),
                        ButtonSegment(value: 30, label: Text('30°')),
                      ],
                      selected: {state.slingAngle},
                      onSelectionChanged: (selection) {
                        ref
                            .read(loadCalculatorProvider.notifier)
                            .setSlingAngle(selection.first);
                      },
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Angle Factor: ${state.angleFactor.toStringAsFixed(3)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Required Sling WLL',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatWeight(state.requiredWll)} lbs',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    Text(
                      'per leg minimum',
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

            // Calculation Breakdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculation Breakdown',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    _CalcRow(
                      label: 'Total Load',
                      value: '${_formatWeight(state.loadWeight)} lbs',
                    ),
                    _CalcRow(
                      label: 'Number of Legs',
                      value: '${state.numberOfLegs}',
                    ),
                    _CalcRow(
                      label: 'Sling Angle',
                      value: '${state.slingAngle}°',
                    ),
                    _CalcRow(
                      label: 'Angle Factor',
                      value: state.angleFactor.toStringAsFixed(3),
                    ),
                    const Divider(),
                    _CalcRow(
                      label: 'Load per Leg',
                      value: '${_formatWeight(state.loadPerLeg)} lbs',
                      highlight: true,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Formula: Load ÷ (Legs × Angle Factor)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Warning Card
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Important',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _WarningText(
                        text: 'Never exceed the Working Load Limit (WLL) of any sling'),
                    _WarningText(
                        text: 'Sling angles below 30° are NOT recommended'),
                    _WarningText(
                        text: 'Inspect all rigging before each lift'),
                    _WarningText(
                        text: 'Account for dynamic loads and shock loading'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatWeight(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _WeightInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _WeightInput({required this.value, required this.onChanged});

  @override
  State<_WeightInput> createState() => _WeightInputState();
}

class _WeightInputState extends State<_WeightInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toStringAsFixed(0));
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
        labelText: 'Weight (lbs)',
        border: OutlineInputBorder(),
        suffixText: 'lbs',
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

class _CalcRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _CalcRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              color: highlight ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningText extends StatelessWidget {
  final String text;

  const _WarningText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
