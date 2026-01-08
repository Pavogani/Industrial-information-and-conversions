import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreheatCalculatorScreen extends StatefulWidget {
  const PreheatCalculatorScreen({super.key});

  @override
  State<PreheatCalculatorScreen> createState() => _PreheatCalculatorScreenState();
}

class _PreheatCalculatorScreenState extends State<PreheatCalculatorScreen> {
  final _carbonController = TextEditingController(text: '0.20');
  final _manganeseController = TextEditingController(text: '0.80');
  final _chromiumController = TextEditingController(text: '0.00');
  final _molybdenumController = TextEditingController(text: '0.00');
  final _vanadiumController = TextEditingController(text: '0.00');
  final _nickelController = TextEditingController(text: '0.00');
  final _copperController = TextEditingController(text: '0.00');
  final _thicknessController = TextEditingController(text: '25');

  String _selectedHydrogen = 'Low (≤5 ml/100g)';
  String _selectedRestraint = 'Low';
  bool _useQuickSelect = true;
  String _selectedSteel = 'A36 / Mild Steel';

  final Map<String, Map<String, double>> _steelGrades = {
    'A36 / Mild Steel': {'C': 0.26, 'Mn': 0.80, 'Cr': 0.0, 'Mo': 0.0, 'V': 0.0, 'Ni': 0.0, 'Cu': 0.0},
    'A572 Gr 50': {'C': 0.23, 'Mn': 1.35, 'Cr': 0.0, 'Mo': 0.0, 'V': 0.0, 'Ni': 0.0, 'Cu': 0.0},
    'A514 / T-1': {'C': 0.21, 'Mn': 0.90, 'Cr': 0.50, 'Mo': 0.20, 'V': 0.05, 'Ni': 0.0, 'Cu': 0.0},
    'A588 Weathering': {'C': 0.19, 'Mn': 1.25, 'Cr': 0.50, 'Mo': 0.0, 'V': 0.05, 'Ni': 0.40, 'Cu': 0.35},
    '4130 Chrome-Moly': {'C': 0.30, 'Mn': 0.50, 'Cr': 0.95, 'Mo': 0.20, 'V': 0.0, 'Ni': 0.0, 'Cu': 0.0},
    '4140 Chrome-Moly': {'C': 0.40, 'Mn': 0.88, 'Cr': 0.95, 'Mo': 0.20, 'V': 0.0, 'Ni': 0.0, 'Cu': 0.0},
    '4340 Ni-Cr-Mo': {'C': 0.40, 'Mn': 0.70, 'Cr': 0.80, 'Mo': 0.25, 'V': 0.0, 'Ni': 1.83, 'Cu': 0.0},
    '8620 Low Alloy': {'C': 0.20, 'Mn': 0.80, 'Cr': 0.50, 'Mo': 0.20, 'V': 0.0, 'Ni': 0.55, 'Cu': 0.0},
    '1018 Low Carbon': {'C': 0.18, 'Mn': 0.75, 'Cr': 0.0, 'Mo': 0.0, 'V': 0.0, 'Ni': 0.0, 'Cu': 0.0},
    '1045 Medium Carbon': {'C': 0.45, 'Mn': 0.75, 'Cr': 0.0, 'Mo': 0.0, 'V': 0.0, 'Ni': 0.0, 'Cu': 0.0},
  };

  double get _carbonEquivalent {
    final c = double.tryParse(_carbonController.text) ?? 0;
    final mn = double.tryParse(_manganeseController.text) ?? 0;
    final cr = double.tryParse(_chromiumController.text) ?? 0;
    final mo = double.tryParse(_molybdenumController.text) ?? 0;
    final v = double.tryParse(_vanadiumController.text) ?? 0;
    final ni = double.tryParse(_nickelController.text) ?? 0;
    final cu = double.tryParse(_copperController.text) ?? 0;

    // IIW Carbon Equivalent formula
    // CE = C + Mn/6 + (Cr+Mo+V)/5 + (Ni+Cu)/15
    return c + (mn / 6) + ((cr + mo + v) / 5) + ((ni + cu) / 15);
  }

  int get _preheatTemperature {
    final ce = _carbonEquivalent;
    final thickness = double.tryParse(_thicknessController.text) ?? 25;

    // Base preheat calculation
    int basePreheat = 0;

    if (ce < 0.35) {
      basePreheat = 0; // No preheat typically needed
    } else if (ce < 0.40) {
      basePreheat = 50;
    } else if (ce < 0.45) {
      basePreheat = 100;
    } else if (ce < 0.50) {
      basePreheat = 150;
    } else if (ce < 0.55) {
      basePreheat = 200;
    } else if (ce < 0.60) {
      basePreheat = 250;
    } else {
      basePreheat = 300;
    }

    // Thickness adjustment (AWS D1.1 style)
    if (thickness > 50) {
      basePreheat += 50;
    } else if (thickness > 25) {
      basePreheat += 25;
    }

    // Hydrogen adjustment
    if (_selectedHydrogen == 'High (>15 ml/100g)') {
      basePreheat += 50;
    } else if (_selectedHydrogen == 'Medium (5-15 ml/100g)') {
      basePreheat += 25;
    }

    // Restraint adjustment
    if (_selectedRestraint == 'High') {
      basePreheat += 50;
    } else if (_selectedRestraint == 'Medium') {
      basePreheat += 25;
    }

    return basePreheat;
  }

  String get _weldabilityRating {
    final ce = _carbonEquivalent;
    if (ce < 0.35) return 'Excellent';
    if (ce < 0.40) return 'Good';
    if (ce < 0.45) return 'Fair';
    if (ce < 0.50) return 'Poor';
    return 'Very Poor';
  }

