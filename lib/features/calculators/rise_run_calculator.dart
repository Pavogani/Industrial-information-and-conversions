import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// OSHA Standards:
// - Max riser height: 7" (stairs), 12" (industrial)
// - Min tread depth: 11" (stairs)
// - Ramps: max 1:12 slope (8.33%) for ADA compliance

enum CalculationType { stairs, ramp, ladder }

class RiseRunState {
  final double totalRise; // Total vertical rise in inches
  final double riserHeight; // Individual riser height
  final double treadDepth; // Tread depth for stairs
  final CalculationType calcType;

  const RiseRunState({
    this.totalRise = 36.0,
    this.riserHeight = 7.0,
    this.treadDepth = 11.0,
    this.calcType = CalculationType.stairs,
  });

  int get numberOfSteps => (totalRise / riserHeight).ceil();
  double get actualRiserHeight => totalRise / numberOfSteps;
  double get totalRun => (numberOfSteps - 1) * treadDepth;
  double get stringerLength => sqrt(pow(totalRise, 2) + pow(totalRun, 2));
  double get angleDegreees {
    if (totalRun == 0) return 90;
    return atan(totalRise / totalRun) * 180 / pi;
  }

  // OSHA compliance checks
  bool get riserCompliant => actualRiserHeight <= 7.5 && actualRiserHeight >= 4;
  bool get treadCompliant => treadDepth >= 11;
  double get riseRunSum => actualRiserHeight + treadDepth;
  bool get comfortRuleCompliant => riseRunSum >= 17 && riseRunSum <= 18;

  // For ramps
  double get rampSlope => totalRun > 0 ? totalRise / totalRun : 0;
  double get rampSlopePercent => rampSlope * 100;
  String get rampRatio => totalRun > 0 ? '1:${(totalRun / totalRise).toStringAsFixed(1)}' : 'N/A';
  bool get adaCompliant => rampSlope <= (1 / 12); // 1:12 max slope

  RiseRunState copyWith({
    double? totalRise,
    double? riserHeight,
    double? treadDepth,
    CalculationType? calcType,
  }) {
    return RiseRunState(
      totalRise: totalRise ?? this.totalRise,
      riserHeight: riserHeight ?? this.riserHeight,
      treadDepth: treadDepth ?? this.treadDepth,
      calcType: calcType ?? this.calcType,
    );
  }
}

class RiseRunNotifier extends StateNotifier<RiseRunState> {
  RiseRunNotifier() : super(const RiseRunState());

  void setTotalRise(double value) => state = state.copyWith(totalRise: value);
  void setRiserHeight(double value) => state = state.copyWith(riserHeight: value);
  void setTreadDepth(double value) => state = state.copyWith(treadDepth: value);
  void setCalcType(CalculationType type) => state = state.copyWith(calcType: type);
  void reset() => state = const RiseRunState();
}

final riseRunProvider =
    StateNotifierProvider<RiseRunNotifier, RiseRunState>((ref) {
  return RiseRunNotifier();
});

