import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

enum CalculationMode { hpFromTorque, torqueFromHp, ampsFromHp, hpFromAmps }
enum MotorPhase { singlePhase, threePhase }

class MotorHpState {
  final CalculationMode mode;
  final MotorPhase phase;
  final double horsepower;
  final double torque; // lb-ft
  final double rpm;
  final double voltage;
  final double amps;
  final double powerFactor;
  final double efficiency;

  const MotorHpState({
    this.mode = CalculationMode.hpFromTorque,
    this.phase = MotorPhase.threePhase,
    this.horsepower = 10,
    this.torque = 30,
    this.rpm = 1750,
    this.voltage = 460,
    this.amps = 14,
    this.powerFactor = 0.85,
    this.efficiency = 0.90,
  });

  // HP = (Torque × RPM) / 5252
  double get calculatedHpFromTorque => (torque * rpm) / 5252;

  // Torque = (HP × 5252) / RPM
  double get calculatedTorqueFromHp => (horsepower * 5252) / rpm;

  // Amps from HP (3-phase): I = (HP × 746) / (√3 × V × PF × Eff)
  // Amps from HP (1-phase): I = (HP × 746) / (V × PF × Eff)
  double get calculatedAmpsFromHp {
    final watts = horsepower * 746;
    if (phase == MotorPhase.threePhase) {
      return watts / (math.sqrt(3) * voltage * powerFactor * efficiency);
    } else {
      return watts / (voltage * powerFactor * efficiency);
    }
  }

  // HP from Amps (3-phase): HP = (√3 × V × I × PF × Eff) / 746
  // HP from Amps (1-phase): HP = (V × I × PF × Eff) / 746
  double get calculatedHpFromAmps {
    if (phase == MotorPhase.threePhase) {
      return (math.sqrt(3) * voltage * amps * powerFactor * efficiency) / 746;
    } else {
      return (voltage * amps * powerFactor * efficiency) / 746;
    }
  }

  double get result {
    switch (mode) {
      case CalculationMode.hpFromTorque:
        return calculatedHpFromTorque;
      case CalculationMode.torqueFromHp:
        return calculatedTorqueFromHp;
      case CalculationMode.ampsFromHp:
        return calculatedAmpsFromHp;
      case CalculationMode.hpFromAmps:
        return calculatedHpFromAmps;
    }
  }

  String get resultLabel {
    switch (mode) {
      case CalculationMode.hpFromTorque:
        return 'Horsepower';
      case CalculationMode.torqueFromHp:
        return 'Torque (lb-ft)';
      case CalculationMode.ampsFromHp:
        return 'Full Load Amps';
      case CalculationMode.hpFromAmps:
        return 'Horsepower';
    }
  }

  String get resultUnit {
    switch (mode) {
      case CalculationMode.hpFromTorque:
      case CalculationMode.hpFromAmps:
        return 'HP';
      case CalculationMode.torqueFromHp:
        return 'lb-ft';
      case CalculationMode.ampsFromHp:
        return 'A';
    }
  }

  MotorHpState copyWith({
    CalculationMode? mode,
    MotorPhase? phase,
    double? horsepower,
    double? torque,
    double? rpm,
    double? voltage,
    double? amps,
    double? powerFactor,
    double? efficiency,
  }) {
    return MotorHpState(
      mode: mode ?? this.mode,
      phase: phase ?? this.phase,
      horsepower: horsepower ?? this.horsepower,
      torque: torque ?? this.torque,
      rpm: rpm ?? this.rpm,
      voltage: voltage ?? this.voltage,
      amps: amps ?? this.amps,
      powerFactor: powerFactor ?? this.powerFactor,
      efficiency: efficiency ?? this.efficiency,
    );
  }
}

class MotorHpNotifier extends StateNotifier<MotorHpState> {
  MotorHpNotifier() : super(const MotorHpState());

  void setMode(CalculationMode mode) => state = state.copyWith(mode: mode);
  void setPhase(MotorPhase phase) => state = state.copyWith(phase: phase);
  void setHorsepower(double value) => state = state.copyWith(horsepower: value);
  void setTorque(double value) => state = state.copyWith(torque: value);
  void setRpm(double value) => state = state.copyWith(rpm: value);
  void setVoltage(double value) => state = state.copyWith(voltage: value);
  void setAmps(double value) => state = state.copyWith(amps: value);
  void setPowerFactor(double value) => state = state.copyWith(powerFactor: value);
  void setEfficiency(double value) => state = state.copyWith(efficiency: value);
  void reset() => state = const MotorHpState();
}

final motorHpProvider =
    StateNotifierProvider<MotorHpNotifier, MotorHpState>((ref) {
  return MotorHpNotifier();
});

