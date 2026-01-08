import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PumpFlowCalculator extends StatefulWidget {
  const PumpFlowCalculator({super.key});

  @override
  State<PumpFlowCalculator> createState() => _PumpFlowCalculatorState();
}

class _PumpFlowCalculatorState extends State<PumpFlowCalculator> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pump Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Flow Rate'),
            Tab(text: 'Head/Pressure'),
            Tab(text: 'Power'),
            Tab(text: 'NPSH'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _FlowRateTab(),
          _HeadPressureTab(),
          _PowerTab(),
          _NPSHTab(),
        ],
      ),
    );
  }
}

class _FlowRateTab extends StatefulWidget {
  const _FlowRateTab();

  @override
  State<_FlowRateTab> createState() => _FlowRateTabState();
}

class _FlowRateTabState extends State<_FlowRateTab> {
  final _pipeDiameterController = TextEditingController(text: '4');
  final _velocityController = TextEditingController(text: '8');
  String _diameterUnit = 'inches';
  String _velocityUnit = 'fps';

  double get _flowGPM {
    final diameter = double.tryParse(_pipeDiameterController.text) ?? 0;
    final velocity = double.tryParse(_velocityController.text) ?? 0;

    // Convert diameter to inches
    final diameterInches = _diameterUnit == 'mm' ? diameter / 25.4 : diameter;

    // Convert velocity to fps
    final velocityFps = _velocityUnit == 'mps' ? velocity * 3.281 : velocity;

    // Q = A × V
    // A = π × (D/2)² in sq inches
    // Q (GPM) = A × V × 60 / 231
    final area = pi * pow(diameterInches / 2, 2);
    return (area * velocityFps * 60) / 231;
  }

  double get _flowLPM => _flowGPM * 3.785;
  double get _flowM3H => _flowLPM * 0.06;

