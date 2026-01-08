import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WireSizingCalculator extends StatefulWidget {
  const WireSizingCalculator({super.key});

  @override
  State<WireSizingCalculator> createState() => _WireSizingCalculatorState();
}

class _WireSizingCalculatorState extends State<WireSizingCalculator> {
  final _ampsController = TextEditingController();
  final _distanceController = TextEditingController();
  final _voltageController = TextEditingController(text: '120');

  String _wireType = 'copper';
  double _maxVoltageDrop = 3.0;

  // AWG wire data: [AWG, diameter mm, area mm², copper amps, aluminum amps, resistance Ω/1000ft copper]
  static const List<Map<String, dynamic>> wireData = [
    {'awg': '14', 'diameter': 1.63, 'area': 2.08, 'copperAmps': 15, 'aluminumAmps': 0, 'resistance': 2.525},
    {'awg': '12', 'diameter': 2.05, 'area': 3.31, 'copperAmps': 20, 'aluminumAmps': 15, 'resistance': 1.588},
    {'awg': '10', 'diameter': 2.59, 'area': 5.26, 'copperAmps': 30, 'aluminumAmps': 25, 'resistance': 0.999},
    {'awg': '8', 'diameter': 3.26, 'area': 8.37, 'copperAmps': 40, 'aluminumAmps': 30, 'resistance': 0.628},
    {'awg': '6', 'diameter': 4.11, 'area': 13.3, 'copperAmps': 55, 'aluminumAmps': 40, 'resistance': 0.395},
    {'awg': '4', 'diameter': 5.19, 'area': 21.1, 'copperAmps': 70, 'aluminumAmps': 55, 'resistance': 0.249},
    {'awg': '3', 'diameter': 5.83, 'area': 26.7, 'copperAmps': 85, 'aluminumAmps': 65, 'resistance': 0.197},
    {'awg': '2', 'diameter': 6.54, 'area': 33.6, 'copperAmps': 95, 'aluminumAmps': 75, 'resistance': 0.156},
    {'awg': '1', 'diameter': 7.35, 'area': 42.4, 'copperAmps': 110, 'aluminumAmps': 85, 'resistance': 0.124},
    {'awg': '1/0', 'diameter': 8.25, 'area': 53.5, 'copperAmps': 125, 'aluminumAmps': 100, 'resistance': 0.098},
    {'awg': '2/0', 'diameter': 9.27, 'area': 67.4, 'copperAmps': 145, 'aluminumAmps': 115, 'resistance': 0.078},
    {'awg': '3/0', 'diameter': 10.40, 'area': 85.0, 'copperAmps': 165, 'aluminumAmps': 130, 'resistance': 0.062},
    {'awg': '4/0', 'diameter': 11.68, 'area': 107.2, 'copperAmps': 195, 'aluminumAmps': 150, 'resistance': 0.049},
    {'awg': '250', 'diameter': 12.70, 'area': 126.7, 'copperAmps': 215, 'aluminumAmps': 170, 'resistance': 0.041},
    {'awg': '300', 'diameter': 13.91, 'area': 152.0, 'copperAmps': 240, 'aluminumAmps': 190, 'resistance': 0.034},
    {'awg': '350', 'diameter': 15.01, 'area': 177.3, 'copperAmps': 260, 'aluminumAmps': 210, 'resistance': 0.029},
    {'awg': '500', 'diameter': 17.96, 'area': 253.4, 'copperAmps': 320, 'aluminumAmps': 260, 'resistance': 0.021},
  ];

  Map<String, dynamic>? _calculateWireSize() {
    final amps = double.tryParse(_ampsController.text);
    final distance = double.tryParse(_distanceController.text);
    final voltage = double.tryParse(_voltageController.text);

    if (amps == null || amps <= 0) return null;

    // Find minimum wire size for ampacity
    String ampacityKey = _wireType == 'copper' ? 'copperAmps' : 'aluminumAmps';
    Map<String, dynamic>? selectedWire;

    for (var wire in wireData) {
      if (wire[ampacityKey] >= amps) {
        selectedWire = wire;
        break;
      }
    }

    if (selectedWire == null) {
      return {'error': 'Load exceeds maximum wire capacity'};
    }

    // Check voltage drop if distance provided
    if (distance != null && distance > 0 && voltage != null && voltage > 0) {
      // Aluminum has about 1.6x the resistance of copper
      double resistanceFactor = _wireType == 'copper' ? 1.0 : 1.6;

      // Check if selected wire meets voltage drop requirements
      while (selectedWire != null) {
        double resistance = selectedWire['resistance'] * resistanceFactor;
        // Voltage drop = 2 × I × R × L / 1000 (round trip)
        double voltageDrop = 2 * amps * resistance * distance / 1000;
        double voltageDropPercent = (voltageDrop / voltage) * 100;

        if (voltageDropPercent <= _maxVoltageDrop) {
          return {
            'wire': selectedWire,
            'voltageDrop': voltageDrop,
            'voltageDropPercent': voltageDropPercent,
          };
        }

        // Try next larger wire
        int currentIndex = wireData.indexOf(selectedWire);
        if (currentIndex < wireData.length - 1) {
          selectedWire = wireData[currentIndex + 1];
        } else {
          return {
            'wire': selectedWire,
            'voltageDrop': voltageDrop,
            'voltageDropPercent': voltageDropPercent,
            'warning': 'Voltage drop exceeds $_maxVoltageDrop% even with largest wire',
          };
        }
      }
    }

    return {'wire': selectedWire};
  }

