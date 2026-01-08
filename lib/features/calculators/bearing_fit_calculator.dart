import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FitType { shaft, housing }
enum LoadCondition { rotating, stationary, indeterminate }
enum LoadMagnitude { light, normal, heavy, veryHeavy }

class BearingFitState {
  final double boreDiameter; // mm
  final double odDiameter; // mm
  final FitType fitType;
  final LoadCondition innerRingLoad;
  final LoadCondition outerRingLoad;
  final LoadMagnitude loadMagnitude;

  const BearingFitState({
    this.boreDiameter = 50.0,
    this.odDiameter = 90.0,
    this.fitType = FitType.shaft,
    this.innerRingLoad = LoadCondition.rotating,
    this.outerRingLoad = LoadCondition.stationary,
    this.loadMagnitude = LoadMagnitude.normal,
  });

  // Get recommended fit class based on conditions
  String get recommendedFit {
    if (fitType == FitType.shaft) {
      // Shaft fits for inner ring
      if (innerRingLoad == LoadCondition.rotating) {
        // Rotating inner ring load - needs interference fit
        switch (loadMagnitude) {
          case LoadMagnitude.light:
            return 'j5 or j6';
          case LoadMagnitude.normal:
            return 'k5 or k6';
          case LoadMagnitude.heavy:
            return 'm5 or m6';
          case LoadMagnitude.veryHeavy:
            return 'n6 or p6';
        }
      } else if (innerRingLoad == LoadCondition.stationary) {
        // Stationary inner ring - transition or clearance fit
        return 'g6 or h6';
      } else {
        // Indeterminate - use transition fit
        return 'j6 or k6';
      }
    } else {
      // Housing fits for outer ring
      if (outerRingLoad == LoadCondition.rotating) {
        // Rotating outer ring - needs interference fit
        switch (loadMagnitude) {
          case LoadMagnitude.light:
            return 'K7 or M7';
          case LoadMagnitude.normal:
            return 'M7 or N7';
          case LoadMagnitude.heavy:
            return 'N7 or P7';
          case LoadMagnitude.veryHeavy:
            return 'P7';
        }
      } else if (outerRingLoad == LoadCondition.stationary) {
        // Stationary outer ring - clearance or transition fit
        return 'H7 or J7';
      } else {
        // Indeterminate
        return 'J7 or K7';
      }
    }
  }

  // Get tolerance values (simplified - actual values depend on specific size ranges)
  Map<String, double> get toleranceRange {
    // ISO tolerance values (approximate for common sizes 30-80mm)
    // In practice, look up exact values from ISO 286 tables
    final tolerances = <String, Map<String, double>>{
      // Shaft tolerances (lower case)
      'g6': {'upper': -0.010, 'lower': -0.029},
      'h6': {'upper': 0.000, 'lower': -0.019},
      'j5': {'upper': 0.006, 'lower': -0.007},
      'j6': {'upper': 0.008, 'lower': -0.011},
      'k5': {'upper': 0.011, 'lower': -0.002},
      'k6': {'upper': 0.015, 'lower': -0.004},
      'm5': {'upper': 0.016, 'lower': 0.003},
      'm6': {'upper': 0.021, 'lower': 0.002},
      'n6': {'upper': 0.028, 'lower': 0.009},
      'p6': {'upper': 0.037, 'lower': 0.018},
      // Housing tolerances (upper case)
      'H7': {'upper': 0.030, 'lower': 0.000},
      'J7': {'upper': 0.018, 'lower': -0.012},
      'K7': {'upper': 0.006, 'lower': -0.024},
      'M7': {'upper': -0.004, 'lower': -0.034},
      'N7': {'upper': -0.014, 'lower': -0.044},
      'P7': {'upper': -0.026, 'lower': -0.056},
    };

    final fitClass = recommendedFit.split(' or ')[0];
    return tolerances[fitClass] ?? {'upper': 0.0, 'lower': 0.0};
  }

  String get fitDescription {
    final fit = recommendedFit.split(' or ')[0];
    if (fit.startsWith('g') || fit.startsWith('h') || fit.startsWith('H')) {
      return 'Clearance Fit - Easy assembly/disassembly';
    } else if (fit.startsWith('j') || fit.startsWith('J') || fit.startsWith('K')) {
      return 'Transition Fit - May have slight interference or clearance';
    } else {
      return 'Interference Fit - Requires press or heat for assembly';
    }
  }

  BearingFitState copyWith({
    double? boreDiameter,
    double? odDiameter,
    FitType? fitType,
    LoadCondition? innerRingLoad,
    LoadCondition? outerRingLoad,
    LoadMagnitude? loadMagnitude,
  }) {
    return BearingFitState(
      boreDiameter: boreDiameter ?? this.boreDiameter,
      odDiameter: odDiameter ?? this.odDiameter,
      fitType: fitType ?? this.fitType,
      innerRingLoad: innerRingLoad ?? this.innerRingLoad,
      outerRingLoad: outerRingLoad ?? this.outerRingLoad,
      loadMagnitude: loadMagnitude ?? this.loadMagnitude,
    );
  }
}

class BearingFitNotifier extends StateNotifier<BearingFitState> {
  BearingFitNotifier() : super(const BearingFitState());

