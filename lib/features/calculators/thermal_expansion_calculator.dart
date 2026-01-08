import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThermalMaterial {
  final String name;
  final double coefficientImperial; // per °F (×10⁻⁶)
  final double coefficientMetric; // per °C (×10⁻⁶)

  const ThermalMaterial({
    required this.name,
    required this.coefficientImperial,
    required this.coefficientMetric,
  });
}

const List<ThermalMaterial> thermalMaterials = [
  ThermalMaterial(name: 'Carbon Steel', coefficientImperial: 6.5, coefficientMetric: 11.7),
  ThermalMaterial(name: 'Stainless Steel (304)', coefficientImperial: 9.6, coefficientMetric: 17.3),
  ThermalMaterial(name: 'Stainless Steel (316)', coefficientImperial: 8.9, coefficientMetric: 16.0),
  ThermalMaterial(name: 'Aluminum', coefficientImperial: 12.8, coefficientMetric: 23.1),
  ThermalMaterial(name: 'Copper', coefficientImperial: 9.2, coefficientMetric: 16.5),
  ThermalMaterial(name: 'Brass', coefficientImperial: 10.4, coefficientMetric: 18.7),
  ThermalMaterial(name: 'Bronze', coefficientImperial: 10.0, coefficientMetric: 18.0),
  ThermalMaterial(name: 'Cast Iron', coefficientImperial: 5.9, coefficientMetric: 10.6),
  ThermalMaterial(name: 'Nickel', coefficientImperial: 7.4, coefficientMetric: 13.3),
  ThermalMaterial(name: 'Titanium', coefficientImperial: 4.8, coefficientMetric: 8.6),
  ThermalMaterial(name: 'Invar (Ni-Fe)', coefficientImperial: 0.7, coefficientMetric: 1.3),
  ThermalMaterial(name: 'PVC', coefficientImperial: 28.0, coefficientMetric: 50.4),
  ThermalMaterial(name: 'HDPE', coefficientImperial: 67.0, coefficientMetric: 120.0),
  ThermalMaterial(name: 'Concrete', coefficientImperial: 5.5, coefficientMetric: 10.0),
];

class ThermalExpansionState {
  final int selectedMaterialIndex;
  final double length; // inches or mm
  final double tempInitial;
  final double tempFinal;
  final bool useMetric;

  const ThermalExpansionState({
    this.selectedMaterialIndex = 0,
    this.length = 120, // 10 feet
    this.tempInitial = 70,
    this.tempFinal = 200,
    this.useMetric = false,
  });

  ThermalMaterial get material => thermalMaterials[selectedMaterialIndex];

  double get tempChange => tempFinal - tempInitial;

  double get coefficient =>
      useMetric ? material.coefficientMetric : material.coefficientImperial;

  // ΔL = L × α × ΔT
  double get expansion {
    return length * (coefficient / 1000000) * tempChange;
  }

  String get expansionFormatted {
    if (expansion.abs() < 0.001) {
      return '${(expansion * 1000).toStringAsFixed(3)} ${useMetric ? "μm" : "mils"}';
    }
    return '${expansion.toStringAsFixed(4)} ${useMetric ? "mm" : "in"}';
  }

  double get finalLength => length + expansion;

  ThermalExpansionState copyWith({
    int? selectedMaterialIndex,
    double? length,
    double? tempInitial,
    double? tempFinal,
    bool? useMetric,
  }) {
    return ThermalExpansionState(
      selectedMaterialIndex: selectedMaterialIndex ?? this.selectedMaterialIndex,
      length: length ?? this.length,
      tempInitial: tempInitial ?? this.tempInitial,
      tempFinal: tempFinal ?? this.tempFinal,
      useMetric: useMetric ?? this.useMetric,
    );
  }
}

class ThermalExpansionNotifier extends StateNotifier<ThermalExpansionState> {
  ThermalExpansionNotifier() : super(const ThermalExpansionState());

  void setMaterial(int index) => state = state.copyWith(selectedMaterialIndex: index);
  void setLength(double value) => state = state.copyWith(length: value);
  void setTempInitial(double value) => state = state.copyWith(tempInitial: value);
  void setTempFinal(double value) => state = state.copyWith(tempFinal: value);
  void toggleUnits() => state = state.copyWith(useMetric: !state.useMetric);
  void reset() => state = const ThermalExpansionState();
}

final thermalExpansionProvider =
    StateNotifierProvider<ThermalExpansionNotifier, ThermalExpansionState>((ref) {
  return ThermalExpansionNotifier();
});