  Color get _weldabilityColor {
    final ce = _carbonEquivalent;
    if (ce < 0.35) return Colors.green;
    if (ce < 0.40) return Colors.lightGreen;
    if (ce < 0.45) return Colors.orange;
    if (ce < 0.50) return Colors.deepOrange;
    return Colors.red;
  }

  void _applyQuickSelect(String grade) {
    final composition = _steelGrades[grade]!;
    setState(() {
      _carbonController.text = composition['C']!.toStringAsFixed(2);
      _manganeseController.text = composition['Mn']!.toStringAsFixed(2);
      _chromiumController.text = composition['Cr']!.toStringAsFixed(2);
      _molybdenumController.text = composition['Mo']!.toStringAsFixed(2);
      _vanadiumController.text = composition['V']!.toStringAsFixed(2);
      _nickelController.text = composition['Ni']!.toStringAsFixed(2);
      _copperController.text = composition['Cu']!.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _carbonController.dispose();
    _manganeseController.dispose();
    _chromiumController.dispose();
    _molybdenumController.dispose();
    _vanadiumController.dispose();
    _nickelController.dispose();
    _copperController.dispose();
    _thicknessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preheat Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Calculate preheat temperature based on carbon equivalent (CE), material thickness, and welding conditions.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Select Toggle
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flash_on),
                      const SizedBox(width: 8),
                      const Text(
                        'Quick Select Steel Grade',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Switch(
                        value: _useQuickSelect,
                        onChanged: (v) => setState(() => _useQuickSelect = v),
                      ),
                    ],
                  ),
                  if (_useQuickSelect) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSteel,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _steelGrades.keys.map((grade) {
                        return DropdownMenuItem(value: grade, child: Text(grade));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedSteel = value);
                          _applyQuickSelect(value);
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Chemical Composition
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.science),
                      SizedBox(width: 8),
                      Text(
                        'Chemical Composition (%)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _CompositionField(
                          label: 'Carbon (C)',
                          controller: _carbonController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CompositionField(
                          label: 'Manganese (Mn)',
                          controller: _manganeseController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _CompositionField(
                          label: 'Chromium (Cr)',
                          controller: _chromiumController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CompositionField(
                          label: 'Molybdenum (Mo)',
                          controller: _molybdenumController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _CompositionField(
                          label: 'Vanadium (V)',
                          controller: _vanadiumController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CompositionField(
                          label: 'Nickel (Ni)',
                          controller: _nickelController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _CompositionField(
                          label: 'Copper (Cu)',
                          controller: _copperController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Welding Conditions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text(
                        'Welding Conditions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _thicknessController,
                    decoration: const InputDecoration(
                      labelText: 'Material Thickness (mm)',
                      border: OutlineInputBorder(),
                      helperText: 'Combined thickness of materials being joined',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedHydrogen,
                    decoration: const InputDecoration(
                      labelText: 'Hydrogen Level',
                      border: OutlineInputBorder(),
                      helperText: 'Based on electrode type and storage',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Low (≤5 ml/100g)', child: Text('Low (≤5 ml/100g) - E7018, TIG')),
                      DropdownMenuItem(value: 'Medium (5-15 ml/100g)', child: Text('Medium (5-15 ml/100g) - E7014')),
                      DropdownMenuItem(value: 'High (>15 ml/100g)', child: Text('High (>15 ml/100g) - E6010, E6011')),
                    ],
                    onChanged: (v) => setState(() => _selectedHydrogen = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRestraint,
                    decoration: const InputDecoration(
                      labelText: 'Joint Restraint',
                      border: OutlineInputBorder(),
                      helperText: 'Higher restraint increases cracking risk',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low - Free to move')),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium - Partially restrained')),
                      DropdownMenuItem(value: 'High', child: Text('High - Fully restrained')),
                    ],
                    onChanged: (v) => setState(() => _selectedRestraint = v!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results Card
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Carbon Equivalent
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Carbon Equivalent (CE):',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      Text(
                        _carbonEquivalent.toStringAsFixed(3),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Weldability
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weldability:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _weldabilityColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _weldabilityRating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  // Preheat Temperature
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.thermostat,
                        size: 32,
                        color: _preheatTemperature > 0
                            ? Colors.orange
                            : Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Preheat',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                          Text(
                            _preheatTemperature > 0
                                ? '$_preheatTemperature°C (${(_preheatTemperature * 9 / 5 + 32).round()}°F)'
                                : 'No preheat required',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _preheatTemperature > 0
                                  ? Colors.orange.shade800
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                      Icon(Icons.lightbulb, color: Colors.amber.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Preheat Tips',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _TipRow(text: 'Use temp sticks or IR thermometer to verify'),
                  _TipRow(text: 'Preheat 3" (75mm) in all directions from weld'),
                  _TipRow(text: 'Maintain interpass temp during welding'),
                  _TipRow(text: 'Consider PWHT for CE > 0.50'),
                  _TipRow(text: 'Low hydrogen electrodes reduce cracking risk'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Formula Reference
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'IIW Carbon Equivalent Formula:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'CE = C + Mn/6 + (Cr+Mo+V)/5 + (Ni+Cu)/15',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'CE < 0.35: Excellent weldability\nCE 0.35-0.40: Good, may need preheat\nCE 0.40-0.45: Fair, preheat recommended\nCE 0.45-0.50: Poor, preheat required\nCE > 0.50: Very poor, special procedures needed',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompositionField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const _CompositionField({
    required this.label,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      onChanged: onChanged,
    );
  }
}

class _TipRow extends StatelessWidget {
  final String text;

  const _TipRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}
