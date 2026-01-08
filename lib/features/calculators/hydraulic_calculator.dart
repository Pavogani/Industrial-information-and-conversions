import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HydraulicCalcMode { force, pressure, area }

class HydraulicState {
  final double pressure; // PSI
  final double boreDiameter; // inches
  final double rodDiameter; // inches (for retract force)
  final HydraulicCalcMode mode;

  const HydraulicState({
    this.pressure = 3000,
    this.boreDiameter = 4.0,
    this.rodDiameter = 2.0,
    this.mode = HydraulicCalcMode.force,
  });

  // Bore area = π × (D/2)²
  double get boreArea => pi * pow(boreDiameter / 2, 2);

  // Rod area = π × (d/2)²
  double get rodArea => pi * pow(rodDiameter / 2, 2);

  // Annular area (for retract) = Bore area - Rod area
  double get annularArea => boreArea - rodArea;

  // Extension force = Pressure × Bore Area
  double get extensionForce => pressure * boreArea;

  // Retraction force = Pressure × Annular Area
  double get retractionForce => pressure * annularArea;

  // Convert to tons
  double get extensionForceTons => extensionForce / 2000;
  double get retractionForceTons => retractionForce / 2000;

  HydraulicState copyWith({
    double? pressure,
    double? boreDiameter,
    double? rodDiameter,
    HydraulicCalcMode? mode,
  }) {
    return HydraulicState(
      pressure: pressure ?? this.pressure,
      boreDiameter: boreDiameter ?? this.boreDiameter,
      rodDiameter: rodDiameter ?? this.rodDiameter,
      mode: mode ?? this.mode,
    );
  }
}

class HydraulicNotifier extends StateNotifier<HydraulicState> {
  HydraulicNotifier() : super(const HydraulicState());

  void setPressure(double value) => state = state.copyWith(pressure: value);
  void setBoreDiameter(double value) =>
      state = state.copyWith(boreDiameter: value);
  void setRodDiameter(double value) =>
      state = state.copyWith(rodDiameter: value);
  void setMode(HydraulicCalcMode mode) => state = state.copyWith(mode: mode);
  void reset() => state = const HydraulicState();
}

final hydraulicProvider =
    StateNotifierProvider<HydraulicNotifier, HydraulicState>((ref) {
  return HydraulicNotifier();
});

class HydraulicCalculator extends ConsumerWidget {
  const HydraulicCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hydraulicProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydraulic Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(hydraulicProvider.notifier).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cylinder Specifications',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _InputField(
                      label: 'System Pressure (PSI)',
                      value: state.pressure,
                      onChanged: (v) =>
                          ref.read(hydraulicProvider.notifier).setPressure(v),
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      label: 'Bore Diameter (in)',
                      value: state.boreDiameter,
                      onChanged: (v) => ref
                          .read(hydraulicProvider.notifier)
                          .setBoreDiameter(v),
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      label: 'Rod Diameter (in)',
                      value: state.rodDiameter,
                      onChanged: (v) => ref
                          .read(hydraulicProvider.notifier)
                          .setRodDiameter(v),
                    ),
                    if (state.rodDiameter >= state.boreDiameter)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Rod diameter must be less than bore diameter',
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

            // Extension Force Result
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Extension Force (Push)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatNumber(state.extensionForce)} lbs',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                    Text(
                      '(${state.extensionForceTons.toStringAsFixed(2)} tons)',
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
            const SizedBox(height: 12),

            // Retraction Force Result
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color:
                              Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Retraction Force (Pull)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatNumber(state.retractionForce)} lbs',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                    ),
                    Text(
                      '(${state.retractionForceTons.toStringAsFixed(2)} tons)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Area Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculated Areas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    _InfoRow(
                      label: 'Bore Area',
                      value: '${state.boreArea.toStringAsFixed(3)} in²',
                    ),
                    _InfoRow(
                      label: 'Rod Area',
                      value: '${state.rodArea.toStringAsFixed(3)} in²',
                    ),
                    _InfoRow(
                      label: 'Annular Area',
                      value: '${state.annularArea.toStringAsFixed(3)} in²',
                    ),
                    const Divider(),
                    _InfoRow(
                      label: 'Area Ratio',
                      value: state.annularArea > 0
                          ? '${(state.boreArea / state.annularArea).toStringAsFixed(2)}:1'
                          : 'N/A',
                    ),
                    _InfoRow(
                      label: 'Force Ratio (Ext/Ret)',
                      value: state.retractionForce > 0
                          ? '${(state.extensionForce / state.retractionForce).toStringAsFixed(2)}:1'
                          : 'N/A',
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
                      'Formulas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Force = Pressure × Area',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                    Text(
                      'Area = π × (D/2)²',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Extension uses full bore area\nRetraction uses annular area (bore - rod)',
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

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
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