class ThermalExpansionCalculator extends ConsumerWidget {
  const ThermalExpansionCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(thermalExpansionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thermal Expansion'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(state.useMetric ? Icons.straighten : Icons.square_foot),
            tooltip: state.useMetric ? 'Switch to Imperial' : 'Switch to Metric',
            onPressed: () =>
                ref.read(thermalExpansionProvider.notifier).toggleUnits(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(thermalExpansionProvider.notifier).reset(),
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
                        'Calculate linear expansion/contraction of materials due to temperature change.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Material Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Material',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<int>(
                      initialSelection: state.selectedMaterialIndex,
                      expandedInsets: EdgeInsets.zero,
                      dropdownMenuEntries: thermalMaterials.asMap().entries.map((e) {
                        return DropdownMenuEntry(
                          value: e.key,
                          label: e.value.name,
                        );
                      }).toList(),
                      onSelected: (value) {
                        if (value != null) {
                          ref
                              .read(thermalExpansionProvider.notifier)
                              .setMaterial(value);
                        }
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
                          const Icon(Icons.thermostat, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'α = ${state.coefficient.toStringAsFixed(1)} × 10⁻⁶ per ${state.useMetric ? "°C" : "°F"}',
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

            // Length Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Length',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _NumberInput(
                      label: 'Length (${state.useMetric ? "mm" : "inches"})',
                      value: state.length,
                      onChanged: (v) =>
                          ref.read(thermalExpansionProvider.notifier).setLength(v),
                    ),
                    const SizedBox(height: 12),
                    if (!state.useMetric)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _QuickChip(
                            label: '1 ft',
                            onTap: () => ref
                                .read(thermalExpansionProvider.notifier)
                                .setLength(12),
                          ),
                          _QuickChip(
                            label: '10 ft',
                            onTap: () => ref
                                .read(thermalExpansionProvider.notifier)
                                .setLength(120),
                          ),
                          _QuickChip(
                            label: '20 ft',
                            onTap: () => ref
                                .read(thermalExpansionProvider.notifier)
                                .setLength(240),
                          ),
                          _QuickChip(
                            label: '100 ft',
                            onTap: () => ref
                                .read(thermalExpansionProvider.notifier)
                                .setLength(1200),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Temperature Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temperature Change',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberInput(
                            label: 'Initial (${state.useMetric ? "°C" : "°F"})',
                            value: state.tempInitial,
                            onChanged: (v) => ref
                                .read(thermalExpansionProvider.notifier)
                                .setTempInitial(v),
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
                          child: _NumberInput(
                            label: 'Final (${state.useMetric ? "°C" : "°F"})',
                            value: state.tempFinal,
                            onChanged: (v) => ref
                                .read(thermalExpansionProvider.notifier)
                                .setTempFinal(v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'ΔT = ${state.tempChange.toStringAsFixed(0)}${state.useMetric ? "°C" : "°F"} ${state.tempChange > 0 ? "(heating)" : state.tempChange < 0 ? "(cooling)" : ""}',
                        style: TextStyle(
                          color: state.tempChange > 0
                              ? Colors.red.shade700
                              : state.tempChange < 0
                                  ? Colors.blue.shade700
                                  : null,
                          fontWeight: FontWeight.w500,
                        ),
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
                      state.expansion >= 0 ? 'Expansion' : 'Contraction',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.expansionFormatted,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ResultItem(
                          label: 'Original',
                          value:
                              '${state.length.toStringAsFixed(3)} ${state.useMetric ? "mm" : "in"}',
                        ),
                        const SizedBox(width: 32),
                        _ResultItem(
                          label: 'Final',
                          value:
                              '${state.finalLength.toStringAsFixed(4)} ${state.useMetric ? "mm" : "in"}',
                        ),
                      ],
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
                          'Formula',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text(
                      'ΔL = L × α × ΔT',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Where:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    _FormulaLegend(symbol: 'ΔL', meaning: 'Change in length'),
                    _FormulaLegend(symbol: 'L', meaning: 'Original length'),
                    _FormulaLegend(symbol: 'α', meaning: 'Coefficient of thermal expansion'),
                    _FormulaLegend(symbol: 'ΔT', meaning: 'Change in temperature'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tips Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Practical Applications',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TipItem(text: 'Allow for expansion in long pipe runs'),
                    _TipItem(text: 'Account for shaft growth in hot pumps'),
                    _TipItem(text: 'Check bearing fits at operating temperature'),
                    _TipItem(text: 'Plan expansion gaps in rail and bridge work'),
                    _TipItem(text: 'Use Invar for precision instruments'),
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        final parsed = double.tryParse(value);
        if (parsed != null) {
          widget.onChanged(parsed);
        }
      },
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;

  const _ResultItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}

class _FormulaLegend extends StatelessWidget {
  final String symbol;
  final String meaning;

  const _FormulaLegend({required this.symbol, required this.meaning});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              symbol,
              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600),
            ),
          ),
          Text(' = $meaning'),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