class MotorHpCalculator extends ConsumerWidget {
  const MotorHpCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(motorHpProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motor / HP Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(motorHpProvider.notifier).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calculation Mode
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ModeChip(
                          label: 'HP from Torque',
                          selected: state.mode == CalculationMode.hpFromTorque,
                          onTap: () => ref
                              .read(motorHpProvider.notifier)
                              .setMode(CalculationMode.hpFromTorque),
                        ),
                        _ModeChip(
                          label: 'Torque from HP',
                          selected: state.mode == CalculationMode.torqueFromHp,
                          onTap: () => ref
                              .read(motorHpProvider.notifier)
                              .setMode(CalculationMode.torqueFromHp),
                        ),
                        _ModeChip(
                          label: 'Amps from HP',
                          selected: state.mode == CalculationMode.ampsFromHp,
                          onTap: () => ref
                              .read(motorHpProvider.notifier)
                              .setMode(CalculationMode.ampsFromHp),
                        ),
                        _ModeChip(
                          label: 'HP from Amps',
                          selected: state.mode == CalculationMode.hpFromAmps,
                          onTap: () => ref
                              .read(motorHpProvider.notifier)
                              .setMode(CalculationMode.hpFromAmps),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input Values based on mode
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
                    const SizedBox(height: 12),
                    _buildInputFields(context, ref, state),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Motor Phase (for electrical calculations)
            if (state.mode == CalculationMode.ampsFromHp ||
                state.mode == CalculationMode.hpFromAmps)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Motor Configuration',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<MotorPhase>(
                        segments: const [
                          ButtonSegment(
                            value: MotorPhase.singlePhase,
                            label: Text('1-Phase'),
                          ),
                          ButtonSegment(
                            value: MotorPhase.threePhase,
                            label: Text('3-Phase'),
                          ),
                        ],
                        selected: {state.phase},
                        onSelectionChanged: (selection) {
                          ref
                              .read(motorHpProvider.notifier)
                              .setPhase(selection.first);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _NumberInput(
                              label: 'Power Factor',
                              value: state.powerFactor,
                              onChanged: (v) => ref
                                  .read(motorHpProvider.notifier)
                                  .setPowerFactor(v),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _NumberInput(
                              label: 'Efficiency',
                              value: state.efficiency,
                              onChanged: (v) => ref
                                  .read(motorHpProvider.notifier)
                                  .setEfficiency(v),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (state.mode == CalculationMode.ampsFromHp ||
                state.mode == CalculationMode.hpFromAmps)
              const SizedBox(height: 16),

            // Results Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      state.resultLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.result.toStringAsFixed(2)} ${state.resultUnit}',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Formula Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.functions, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Formulas',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(),
                    _FormulaItem(
                      label: 'HP from Torque:',
                      formula: 'HP = (Torque × RPM) / 5252',
                    ),
                    _FormulaItem(
                      label: 'Torque from HP:',
                      formula: 'Torque = (HP × 5252) / RPM',
                    ),
                    _FormulaItem(
                      label: 'Amps (3Ø):',
                      formula: 'I = (HP × 746) / (√3 × V × PF × Eff)',
                    ),
                    _FormulaItem(
                      label: 'Amps (1Ø):',
                      formula: 'I = (HP × 746) / (V × PF × Eff)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Common Motor Speeds Reference
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Motor Speeds (60Hz)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    _SpeedRow(poles: 2, syncSpeed: 3600, fullLoadSpeed: '3450-3500'),
                    _SpeedRow(poles: 4, syncSpeed: 1800, fullLoadSpeed: '1725-1770'),
                    _SpeedRow(poles: 6, syncSpeed: 1200, fullLoadSpeed: '1140-1175'),
                    _SpeedRow(poles: 8, syncSpeed: 900, fullLoadSpeed: '850-875'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields(BuildContext context, WidgetRef ref, MotorHpState state) {
    switch (state.mode) {
      case CalculationMode.hpFromTorque:
        return Row(
          children: [
            Expanded(
              child: _NumberInput(
                label: 'Torque (lb-ft)',
                value: state.torque,
                onChanged: (v) => ref.read(motorHpProvider.notifier).setTorque(v),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _NumberInput(
                label: 'RPM',
                value: state.rpm,
                onChanged: (v) => ref.read(motorHpProvider.notifier).setRpm(v),
              ),
            ),
          ],
        );
      case CalculationMode.torqueFromHp:
        return Row(
          children: [
            Expanded(
              child: _NumberInput(
                label: 'Horsepower',
                value: state.horsepower,
                onChanged: (v) => ref.read(motorHpProvider.notifier).setHorsepower(v),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _NumberInput(
                label: 'RPM',
                value: state.rpm,
                onChanged: (v) => ref.read(motorHpProvider.notifier).setRpm(v),
              ),
            ),
          ],
        );
      case CalculationMode.ampsFromHp:
        return Row(
          children: [
            Expanded(
              child: _NumberInput(
                label: 'Horsepower',
                value: state.horsepower,
                onChanged: (v) => ref.read(motorHpProvider.notifier).setHorsepower(v),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _NumberInput(
                label: 'Voltage',
                value: state.voltage,
                onChanged: (v) => ref.read(motorHpProvider.notifier).setVoltage(v),
              ),
            ),
          ],
        );
      case CalculationMode.hpFromAmps:
        return Row(
          children: [
            Expanded(
              child: _NumberInput(
                label: 'Amps',
                value: state.amps,
                onChanged: (v) => ref.read(motorHpProvider.notifier).setAmps(v),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _NumberInput(
                label: 'Voltage',
                value: state.voltage,
                onChanged: (v) => ref.read(motorHpProvider.notifier).setVoltage(v),
              ),
            ),
          ],
        );
    }
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _NumberInput extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _NumberInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<_NumberInput> {
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

class _FormulaItem extends StatelessWidget {
  final String label;
  final String formula;

  const _FormulaItem({required this.label, required this.formula});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          Text(
            formula,
            style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SpeedRow extends StatelessWidget {
  final int poles;
  final int syncSpeed;
  final String fullLoadSpeed;

  const _SpeedRow({
    required this.poles,
    required this.syncSpeed,
    required this.fullLoadSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text('$poles-pole'),
          ),
          Expanded(
            child: Text('$syncSpeed RPM sync'),
          ),
          Text(
            '$fullLoadSpeed RPM',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
