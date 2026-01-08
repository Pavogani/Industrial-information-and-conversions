import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CalculationMode { drivenRpm, driverPulley, drivenPulley }

class PulleyRpmState {
  final double driverRpm;
  final double driverPulleyDia;
  final double drivenPulleyDia;
  final CalculationMode mode;

  const PulleyRpmState({
    this.driverRpm = 1750,
    this.driverPulleyDia = 6.0,
    this.drivenPulleyDia = 12.0,
    this.mode = CalculationMode.drivenRpm,
  });

  // Calculate driven RPM: Driven RPM = (Driver Dia × Driver RPM) / Driven Dia
  double get drivenRpm {
    if (drivenPulleyDia <= 0) return 0;
    return (driverPulleyDia * driverRpm) / drivenPulleyDia;
  }

  // Calculate required driver pulley for target driven RPM
  double calculateDriverPulley(double targetDrivenRpm) {
    if (driverRpm <= 0) return 0;
    return (targetDrivenRpm * drivenPulleyDia) / driverRpm;
  }

  // Calculate required driven pulley for target driven RPM
  double calculateDrivenPulley(double targetDrivenRpm) {
    if (targetDrivenRpm <= 0) return 0;
    return (driverPulleyDia * driverRpm) / targetDrivenRpm;
  }

  double get ratio => driverPulleyDia > 0 ? drivenPulleyDia / driverPulleyDia : 0;

  String get ratioDescription {
    if (ratio > 1) {
      return 'Speed Reduction (${ratio.toStringAsFixed(2)}:1)';
    } else if (ratio < 1) {
      return 'Speed Increase (1:${(1 / ratio).toStringAsFixed(2)})';
    } else {
      return 'Direct Drive (1:1)';
    }
  }

  PulleyRpmState copyWith({
    double? driverRpm,
    double? driverPulleyDia,
    double? drivenPulleyDia,
    CalculationMode? mode,
  }) {
    return PulleyRpmState(
      driverRpm: driverRpm ?? this.driverRpm,
      driverPulleyDia: driverPulleyDia ?? this.driverPulleyDia,
      drivenPulleyDia: drivenPulleyDia ?? this.drivenPulleyDia,
      mode: mode ?? this.mode,
    );
  }
}

class PulleyRpmNotifier extends StateNotifier<PulleyRpmState> {
  PulleyRpmNotifier() : super(const PulleyRpmState());

  void setDriverRpm(double value) => state = state.copyWith(driverRpm: value);
  void setDriverPulleyDia(double value) =>
      state = state.copyWith(driverPulleyDia: value);
  void setDrivenPulleyDia(double value) =>
      state = state.copyWith(drivenPulleyDia: value);
  void setMode(CalculationMode mode) => state = state.copyWith(mode: mode);
  void reset() => state = const PulleyRpmState();
}

final pulleyRpmProvider =
    StateNotifierProvider<PulleyRpmNotifier, PulleyRpmState>((ref) {
  return PulleyRpmNotifier();
});

// For calculating required pulley size
final targetRpmProvider = StateProvider<double>((ref) => 875);

