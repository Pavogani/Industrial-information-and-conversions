import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class ElectricalCalculator extends StatefulWidget {
  const ElectricalCalculator({super.key});

  @override
  State<ElectricalCalculator> createState() => _ElectricalCalculatorState();
}

class _ElectricalCalculatorState extends State<ElectricalCalculator>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Ohm's Law
  final _voltageController = TextEditingController();
  final _currentController = TextEditingController();
  final _resistanceController = TextEditingController();
  final _powerController = TextEditingController();

  // Motor Calculations
  final _hpController = TextEditingController();
  final _efficiencyController = TextEditingController(text: '85');
  final _pfController = TextEditingController(text: '0.85');
  String _motorVoltage = '480';
  String _motorPhase = '3';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _voltageController.dispose();
    _currentController.dispose();
    _resistanceController.dispose();
    _powerController.dispose();
    _hpController.dispose();
    _efficiencyController.dispose();
    _pfController.dispose();
    super.dispose();
  }

  void _calculateOhmsLaw(String changedField) {
    final voltage = double.tryParse(_voltageController.text);
    final current = double.tryParse(_currentController.text);
    final resistance = double.tryParse(_resistanceController.text);

    setState(() {
      // Calculate based on what's available
      if (changedField != 'voltage' && current != null && resistance != null) {
        _voltageController.text = (current * resistance).toStringAsFixed(2);
      } else if (changedField != 'current' && voltage != null && resistance != null && resistance > 0) {
        _currentController.text = (voltage / resistance).toStringAsFixed(3);
      } else if (changedField != 'resistance' && voltage != null && current != null && current > 0) {
        _resistanceController.text = (voltage / current).toStringAsFixed(2);
      }

      // Calculate power
      final v = double.tryParse(_voltageController.text);
      final i = double.tryParse(_currentController.text);
      if (v != null && i != null) {
        _powerController.text = (v * i).toStringAsFixed(2);
      }
    });
  }

  Map<String, double> _calculateMotorAmps() {
    final hp = double.tryParse(_hpController.text);
    final efficiency = (double.tryParse(_efficiencyController.text) ?? 85) / 100;
    final pf = double.tryParse(_pfController.text) ?? 0.85;
    final voltage = double.tryParse(_motorVoltage) ?? 480;
    final phase = int.tryParse(_motorPhase) ?? 3;

    if (hp == null || hp <= 0) return {};

    final watts = hp * 746; // HP to Watts
    double amps;

    if (phase == 1) {
      amps = watts / (voltage * efficiency * pf);
    } else {
      amps = watts / (sqrt(3) * voltage * efficiency * pf);
    }

    // Calculate related values
    final kva = (phase == 1)
        ? (voltage * amps) / 1000
        : (sqrt(3) * voltage * amps) / 1000;
    final kw = kva * pf;

    return {
      'amps': amps,
      'kva': kva,
      'kw': kw,
      'watts': watts / efficiency,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrical Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Ohm's Law", icon: Icon(Icons.electrical_services)),
            Tab(text: 'Motor Amps', icon: Icon(Icons.electric_bolt)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOhmsLawTab(),
          _buildMotorAmpsTab(),
        ],
      ),
    );
  }

  Widget _buildOhmsLawTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Diagram
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: OhmsLawDiagramPainter(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter any two values to calculate the others',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Inputs
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInputField(
                    controller: _voltageController,
                    label: 'Voltage (V)',
                    suffix: 'Volts',
                    icon: Icons.flash_on,
                    onChanged: (_) => _calculateOhmsLaw('voltage'),
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _currentController,
                    label: 'Current (I)',
                    suffix: 'Amps',
                    icon: Icons.power,
                    onChanged: (_) => _calculateOhmsLaw('current'),
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _resistanceController,
                    label: 'Resistance (R)',
                    suffix: 'Ohms (Ω)',
                    icon: Icons.radio_button_unchecked,
                    onChanged: (_) => _calculateOhmsLaw('resistance'),
                  ),
                  const Divider(height: 24),
                  _buildInputField(
                    controller: _powerController,
                    label: 'Power (P)',
                    suffix: 'Watts',
                    icon: Icons.bolt,
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Formulas Reference
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formulas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildFormulaRow("Ohm's Law", 'V = I × R'),
                  _buildFormulaRow('Power', 'P = V × I'),
                  _buildFormulaRow('Power (alt)', 'P = I² × R'),
                  _buildFormulaRow('Power (alt)', 'P = V² / R'),
                  _buildFormulaRow('Current', 'I = V / R'),
                  _buildFormulaRow('Resistance', 'R = V / I'),
                ],
              ),
            ),
          ),

          // Clear button
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              _voltageController.clear();
              _currentController.clear();
              _resistanceController.clear();
              _powerController.clear();
              setState(() {});
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorAmpsTab() {
    final results = _calculateMotorAmps();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Motor Input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Motor Specifications',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _hpController,
                    label: 'Horsepower (HP)',
                    suffix: 'HP',
                    icon: Icons.settings,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),

                  // Voltage dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _motorVoltage,
                    decoration: const InputDecoration(
                      labelText: 'Voltage',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flash_on),
                    ),
                    items: const [
                      DropdownMenuItem(value: '120', child: Text('120V')),
                      DropdownMenuItem(value: '208', child: Text('208V')),
                      DropdownMenuItem(value: '240', child: Text('240V')),
                      DropdownMenuItem(value: '277', child: Text('277V')),
                      DropdownMenuItem(value: '460', child: Text('460V')),
                      DropdownMenuItem(value: '480', child: Text('480V')),
                      DropdownMenuItem(value: '600', child: Text('600V')),
                    ],
                    onChanged: (value) {
                      setState(() => _motorVoltage = value ?? '480');
                    },
                  ),
                  const SizedBox(height: 12),

                  // Phase selection
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: '1', label: Text('Single Phase')),
                      ButtonSegment(value: '3', label: Text('Three Phase')),
                    ],
                    selected: {_motorPhase},
                    onSelectionChanged: (selection) {
                      setState(() => _motorPhase = selection.first);
                    },
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _efficiencyController,
                          label: 'Efficiency',
                          suffix: '%',
                          icon: Icons.speed,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          controller: _pfController,
                          label: 'Power Factor',
                          suffix: '',
                          icon: Icons.analytics,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results
          if (results.isNotEmpty)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Calculated Values',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildResultRow('Full Load Amps (FLA)', '${results['amps']!.toStringAsFixed(1)} A'),
                    _buildResultRow('Apparent Power', '${results['kva']!.toStringAsFixed(2)} kVA'),
                    _buildResultRow('Real Power', '${results['kw']!.toStringAsFixed(2)} kW'),
                    _buildResultRow('Input Watts', '${results['watts']!.toStringAsFixed(0)} W'),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Common Motor FLA Table
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Common Motor FLA Reference'),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('HP')),
                      DataColumn(label: Text('115V 1Φ')),
                      DataColumn(label: Text('230V 1Φ')),
                      DataColumn(label: Text('230V 3Φ')),
                      DataColumn(label: Text('460V 3Φ')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('1/2')),
                        DataCell(Text('9.8')),
                        DataCell(Text('4.9')),
                        DataCell(Text('2.0')),
                        DataCell(Text('1.0')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('16')),
                        DataCell(Text('8')),
                        DataCell(Text('3.6')),
                        DataCell(Text('1.8')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('2')),
                        DataCell(Text('24')),
                        DataCell(Text('12')),
                        DataCell(Text('6.8')),
                        DataCell(Text('3.4')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('5')),
                        DataCell(Text('56')),
                        DataCell(Text('28')),
                        DataCell(Text('15.2')),
                        DataCell(Text('7.6')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('10')),
                        DataCell(Text('—')),
                        DataCell(Text('50')),
                        DataCell(Text('28')),
                        DataCell(Text('14')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('25')),
                        DataCell(Text('—')),
                        DataCell(Text('—')),
                        DataCell(Text('68')),
                        DataCell(Text('34')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('50')),
                        DataCell(Text('—')),
                        DataCell(Text('—')),
                        DataCell(Text('130')),
                        DataCell(Text('65')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('100')),
                        DataCell(Text('—')),
                        DataCell(Text('—')),
                        DataCell(Text('248')),
                        DataCell(Text('124')),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
    Function(String)? onChanged,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: readOnly,
        fillColor: readOnly ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildFormulaRow(String name, String formula) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              formula,
              style: TextStyle(
                fontFamily: 'monospace',
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class OhmsLawDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw outer circle
    final outerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, outerPaint);

    // Draw horizontal line
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      outerPaint,
    );

    // Draw vertical line (top half only)
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy),
      outerPaint,
    );

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // V at top
    textPainter.text = const TextSpan(
      text: 'V',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - 10, center.dy - radius + 15));

    // I at bottom left
    textPainter.text = const TextSpan(
      text: 'I',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - radius / 2 - 8, center.dy + 20));

    // R at bottom right
    textPainter.text = const TextSpan(
      text: 'R',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + radius / 2 - 8, center.dy + 20));

    // × between I and R
    textPainter.text = const TextSpan(
      text: '×',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - 8, center.dy + 25));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