class RiseRunCalculator extends ConsumerWidget {
  const RiseRunCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(riseRunProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rise & Run Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(riseRunProvider.notifier).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculation Type',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<CalculationType>(
                      segments: const [
                        ButtonSegment(
                          value: CalculationType.stairs,
                          label: Text('Stairs'),
                          icon: Icon(Icons.stairs),
                        ),
                        ButtonSegment(
                          value: CalculationType.ramp,
                          label: Text('Ramp'),
                          icon: Icon(Icons.trending_up),
                        ),
                      ],
                      selected: {state.calcType},
                      onSelectionChanged: (selection) {
                        ref
                            .read(riseRunProvider.notifier)
                            .setCalcType(selection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Measurements',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _InputField(
                      label: 'Total Rise (inches)',
                      value: state.totalRise,
                      onChanged: (v) =>
                          ref.read(riseRunProvider.notifier).setTotalRise(v),
                    ),
                    const SizedBox(height: 12),
                    if (state.calcType == CalculationType.stairs) ...[
                      _InputField(
                        label: 'Target Riser Height (inches)',
                        value: state.riserHeight,
                        onChanged: (v) =>
                            ref.read(riseRunProvider.notifier).setRiserHeight(v),
                      ),
                      const SizedBox(height: 12),
                      _InputField(
                        label: 'Tread Depth (inches)',
                        value: state.treadDepth,
                        onChanged: (v) =>
                            ref.read(riseRunProvider.notifier).setTreadDepth(v),
                      ),
                    ] else ...[
                      _InputField(
                        label: 'Total Run / Length (inches)',
                        value: state.totalRun,
                        onChanged: (v) {
                          // Calculate tread to achieve this run
                          if (state.numberOfSteps > 1) {
                            ref.read(riseRunProvider.notifier).setTreadDepth(
                                v / (state.numberOfSteps - 1));
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results
            if (state.calcType == CalculationType.stairs)
              _StairsResults(state: state)
            else
              _RampResults(state: state),

            const SizedBox(height: 16),

            // OSHA Standards Reference
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OSHA Standards',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    if (state.calcType == CalculationType.stairs) ...[
                      _StandardRow(
                        standard: 'Riser Height',
                        requirement: '4" - 7.5" max',
                        icon: Icons.height,
                      ),
                      _StandardRow(
                        standard: 'Tread Depth',
                        requirement: '11" minimum',
                        icon: Icons.straighten,
                      ),
                      _StandardRow(
                        standard: 'Rise + Run',
                        requirement: '17" - 18" ideal',
                        icon: Icons.calculate,
                      ),
                      _StandardRow(
                        standard: 'Angle',
                        requirement: '30° - 50° typical',
                        icon: Icons.architecture,
                      ),
                    ] else ...[
                      _StandardRow(
                        standard: 'ADA Slope',
                        requirement: '1:12 max (8.33%)',
                        icon: Icons.accessible,
                      ),
                      _StandardRow(
                        standard: 'Landings',
                        requirement: 'Every 30" rise',
                        icon: Icons.pause,
                      ),
                      _StandardRow(
                        standard: 'Width',
                        requirement: '36" minimum',
                        icon: Icons.width_normal,
                      ),
                    ],
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

class _StairsResults extends StatelessWidget {
  final RiseRunState state;

  const _StairsResults({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Result
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Number of Steps',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.numberOfSteps}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                Text(
                  'steps (${state.numberOfSteps - 1} treads)',
                  style: Theme.of(context).textTheme.bodyMedium,
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
                  'Calculated Dimensions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                _ResultRow(
                  label: 'Actual Riser Height',
                  value: '${state.actualRiserHeight.toStringAsFixed(3)}"',
                  isCompliant: state.riserCompliant,
                ),
                _ResultRow(
                  label: 'Tread Depth',
                  value: '${state.treadDepth.toStringAsFixed(2)}"',
                  isCompliant: state.treadCompliant,
                ),
                _ResultRow(
                  label: 'Total Run',
                  value: '${state.totalRun.toStringAsFixed(2)}" (${(state.totalRun / 12).toStringAsFixed(1)} ft)',
                  isCompliant: true,
                ),
                _ResultRow(
                  label: 'Stringer Length',
                  value: '${state.stringerLength.toStringAsFixed(2)}" (${(state.stringerLength / 12).toStringAsFixed(1)} ft)',
                  isCompliant: true,
                ),
                _ResultRow(
                  label: 'Angle',
                  value: '${state.angleDegreees.toStringAsFixed(1)}°',
                  isCompliant: state.angleDegreees >= 30 && state.angleDegreees <= 50,
                ),
                _ResultRow(
                  label: 'Rise + Run Sum',
                  value: '${state.riseRunSum.toStringAsFixed(2)}"',
                  isCompliant: state.comfortRuleCompliant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RampResults extends StatelessWidget {
  final RiseRunState state;

  const _RampResults({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: state.adaCompliant
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Ramp Slope',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  state.rampRatio,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '(${state.rampSlopePercent.toStringAsFixed(1)}%)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      state.adaCompliant ? Icons.check_circle : Icons.warning,
                      color: state.adaCompliant ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.adaCompliant
                          ? 'ADA Compliant'
                          : 'Exceeds ADA Maximum',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: state.adaCompliant ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ramp Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                _ResultRow(
                  label: 'Total Rise',
                  value: '${state.totalRise.toStringAsFixed(2)}"',
                  isCompliant: true,
                ),
                _ResultRow(
                  label: 'Required Run for 1:12',
                  value: '${(state.totalRise * 12).toStringAsFixed(0)}" (${(state.totalRise).toStringAsFixed(1)} ft)',
                  isCompliant: true,
                ),
                _ResultRow(
                  label: 'Ramp Length',
                  value: '${state.stringerLength.toStringAsFixed(2)}" (${(state.stringerLength / 12).toStringAsFixed(1)} ft)',
                  isCompliant: true,
                ),
                _ResultRow(
                  label: 'Angle',
                  value: '${state.angleDegreees.toStringAsFixed(1)}°',
                  isCompliant: state.angleDegreees <= 4.8, // ~1:12 = 4.76°
                ),
              ],
            ),
          ),
        ),
      ],
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

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isCompliant;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.isCompliant,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Row(
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Icon(
                isCompliant ? Icons.check_circle : Icons.warning,
                size: 16,
                color: isCompliant ? Colors.green : Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StandardRow extends StatelessWidget {
  final String standard;
  final String requirement;
  final IconData icon;

  const _StandardRow({
    required this.standard,
    required this.requirement,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(child: Text(standard)),
          Text(
            requirement,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