class PulleyRpmCalculator extends ConsumerWidget {
  const PulleyRpmCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pulleyRpmProvider);
    final targetRpm = ref.watch(targetRpmProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulley/RPM Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(pulleyRpmProvider.notifier).reset();
              ref.read(targetRpmProvider.notifier).state = 875;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculate',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<CalculationMode>(
                      segments: const [
                        ButtonSegment(
                          value: CalculationMode.drivenRpm,
                          label: Text('Driven RPM'),
                        ),
                        ButtonSegment(
                          value: CalculationMode.driverPulley,
                          label: Text('Driver Size'),
                        ),
                        ButtonSegment(
                          value: CalculationMode.drivenPulley,
                          label: Text('Driven Size'),
                        ),
                      ],
                      selected: {state.mode},
                      onSelectionChanged: (selection) {
                        ref
                            .read(pulleyRpmProvider.notifier)
                            .setMode(selection.first);
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
                      'Input Values',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _InputField(
                      label: 'Driver (Motor) RPM',
                      value: state.driverRpm,
                      onChanged: (v) =>
                          ref.read(pulleyRpmProvider.notifier).setDriverRpm(v),
                    ),
                    const SizedBox(height: 12),
                    if (state.mode != CalculationMode.driverPulley)
                      _InputField(
                        label: 'Driver Pulley Diameter (in)',
                        value: state.driverPulleyDia,
                        onChanged: (v) => ref
                            .read(pulleyRpmProvider.notifier)
                            .setDriverPulleyDia(v),
                      ),
                    if (state.mode == CalculationMode.driverPulley) ...[
                      _InputField(
                        label: 'Target Driven RPM',
                        value: targetRpm,
                        onChanged: (v) =>
                            ref.read(targetRpmProvider.notifier).state = v,
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (state.mode != CalculationMode.drivenPulley)
                      _InputField(
                        label: 'Driven Pulley Diameter (in)',
                        value: state.drivenPulleyDia,
                        onChanged: (v) => ref
                            .read(pulleyRpmProvider.notifier)
                            .setDrivenPulleyDia(v),
                      ),
                    if (state.mode == CalculationMode.drivenPulley) ...[
                      _InputField(
                        label: 'Target Driven RPM',
                        value: targetRpm,
                        onChanged: (v) =>
                            ref.read(targetRpmProvider.notifier).state = v,
                      ),
                    ],
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
                      _getResultTitle(state.mode),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getResultValue(state, targetRpm),
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                    Text(
                      _getResultUnit(state.mode),
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

            // Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drive Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    _InfoRow(label: 'Driver RPM', value: '${state.driverRpm.toStringAsFixed(0)} RPM'),
                    _InfoRow(
                      label: 'Driver Pulley',
                      value: state.mode == CalculationMode.driverPulley
                          ? '${state.calculateDriverPulley(targetRpm).toStringAsFixed(2)}"'
                          : '${state.driverPulleyDia.toStringAsFixed(2)}"',
                    ),
                    _InfoRow(
                      label: 'Driven Pulley',
                      value: state.mode == CalculationMode.drivenPulley
                          ? '${state.calculateDrivenPulley(targetRpm).toStringAsFixed(2)}"'
                          : '${state.drivenPulleyDia.toStringAsFixed(2)}"',
                    ),
                    _InfoRow(
                      label: 'Driven RPM',
                      value: state.mode == CalculationMode.drivenRpm
                          ? '${state.drivenRpm.toStringAsFixed(0)} RPM'
                          : '${targetRpm.toStringAsFixed(0)} RPM (target)',
                    ),
                    const Divider(),
                    _InfoRow(label: 'Ratio', value: state.ratioDescription),
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
                      'Formulas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'RPM₂ = (D₁ × RPM₁) / D₂',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Where: D₁ = Driver dia, D₂ = Driven dia\nRPM₁ = Driver speed, RPM₂ = Driven speed',
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

  String _getResultTitle(CalculationMode mode) {
    switch (mode) {
      case CalculationMode.drivenRpm:
        return 'Driven RPM';
      case CalculationMode.driverPulley:
        return 'Required Driver Pulley';
      case CalculationMode.drivenPulley:
        return 'Required Driven Pulley';
    }
  }

  String _getResultValue(PulleyRpmState state, double targetRpm) {
    switch (state.mode) {
      case CalculationMode.drivenRpm:
        return state.drivenRpm.toStringAsFixed(0);
      case CalculationMode.driverPulley:
        return state.calculateDriverPulley(targetRpm).toStringAsFixed(2);
      case CalculationMode.drivenPulley:
        return state.calculateDrivenPulley(targetRpm).toStringAsFixed(2);
    }
  }

  String _getResultUnit(CalculationMode mode) {
    switch (mode) {
      case CalculationMode.drivenRpm:
        return 'RPM';
      case CalculationMode.driverPulley:
      case CalculationMode.drivenPulley:
        return 'inches diameter';
    }
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
