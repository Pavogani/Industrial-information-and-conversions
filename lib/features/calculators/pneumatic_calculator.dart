import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PneumaticCalculator extends StatefulWidget {
  const PneumaticCalculator({super.key});

  @override
  State<PneumaticCalculator> createState() => _PneumaticCalculatorState();
}

class _PneumaticCalculatorState extends State<PneumaticCalculator>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // CFM Calculator
  final _cylinderBoreController = TextEditingController();
  final _strokeController = TextEditingController();
  final _cyclesController = TextEditingController();
  final _pressureController = TextEditingController(text: '100');

  // Pipe Sizing
  final _cfmController = TextEditingController();
  final _pipeLengthController = TextEditingController();
  final _maxDropController = TextEditingController(text: '3');

  // Cylinder Force
  final _forceBoreController = TextEditingController();
  final _forcePressureController = TextEditingController(text: '100');
  final _rodDiameterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cylinderBoreController.dispose();
    _strokeController.dispose();
    _cyclesController.dispose();
    _pressureController.dispose();
    _cfmController.dispose();
    _pipeLengthController.dispose();
    _maxDropController.dispose();
    _forceBoreController.dispose();
    _forcePressureController.dispose();
    _rodDiameterController.dispose();
    super.dispose();
  }

  // Calculate CFM for cylinder
  double? _calculateCFM() {
    final bore = double.tryParse(_cylinderBoreController.text);
    final stroke = double.tryParse(_strokeController.text);
    final cycles = double.tryParse(_cyclesController.text);
    final pressure = double.tryParse(_pressureController.text) ?? 100;

    if (bore == null || stroke == null || cycles == null) return null;
    if (bore <= 0 || stroke <= 0 || cycles <= 0) return null;

    // Volume per stroke in cubic inches
    final area = pi * pow(bore / 2, 2);
    final volumePerStroke = area * stroke; // cubic inches

    // Total volume per minute (both extend and retract)
    final volumePerMinute = volumePerStroke * 2 * cycles;

    // Convert to CFM at atmospheric pressure
    // Compression ratio = (gauge pressure + 14.7) / 14.7
    final compressionRatio = (pressure + 14.7) / 14.7;
    final cfmAtPressure = (volumePerMinute / 1728) * compressionRatio;

    return cfmAtPressure;
  }

  // Calculate recommended pipe size
  Map<String, dynamic>? _calculatePipeSize() {
    final cfm = double.tryParse(_cfmController.text);
    final length = double.tryParse(_pipeLengthController.text);
    final maxDrop = double.tryParse(_maxDropController.text) ?? 3;

    if (cfm == null || cfm <= 0) return null;

    // Pipe sizing data: [nominal size, ID inches, max CFM at 100 PSI for 100ft with 3% drop]
    const pipeData = [
      {'size': '1/4"', 'id': 0.364, 'maxCfm': 3},
      {'size': '3/8"', 'id': 0.493, 'maxCfm': 6},
      {'size': '1/2"', 'id': 0.622, 'maxCfm': 12},
      {'size': '3/4"', 'id': 0.824, 'maxCfm': 25},
      {'size': '1"', 'id': 1.049, 'maxCfm': 50},
      {'size': '1-1/4"', 'id': 1.380, 'maxCfm': 100},
      {'size': '1-1/2"', 'id': 1.610, 'maxCfm': 150},
      {'size': '2"', 'id': 2.067, 'maxCfm': 300},
      {'size': '2-1/2"', 'id': 2.469, 'maxCfm': 500},
      {'size': '3"', 'id': 3.068, 'maxCfm': 800},
    ];

    // Adjust for length if provided
    double adjustedCfm = cfm;
    if (length != null && length > 0) {
      // Longer runs need larger pipe - rough approximation
      adjustedCfm = cfm * sqrt(length / 100);
    }

    // Adjust for different max drop
    adjustedCfm = adjustedCfm * (3 / maxDrop);

    for (var pipe in pipeData) {
      if ((pipe['maxCfm'] as int) >= adjustedCfm) {
        return {
          'pipe': pipe,
          'adjustedCfm': adjustedCfm,
        };
      }
    }

    return {
      'pipe': pipeData.last,
      'warning': 'CFM exceeds typical pipe capacity',
      'adjustedCfm': adjustedCfm,
    };
  }

  // Calculate cylinder force
  Map<String, double>? _calculateCylinderForce() {
    final bore = double.tryParse(_forceBoreController.text);
    final pressure = double.tryParse(_forcePressureController.text) ?? 100;
    final rodDia = double.tryParse(_rodDiameterController.text) ?? 0;

    if (bore == null || bore <= 0) return null;

    // Push force (full bore area)
    final boreArea = pi * pow(bore / 2, 2);
    final pushForce = boreArea * pressure;

    // Pull force (bore area minus rod area)
    final rodArea = pi * pow(rodDia / 2, 2);
    final pullArea = boreArea - rodArea;
    final pullForce = pullArea * pressure;

    return {
      'pushForce': pushForce,
      'pullForce': pullForce,
      'boreArea': boreArea,
      'pullArea': pullArea,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pneumatic Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'CFM', icon: Icon(Icons.air)),
            Tab(text: 'Pipe Size', icon: Icon(Icons.plumbing)),
            Tab(text: 'Force', icon: Icon(Icons.fitness_center)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCfmTab(),
          _buildPipeSizeTab(),
          _buildForceTab(),
        ],
      ),
    );
  }

  Widget _buildCfmTab() {
    final cfm = _calculateCFM();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cylinder Air Consumption',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _cylinderBoreController,
                    label: 'Cylinder Bore',
                    suffix: 'inches',
                    icon: Icons.circle_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _strokeController,
                    label: 'Stroke Length',
                    suffix: 'inches',
                    icon: Icons.straighten,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _cyclesController,
                    label: 'Cycles per Minute',
                    suffix: 'CPM',
                    icon: Icons.repeat,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _pressureController,
                    label: 'Operating Pressure',
                    suffix: 'PSI',
                    icon: Icons.speed,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (cfm != null)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Air Consumption'),
                    const SizedBox(height: 8),
                    Text(
                      '${cfm.toStringAsFixed(2)} CFM',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(cfm * 60).toStringAsFixed(1)} CFH',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Formula',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('CFM = (π × (Bore/2)² × Stroke × 2 × CPM × CR) / 1728'),
                  const SizedBox(height: 4),
                  const Text('CR = Compression Ratio = (PSI + 14.7) / 14.7'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipeSizeTab() {
    final result = _calculatePipeSize();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pipe Sizing',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _cfmController,
                    label: 'Required CFM',
                    suffix: 'CFM',
                    icon: Icons.air,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _pipeLengthController,
                    label: 'Pipe Run Length',
                    suffix: 'feet',
                    icon: Icons.straighten,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _maxDropController,
                    label: 'Max Pressure Drop',
                    suffix: 'PSI',
                    icon: Icons.trending_down,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (result != null)
            Card(
              color: result.containsKey('warning')
                  ? Theme.of(context).colorScheme.errorContainer
                  : Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Recommended Pipe Size'),
                    const SizedBox(height: 8),
                    Text(
                      result['pipe']['size'],
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text('ID: ${result['pipe']['id']}" | Max CFM: ${result['pipe']['maxCfm']}'),
                    if (result.containsKey('warning')) ...[
                      const SizedBox(height: 8),
                      Text(
                        result['warning'],
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Pipe reference table
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Pipe Capacity Reference'),
              subtitle: const Text('Max CFM at 100 PSI, 100ft, 3 PSI drop'),
              children: [
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Size')),
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Max CFM')),
                  ],
                  rows: const [
                    DataRow(cells: [DataCell(Text('1/4"')), DataCell(Text('0.364"')), DataCell(Text('3'))]),
                    DataRow(cells: [DataCell(Text('3/8"')), DataCell(Text('0.493"')), DataCell(Text('6'))]),
                    DataRow(cells: [DataCell(Text('1/2"')), DataCell(Text('0.622"')), DataCell(Text('12'))]),
                    DataRow(cells: [DataCell(Text('3/4"')), DataCell(Text('0.824"')), DataCell(Text('25'))]),
                    DataRow(cells: [DataCell(Text('1"')), DataCell(Text('1.049"')), DataCell(Text('50'))]),
                    DataRow(cells: [DataCell(Text('1-1/4"')), DataCell(Text('1.380"')), DataCell(Text('100'))]),
                    DataRow(cells: [DataCell(Text('1-1/2"')), DataCell(Text('1.610"')), DataCell(Text('150'))]),
                    DataRow(cells: [DataCell(Text('2"')), DataCell(Text('2.067"')), DataCell(Text('300'))]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForceTab() {
    final result = _calculateCylinderForce();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cylinder Force',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _forceBoreController,
                    label: 'Cylinder Bore',
                    suffix: 'inches',
                    icon: Icons.circle_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _rodDiameterController,
                    label: 'Rod Diameter (optional)',
                    suffix: 'inches',
                    icon: Icons.remove,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _forcePressureController,
                    label: 'Operating Pressure',
                    suffix: 'PSI',
                    icon: Icons.speed,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (result != null)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Push Force'),
                              const Icon(Icons.arrow_forward, size: 32),
                              Text(
                                '${result['pushForce']!.toStringAsFixed(0)} lbs',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text('(${(result['pushForce']! * 4.448).toStringAsFixed(0)} N)'),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 80,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Pull Force'),
                              const Icon(Icons.arrow_back, size: 32),
                              Text(
                                '${result['pullForce']!.toStringAsFixed(0)} lbs',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text('(${(result['pullForce']! * 4.448).toStringAsFixed(0)} N)'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('Bore Area'),
                            Text('${result['boreArea']!.toStringAsFixed(3)} in²'),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Annular Area'),
                            Text('${result['pullArea']!.toStringAsFixed(3)} in²'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Formulas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildFormulaRow('Push Force', 'F = π × (Bore/2)² × PSI'),
                  _buildFormulaRow('Pull Force', 'F = π × ((Bore/2)² - (Rod/2)²) × PSI'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          // Common cylinder sizes
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Common Cylinder Forces'),
              subtitle: const Text('At 100 PSI'),
              children: [
                DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Bore')),
                    DataColumn(label: Text('Push (lbs)')),
                    DataColumn(label: Text('Area (in²)')),
                  ],
                  rows: const [
                    DataRow(cells: [DataCell(Text('3/4"')), DataCell(Text('44')), DataCell(Text('0.44'))]),
                    DataRow(cells: [DataCell(Text('1"')), DataCell(Text('79')), DataCell(Text('0.79'))]),
                    DataRow(cells: [DataCell(Text('1-1/2"')), DataCell(Text('177')), DataCell(Text('1.77'))]),
                    DataRow(cells: [DataCell(Text('2"')), DataCell(Text('314')), DataCell(Text('3.14'))]),
                    DataRow(cells: [DataCell(Text('2-1/2"')), DataCell(Text('491')), DataCell(Text('4.91'))]),
                    DataRow(cells: [DataCell(Text('3"')), DataCell(Text('707')), DataCell(Text('7.07'))]),
                    DataRow(cells: [DataCell(Text('4"')), DataCell(Text('1,257')), DataCell(Text('12.57'))]),
                    DataRow(cells: [DataCell(Text('5"')), DataCell(Text('1,963')), DataCell(Text('19.63'))]),
                    DataRow(cells: [DataCell(Text('6"')), DataCell(Text('2,827')), DataCell(Text('28.27'))]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildFormulaRow(String name, String formula) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(formula, style: const TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }
}