  @override
  void dispose() {
    _pipeDiameterController.dispose();
    _velocityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Calculate volumetric flow rate from pipe diameter and fluid velocity.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Pipe Diameter
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _pipeDiameterController,
                decoration: const InputDecoration(
                  labelText: 'Pipe ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _diameterUnit,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'inches', child: Text('in')),
                  DropdownMenuItem(value: 'mm', child: Text('mm')),
                ],
                onChanged: (v) => setState(() => _diameterUnit = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Velocity
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _velocityController,
                decoration: const InputDecoration(
                  labelText: 'Flow Velocity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _velocityUnit,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'fps', child: Text('ft/s')),
                  DropdownMenuItem(value: 'mps', child: Text('m/s')),
                ],
                onChanged: (v) => setState(() => _velocityUnit = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Results
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Flow Rate', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ResultColumn(value: _flowGPM.toStringAsFixed(1), unit: 'GPM'),
                    _ResultColumn(value: _flowLPM.toStringAsFixed(1), unit: 'LPM'),
                    _ResultColumn(value: _flowM3H.toStringAsFixed(2), unit: 'm³/h'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Velocity Guidelines
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recommended Velocities:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _GuidelineRow(label: 'Suction lines', value: '4-6 ft/s'),
                _GuidelineRow(label: 'Discharge lines', value: '8-12 ft/s'),
                _GuidelineRow(label: 'Slurry/solids', value: '5-8 ft/s'),
                _GuidelineRow(label: 'High pressure', value: '15-20 ft/s'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeadPressureTab extends StatefulWidget {
  const _HeadPressureTab();

  @override
  State<_HeadPressureTab> createState() => _HeadPressureTabState();
}

class _HeadPressureTabState extends State<_HeadPressureTab> {
  final _pressureController = TextEditingController(text: '50');
  final _specificGravityController = TextEditingController(text: '1.0');
  bool _pressureToHead = true;

  double get _result {
    final pressure = double.tryParse(_pressureController.text) ?? 0;
    final sg = double.tryParse(_specificGravityController.text) ?? 1;

    if (_pressureToHead) {
      // Head (ft) = Pressure (PSI) × 2.31 / SG
      return (pressure * 2.31) / sg;
    } else {
      // Pressure (PSI) = Head (ft) × SG / 2.31
      return (pressure * sg) / 2.31;
    }
  }

  @override
  void dispose() {
    _pressureController.dispose();
    _specificGravityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Conversion Direction
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _pressureToHead = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _pressureToHead
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'PSI → Head',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _pressureToHead ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _pressureToHead = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_pressureToHead
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Head → PSI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: !_pressureToHead ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Input
        TextField(
          controller: _pressureController,
          decoration: InputDecoration(
            labelText: _pressureToHead ? 'Pressure (PSI)' : 'Head (feet)',
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Specific Gravity
        TextField(
          controller: _specificGravityController,
          decoration: const InputDecoration(
            labelText: 'Specific Gravity',
            border: OutlineInputBorder(),
            helperText: 'Water = 1.0, Oil ≈ 0.85, Brine ≈ 1.2',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),

        // Result
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _pressureToHead ? 'Head' : 'Pressure',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_result.toStringAsFixed(2)} ${_pressureToHead ? 'feet' : 'PSI'}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (_pressureToHead)
                  Text(
                    '(${(_result * 0.3048).toStringAsFixed(2)} meters)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Formula
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Formulas:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Head (ft) = PSI × 2.31 / SG\nPSI = Head (ft) × SG / 2.31',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PowerTab extends StatefulWidget {
  const _PowerTab();

  @override
  State<_PowerTab> createState() => _PowerTabState();
}

class _PowerTabState extends State<_PowerTab> {
  final _flowController = TextEditingController(text: '100');
  final _headController = TextEditingController(text: '100');
  final _sgController = TextEditingController(text: '1.0');
  final _efficiencyController = TextEditingController(text: '70');

  double get _waterHP {
    final flow = double.tryParse(_flowController.text) ?? 0;
    final head = double.tryParse(_headController.text) ?? 0;
    final sg = double.tryParse(_sgController.text) ?? 1;

    // Water HP = (GPM × Head × SG) / 3960
    return (flow * head * sg) / 3960;
  }

  double get _brakeHP {
    final efficiency = double.tryParse(_efficiencyController.text) ?? 70;
    if (efficiency == 0) return 0;
    return _waterHP / (efficiency / 100);
  }

  double get _kilowatts => _brakeHP * 0.7457;

  @override
  void dispose() {
    _flowController.dispose();
    _headController.dispose();
    _sgController.dispose();
    _efficiencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Calculate pump power requirements from flow and head.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Flow Rate
        TextField(
          controller: _flowController,
          decoration: const InputDecoration(
            labelText: 'Flow Rate (GPM)',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Head
        TextField(
          controller: _headController,
          decoration: const InputDecoration(
            labelText: 'Total Head (feet)',
            border: OutlineInputBorder(),
            helperText: 'Total dynamic head (TDH)',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Specific Gravity
        TextField(
          controller: _sgController,
          decoration: const InputDecoration(
            labelText: 'Specific Gravity',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Efficiency
        TextField(
          controller: _efficiencyController,
          decoration: const InputDecoration(
            labelText: 'Pump Efficiency (%)',
            border: OutlineInputBorder(),
            helperText: 'Typical: 60-85%',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),

        // Results
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Water HP', style: TextStyle(fontSize: 12)),
                        Text(
                          _waterHP.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Brake HP', style: TextStyle(fontSize: 12)),
                        Text(
                          _brakeHP.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('kW', style: TextStyle(fontSize: 12)),
                        Text(
                          _kilowatts.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
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

        // Formula
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Formulas:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Water HP = (GPM × Head × SG) / 3960\nBrake HP = Water HP / Efficiency',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NPSHTab extends StatefulWidget {
  const _NPSHTab();

  @override
  State<_NPSHTab> createState() => _NPSHTabState();
}

class _NPSHTabState extends State<_NPSHTab> {
  final _atmosphericController = TextEditingController(text: '14.7');
  final _staticHeadController = TextEditingController(text: '10');
  final _frictionLossController = TextEditingController(text: '2');
  final _vaporPressureController = TextEditingController(text: '0.5');
  final _sgController = TextEditingController(text: '1.0');
  bool _isSuctionLift = false;

  double get _npsha {
    final atm = double.tryParse(_atmosphericController.text) ?? 14.7;
    final staticHead = double.tryParse(_staticHeadController.text) ?? 0;
    final friction = double.tryParse(_frictionLossController.text) ?? 0;
    final vapor = double.tryParse(_vaporPressureController.text) ?? 0;
    final sg = double.tryParse(_sgController.text) ?? 1;

    // Convert pressures to head
    final atmHead = (atm * 2.31) / sg;
    final vaporHead = (vapor * 2.31) / sg;

    // NPSHA = Atmospheric head ± Static head - Friction loss - Vapor pressure head
    if (_isSuctionLift) {
      return atmHead - staticHead - friction - vaporHead;
    } else {
      return atmHead + staticHead - friction - vaporHead;
    }
  }

  @override
  void dispose() {
    _atmosphericController.dispose();
    _staticHeadController.dispose();
    _frictionLossController.dispose();
    _vaporPressureController.dispose();
    _sgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Calculate Net Positive Suction Head Available (NPSHa) to prevent cavitation.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Suction Type Toggle
        Card(
          child: SwitchListTile(
            title: const Text('Suction Lift'),
            subtitle: Text(_isSuctionLift
                ? 'Liquid level below pump centerline'
                : 'Liquid level above pump centerline (flooded)'),
            value: _isSuctionLift,
            onChanged: (v) => setState(() => _isSuctionLift = v),
          ),
        ),
        const SizedBox(height: 16),

        // Atmospheric Pressure
        TextField(
          controller: _atmosphericController,
          decoration: const InputDecoration(
            labelText: 'Atmospheric Pressure (PSIA)',
            border: OutlineInputBorder(),
            helperText: 'Sea level = 14.7, 5000ft = 12.2',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Static Head
        TextField(
          controller: _staticHeadController,
          decoration: InputDecoration(
            labelText: _isSuctionLift
                ? 'Suction Lift (feet)'
                : 'Static Suction Head (feet)',
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Friction Loss
        TextField(
          controller: _frictionLossController,
          decoration: const InputDecoration(
            labelText: 'Suction Line Friction Loss (feet)',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Vapor Pressure
        TextField(
          controller: _vaporPressureController,
          decoration: const InputDecoration(
            labelText: 'Vapor Pressure (PSIA)',
            border: OutlineInputBorder(),
            helperText: 'Water at 68°F = 0.34, at 180°F = 7.5',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Specific Gravity
        TextField(
          controller: _sgController,
          decoration: const InputDecoration(
            labelText: 'Specific Gravity',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),

        // Result
        Card(
          color: _npsha > 0
              ? Theme.of(context).colorScheme.secondaryContainer
              : Colors.red.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('NPSHa', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  '${_npsha.toStringAsFixed(2)} feet',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _npsha > 0 ? Theme.of(context).colorScheme.primary : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _npsha > 0
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _npsha > 0 ? Icons.check_circle : Icons.warning,
                        size: 18,
                        color: _npsha > 0 ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _npsha > 0
                            ? 'NPSHa should exceed NPSHr by 2-3 ft minimum'
                            : 'Warning: Negative NPSHa - cavitation risk!',
                        style: TextStyle(
                          fontSize: 12,
                          color: _npsha > 0 ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Formula
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Formula:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _isSuctionLift
                        ? 'NPSHa = Ha - Hs - Hf - Hvp'
                        : 'NPSHa = Ha + Hs - Hf - Hvp',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ha = Atmospheric head\nHs = Static head\nHf = Friction losses\nHvp = Vapor pressure head',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultColumn extends StatelessWidget {
  final String value;
  final String unit;

  const _ResultColumn({required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(unit, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _GuidelineRow extends StatelessWidget {
  final String label;
  final String value;

  const _GuidelineRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
