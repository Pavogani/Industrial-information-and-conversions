import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeltLengthState {
  final double largePulleyDia; // Large pulley pitch diameter (inches)
  final double smallPulleyDia; // Small pulley pitch diameter (inches)
  final double centerDistance; // Center-to-center distance (inches)

  const BeltLengthState({
    this.largePulleyDia = 12.0,
    this.smallPulleyDia = 6.0,
    this.centerDistance = 24.0,
  });

  double get beltLength {
    // Belt length formula:
    // L = 2C + π(D+d)/2 + (D-d)²/(4C)
    // Where: C = center distance, D = large dia, d = small dia
    final d = smallPulleyDia;
    final D = largePulleyDia;
    final c = centerDistance;

    if (c <= 0) return 0;

    return (2 * c) +
        (pi * (D + d) / 2) +
        (pow(D - d, 2) / (4 * c));
  }

  // Calculate minimum center distance for pulleys
  double get minCenterDistance {
    return (largePulleyDia + smallPulleyDia) / 2 + 1;
  }

  // Calculate wrap angle on small pulley (degrees)
  double get smallPulleyWrap {
    if (centerDistance <= 0) return 0;
    final ratio = (largePulleyDia - smallPulleyDia) / (2 * centerDistance);
    if (ratio.abs() > 1) return 0;
    return 180 - (2 * asin(ratio) * 180 / pi);
  }

  BeltLengthState copyWith({
    double? largePulleyDia,
    double? smallPulleyDia,
    double? centerDistance,
  }) {
    return BeltLengthState(
      largePulleyDia: largePulleyDia ?? this.largePulleyDia,
      smallPulleyDia: smallPulleyDia ?? this.smallPulleyDia,
      centerDistance: centerDistance ?? this.centerDistance,
    );
  }
}

class BeltLengthNotifier extends StateNotifier<BeltLengthState> {
  BeltLengthNotifier() : super(const BeltLengthState());

  void setLargePulleyDia(double value) =>
      state = state.copyWith(largePulleyDia: value);
  void setSmallPulleyDia(double value) =>
      state = state.copyWith(smallPulleyDia: value);
  void setCenterDistance(double value) =>
      state = state.copyWith(centerDistance: value);

  void reset() => state = const BeltLengthState();
}

final beltLengthProvider =
    StateNotifierProvider<BeltLengthNotifier, BeltLengthState>((ref) {
  return BeltLengthNotifier();
});

class BeltLengthCalculator extends ConsumerWidget {
  const BeltLengthCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(beltLengthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Belt Length Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(beltLengthProvider.notifier).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pulley Dimensions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _InputField(
                      label: 'Large Pulley Pitch Diameter (in)',
                      value: state.largePulleyDia,
                      onChanged: (v) => ref
                          .read(beltLengthProvider.notifier)
                          .setLargePulleyDia(v),
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      label: 'Small Pulley Pitch Diameter (in)',
                      value: state.smallPulleyDia,
                      onChanged: (v) => ref
                          .read(beltLengthProvider.notifier)
                          .setSmallPulleyDia(v),
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      label: 'Center Distance (in)',
                      value: state.centerDistance,
                      onChanged: (v) => ref
                          .read(beltLengthProvider.notifier)
                          .setCenterDistance(v),
                    ),
                    if (state.centerDistance < state.minCenterDistance)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Min center distance: ${state.minCenterDistance.toStringAsFixed(2)}"',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
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
                      'Required Belt Length',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.beltLength.toStringAsFixed(2)}"',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                    Text(
                      '(${(state.beltLength / 12).toStringAsFixed(2)} ft)',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

            // Additional Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    _InfoRow(
                      label: 'Speed Ratio',
                      value: state.smallPulleyDia > 0
                          ? '${(state.largePulleyDia / state.smallPulleyDia).toStringAsFixed(2)}:1'
                          : 'N/A',
                    ),
                    _InfoRow(
                      label: 'Small Pulley Wrap Angle',
                      value: '${state.smallPulleyWrap.toStringAsFixed(1)}°',
                    ),
                    _InfoRow(
                      label: 'Min Wrap Recommended',
                      value: state.smallPulleyWrap >= 120
                          ? 'OK (≥120°)'
                          : 'Low (<120°)',
                      valueColor: state.smallPulleyWrap >= 120
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Formula reference
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formula Used',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'L = 2C + π(D+d)/2 + (D-d)²/(4C)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Where: L = Belt length, C = Center distance\nD = Large pulley dia, d = Small pulley dia',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
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

class _InputField extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _InputField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
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
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
