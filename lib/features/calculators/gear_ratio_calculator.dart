import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GearStage {
  final int driverTeeth;
  final int drivenTeeth;

  const GearStage({required this.driverTeeth, required this.drivenTeeth});

  double get ratio => drivenTeeth / driverTeeth;
  bool get isReduction => drivenTeeth > driverTeeth;
  bool get isOverdrive => drivenTeeth < driverTeeth;
}

class GearRatioState {
  final List<GearStage> stages;
  final double inputRpm;
  final double inputTorque; // lb-ft

  const GearRatioState({
    this.stages = const [GearStage(driverTeeth: 20, drivenTeeth: 60)],
    this.inputRpm = 1750,
    this.inputTorque = 10,
  });

  double get totalRatio {
    if (stages.isEmpty) return 1.0;
    return stages.fold(1.0, (product, stage) => product * stage.ratio);
  }

  double get outputRpm => inputRpm / totalRatio;
  double get outputTorque => inputTorque * totalRatio * 0.95; // 95% efficiency assumed

  String get ratioDescription {
    if (totalRatio > 1) return 'Speed Reduction (Torque Increase)';
    if (totalRatio < 1) return 'Speed Increase (Torque Reduction)';
    return '1:1 Ratio';
  }

  GearRatioState copyWith({
    List<GearStage>? stages,
    double? inputRpm,
    double? inputTorque,
  }) {
    return GearRatioState(
      stages: stages ?? this.stages,
      inputRpm: inputRpm ?? this.inputRpm,
      inputTorque: inputTorque ?? this.inputTorque,
    );
  }
}

class GearRatioNotifier extends StateNotifier<GearRatioState> {
  GearRatioNotifier() : super(const GearRatioState());

  void setInputRpm(double value) => state = state.copyWith(inputRpm: value);
  void setInputTorque(double value) => state = state.copyWith(inputTorque: value);

  void updateStage(int index, {int? driverTeeth, int? drivenTeeth}) {
    final newStages = List<GearStage>.from(state.stages);
    final current = newStages[index];
    newStages[index] = GearStage(
      driverTeeth: driverTeeth ?? current.driverTeeth,
      drivenTeeth: drivenTeeth ?? current.drivenTeeth,
    );
    state = state.copyWith(stages: newStages);
  }

  void addStage() {
    state = state.copyWith(
      stages: [...state.stages, const GearStage(driverTeeth: 20, drivenTeeth: 40)],
    );
  }

  void removeStage(int index) {
    if (state.stages.length > 1) {
      final newStages = List<GearStage>.from(state.stages)..removeAt(index);
      state = state.copyWith(stages: newStages);
    }
  }

  void reset() => state = const GearRatioState();
}

final gearRatioProvider =
    StateNotifierProvider<GearRatioNotifier, GearRatioState>((ref) {
  return GearRatioNotifier();
});

class GearRatioCalculator extends ConsumerWidget {
  const GearRatioCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gearRatioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gear Ratio Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(gearRatioProvider.notifier).reset(),
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
                      'Input Values',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberInput(
                            label: 'Input RPM',
                            value: state.inputRpm,
                            onChanged: (v) =>
                                ref.read(gearRatioProvider.notifier).setInputRpm(v),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _NumberInput(
                            label: 'Input Torque (lb-ft)',
                            value: state.inputTorque,
                            onChanged: (v) =>
                                ref.read(gearRatioProvider.notifier).setInputTorque(v),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gear Stages
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gear Stages',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (state.stages.length < 4)
                          TextButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Stage'),
                            onPressed: () =>
                                ref.read(gearRatioProvider.notifier).addStage(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...state.stages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final stage = entry.value;
                      return _GearStageCard(
                        index: index,
                        stage: stage,
                        canRemove: state.stages.length > 1,
                        onDriverChanged: (v) => ref
                            .read(gearRatioProvider.notifier)
                            .updateStage(index, driverTeeth: v),
                        onDrivenChanged: (v) => ref
                            .read(gearRatioProvider.notifier)
                            .updateStage(index, drivenTeeth: v),
                        onRemove: () =>
                            ref.read(gearRatioProvider.notifier).removeStage(index),
                      );
                    }),
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
                      'Total Gear Ratio',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.totalRatio.toStringAsFixed(3)}:1',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    Text(
                      state.ratioDescription,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Output Values Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Output Values',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    _ResultRow(
                      label: 'Output RPM',
                      value: '${state.outputRpm.toStringAsFixed(1)} RPM',
                      icon: Icons.speed,
                    ),
                    _ResultRow(
                      label: 'Output Torque',
                      value: '${state.outputTorque.toStringAsFixed(2)} lb-ft',
                      icon: Icons.rotate_right,
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
                          const Icon(Icons.info_outline, size: 14),
                          const SizedBox(width: 8),
                          Text(
                            'Output torque assumes 95% efficiency per stage',
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
                    _FormulaItem(formula: 'Ratio = Driven Teeth ÷ Driver Teeth'),
                    _FormulaItem(formula: 'Output RPM = Input RPM ÷ Total Ratio'),
                    _FormulaItem(formula: 'Output Torque = Input Torque × Total Ratio × Efficiency'),
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

class _GearStageCard extends StatelessWidget {
  final int index;
  final GearStage stage;
  final bool canRemove;
  final ValueChanged<int> onDriverChanged;
  final ValueChanged<int> onDrivenChanged;
  final VoidCallback onRemove;

  const _GearStageCard({
    required this.index,
    required this.stage,
    required this.canRemove,
    required this.onDriverChanged,
    required this.onDrivenChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Stage ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: stage.isReduction
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${stage.ratio.toStringAsFixed(2)}:1',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: stage.isReduction ? Colors.green.shade700 : Colors.orange.shade700,
                    ),
                  ),
                ),
                if (canRemove)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onRemove,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TeethInput(
                    label: 'Driver (teeth)',
                    value: stage.driverTeeth,
                    onChanged: onDriverChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Expanded(
                  child: _TeethInput(
                    label: 'Driven (teeth)',
                    value: stage.drivenTeeth,
                    onChanged: onDrivenChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeethInput extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _TeethInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_TeethInput> createState() => _TeethInputState();
}

class _TeethInputState extends State<_TeethInput> {
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (value) {
        final parsed = int.tryParse(value);
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
  final IconData icon;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _FormulaItem extends StatelessWidget {
  final String formula;

  const _FormulaItem({required this.formula});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Text('• '),
          Expanded(
            child: Text(
              formula,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