  void setBoreDiameter(double value) => state = state.copyWith(boreDiameter: value);
  void setOdDiameter(double value) => state = state.copyWith(odDiameter: value);
  void setFitType(FitType type) => state = state.copyWith(fitType: type);
  void setInnerRingLoad(LoadCondition condition) =>
      state = state.copyWith(innerRingLoad: condition);
  void setOuterRingLoad(LoadCondition condition) =>
      state = state.copyWith(outerRingLoad: condition);
  void setLoadMagnitude(LoadMagnitude magnitude) =>
      state = state.copyWith(loadMagnitude: magnitude);
  void reset() => state = const BearingFitState();
}

final bearingFitProvider =
    StateNotifierProvider<BearingFitNotifier, BearingFitState>((ref) {
  return BearingFitNotifier();
});

class BearingFitCalculator extends ConsumerWidget {
  const BearingFitCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bearingFitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bearing Fit Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(bearingFitProvider.notifier).reset(),
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
                        'Select bearing dimensions and load conditions to determine recommended shaft or housing tolerances.',
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

            // Fit Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculate Fit For',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<FitType>(
                      segments: const [
                        ButtonSegment(
                          value: FitType.shaft,
                          label: Text('Shaft'),
                          icon: Icon(Icons.circle_outlined),
                        ),
                        ButtonSegment(
                          value: FitType.housing,
                          label: Text('Housing'),
                          icon: Icon(Icons.square_outlined),
                        ),
                      ],
                      selected: {state.fitType},
                      onSelectionChanged: (selection) {
                        ref
                            .read(bearingFitProvider.notifier)
                            .setFitType(selection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bearing Dimensions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bearing Dimensions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DimensionInput(
                            label: 'Bore (d)',
                            value: state.boreDiameter,
                            onChanged: (v) => ref
                                .read(bearingFitProvider.notifier)
                                .setBoreDiameter(v),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _DimensionInput(
                            label: 'OD (D)',
                            value: state.odDiameter,
                            onChanged: (v) => ref
                                .read(bearingFitProvider.notifier)
                                .setOdDiameter(v),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Load Conditions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Load Conditions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Inner Ring Load Direction',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<LoadCondition>(
                      segments: const [
                        ButtonSegment(value: LoadCondition.rotating, label: Text('Rotating')),
                        ButtonSegment(value: LoadCondition.stationary, label: Text('Stationary')),
                        ButtonSegment(value: LoadCondition.indeterminate, label: Text('Indeterm.')),
                      ],
                      selected: {state.innerRingLoad},
                      onSelectionChanged: (selection) {
                        ref
                            .read(bearingFitProvider.notifier)
                            .setInnerRingLoad(selection.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Load Magnitude',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownMenu<LoadMagnitude>(
                      initialSelection: state.loadMagnitude,
                      expandedInsets: EdgeInsets.zero,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: LoadMagnitude.light, label: 'Light (P ≤ 0.05C)'),
                        DropdownMenuEntry(value: LoadMagnitude.normal, label: 'Normal (P ≤ 0.10C)'),
                        DropdownMenuEntry(value: LoadMagnitude.heavy, label: 'Heavy (P ≤ 0.15C)'),
                        DropdownMenuEntry(value: LoadMagnitude.veryHeavy, label: 'Very Heavy (P > 0.15C)'),
                      ],
                      onSelected: (value) {
                        if (value != null) {
                          ref
                              .read(bearingFitProvider.notifier)
                              .setLoadMagnitude(value);
                        }
                      },
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
                      'Recommended ${state.fitType == FitType.shaft ? "Shaft" : "Housing"} Fit',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.recommendedFit,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.fitDescription,
                      textAlign: TextAlign.center,
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

            // Tolerance Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tolerance Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(),
                    _ToleranceRow(
                      label: 'Nominal Size',
                      value: '${state.fitType == FitType.shaft ? state.boreDiameter : state.odDiameter} mm',
                    ),
                    _ToleranceRow(
                      label: 'Upper Deviation',
                      value: '${state.toleranceRange['upper']?.toStringAsFixed(3)} mm',
                    ),
                    _ToleranceRow(
                      label: 'Lower Deviation',
                      value: '${state.toleranceRange['lower']?.toStringAsFixed(3)} mm',
                    ),
                    const Divider(),
                    _ToleranceRow(
                      label: 'Max Size',
                      value:
                          '${((state.fitType == FitType.shaft ? state.boreDiameter : state.odDiameter) + (state.toleranceRange['upper'] ?? 0)).toStringAsFixed(3)} mm',
                      highlight: true,
                    ),
                    _ToleranceRow(
                      label: 'Min Size',
                      value:
                          '${((state.fitType == FitType.shaft ? state.boreDiameter : state.odDiameter) + (state.toleranceRange['lower'] ?? 0)).toStringAsFixed(3)} mm',
                      highlight: true,
                    ),
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
                          'Assembly Tips',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TipItem(text: 'Interference fits require heating ring or cooling shaft'),
                    _TipItem(text: 'Heat bearing to max 120°C (250°F) - never use open flame'),
                    _TipItem(text: 'Apply mounting force to fitted ring only'),
                    _TipItem(text: 'Verify shaft/housing roundness before mounting'),
                    _TipItem(text: 'Use proper bearing installation tools'),
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

class _DimensionInput extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _DimensionInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_DimensionInput> createState() => _DimensionInputState();
}

class _DimensionInputState extends State<_DimensionInput> {
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
        suffixText: 'mm',
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

class _ToleranceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _ToleranceRow({
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