  @override
  void dispose() {
    _ampsController.dispose();
    _distanceController.dispose();
    _voltageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateWireSize();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wire Sizing Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                    const Text(
                      'Load Information',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // Amps
                    TextField(
                      controller: _ampsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                      decoration: const InputDecoration(
                        labelText: 'Load Current',
                        suffixText: 'Amps',
                        prefixIcon: Icon(Icons.electric_bolt),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),

                    // Distance
                    TextField(
                      controller: _distanceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                      decoration: const InputDecoration(
                        labelText: 'One-Way Distance',
                        suffixText: 'feet',
                        prefixIcon: Icon(Icons.straighten),
                        border: OutlineInputBorder(),
                        helperText: 'Distance from panel to load',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),

                    // Voltage
                    TextField(
                      controller: _voltageController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                      decoration: const InputDecoration(
                        labelText: 'System Voltage',
                        suffixText: 'Volts',
                        prefixIcon: Icon(Icons.flash_on),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Wire Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wire Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'copper',
                          label: Text('Copper'),
                          icon: Icon(Icons.circle, color: Colors.orange),
                        ),
                        ButtonSegment(
                          value: 'aluminum',
                          label: Text('Aluminum'),
                          icon: Icon(Icons.circle, color: Colors.grey),
                        ),
                      ],
                      selected: {_wireType},
                      onSelectionChanged: (selection) {
                        setState(() => _wireType = selection.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Max Voltage Drop',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _maxVoltageDrop,
                      min: 1,
                      max: 5,
                      divisions: 8,
                      label: '${_maxVoltageDrop.toStringAsFixed(1)}%',
                      onChanged: (value) => setState(() => _maxVoltageDrop = value),
                    ),
                    Text(
                      'Maximum ${_maxVoltageDrop.toStringAsFixed(1)}% voltage drop',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Result
            if (result != null)
              _buildResultCard(result),

            const SizedBox(height: 16),

            // Reference Table
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('AWG Wire Reference'),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('AWG')),
                        DataColumn(label: Text('Cu Amps')),
                        DataColumn(label: Text('Al Amps')),
                        DataColumn(label: Text('Ω/1000ft')),
                      ],
                      rows: wireData.map((wire) {
                        return DataRow(cells: [
                          DataCell(Text(wire['awg'])),
                          DataCell(Text('${wire['copperAmps']}')),
                          DataCell(Text(wire['aluminumAmps'] > 0 ? '${wire['aluminumAmps']}' : '—')),
                          DataCell(Text('${wire['resistance']}')),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tips
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.tertiary),
                        const SizedBox(width: 8),
                        Text(
                          'Wire Sizing Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('• NEC recommends 3% max drop for branch circuits'),
                    const Text('• Use 5% total max from service to final outlet'),
                    const Text('• Derate ampacity for high temperatures'),
                    const Text('• Conduit fill affects ampacity'),
                    const Text('• Always verify with local codes'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    if (result.containsKey('error')) {
      return Card(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 12),
              Expanded(child: Text(result['error'])),
            ],
          ),
        ),
      );
    }

    final wire = result['wire'] as Map<String, dynamic>;
    final hasVoltageDrop = result.containsKey('voltageDrop');
    final hasWarning = result.containsKey('warning');

    return Card(
      color: hasWarning
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Recommended Wire Size',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${wire['awg']} AWG ${_wireType == 'copper' ? 'Copper' : 'Aluminum'}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSpecItem('Ampacity', '${_wireType == 'copper' ? wire['copperAmps'] : wire['aluminumAmps']} A'),
                _buildSpecItem('Diameter', '${wire['diameter']} mm'),
              ],
            ),
            if (hasVoltageDrop) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSpecItem('Voltage Drop', '${(result['voltageDrop'] as double).toStringAsFixed(2)} V'),
                  _buildSpecItem('Drop %', '${(result['voltageDropPercent'] as double).toStringAsFixed(1)}%'),
                ],
              ),
            ],
            if (hasWarning) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Theme.of(context).colorScheme.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        result['warning'],
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
