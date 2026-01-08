import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class ConveyorCalculator extends StatefulWidget {
  const ConveyorCalculator({super.key});

  @override
  State<ConveyorCalculator> createState() => _ConveyorCalculatorState();
}

class _ConveyorCalculatorState extends State<ConveyorCalculator> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Conveyor Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Belt Speed'),
            Tab(text: 'Capacity'),
            Tab(text: 'Power'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _BeltSpeedTab(),
          _CapacityTab(),
          _PowerTab(),
        ],
      ),
    );
  }
}

class _BeltSpeedTab extends StatefulWidget {
  const _BeltSpeedTab();

  @override
  State<_BeltSpeedTab> createState() => _BeltSpeedTabState();
}

class _BeltSpeedTabState extends State<_BeltSpeedTab> {
  final _pulleyDiameterController = TextEditingController(text: '12');
  final _rpmController = TextEditingController(text: '1750');
  final _gearRatioController = TextEditingController(text: '20');
  String _diameterUnit = 'inches';

  double get _beltSpeedFPM {
    final diameter = double.tryParse(_pulleyDiameterController.text) ?? 0;
    final rpm = double.tryParse(_rpmController.text) ?? 0;
    final gearRatio = double.tryParse(_gearRatioController.text) ?? 1;

    if (gearRatio == 0) return 0;

    // Convert diameter to inches if in mm
    final diameterInches = _diameterUnit == 'mm' ? diameter / 25.4 : diameter;

    // Belt Speed (FPM) = π × Diameter × RPM / 12
    // Adjusted for gear ratio
    final pulleyRpm = rpm / gearRatio;
    return (pi * diameterInches * pulleyRpm) / 12;
  }

  double get _beltSpeedMPM => _beltSpeedFPM * 0.3048;

  @override
  void dispose() {
    _pulleyDiameterController.dispose();
    _rpmController.dispose();
    _gearRatioController.dispose();
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
                    'Calculate belt linear speed from drive pulley diameter and motor RPM.',
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

        // Drive Pulley Diameter
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _pulleyDiameterController,
                decoration: const InputDecoration(
                  labelText: 'Drive Pulley Diameter',
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

        // Motor RPM
        TextField(
          controller: _rpmController,
          decoration: const InputDecoration(
            labelText: 'Motor RPM',
            border: OutlineInputBorder(),
            helperText: 'Common: 1750, 1450, 1150, 870',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Gear Ratio
        TextField(
          controller: _gearRatioController,
          decoration: const InputDecoration(
            labelText: 'Gear Ratio (reducer)',
            border: OutlineInputBorder(),
            helperText: 'Enter 1 for direct drive',
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
                const Text(
                  'Belt Speed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          _beltSpeedFPM.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Text('FPM'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          _beltSpeedMPM.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Text('m/min'),
                      ],
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
                  child: const Text(
                    'Belt Speed (FPM) = π × D × (RPM / Ratio) / 12',
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

class _CapacityTab extends StatefulWidget {
  const _CapacityTab();

  @override
  State<_CapacityTab> createState() => _CapacityTabState();
}

class _CapacityTabState extends State<_CapacityTab> {
  final _beltWidthController = TextEditingController(text: '24');
  final _beltSpeedController = TextEditingController(text: '300');
  final _materialDensityController = TextEditingController(text: '100');
  final _surchargeAngleController = TextEditingController(text: '20');
  String _widthUnit = 'inches';

  // Capacity in TPH (tons per hour)
  double get _capacityTPH {
    final width = double.tryParse(_beltWidthController.text) ?? 0;
    final speed = double.tryParse(_beltSpeedController.text) ?? 0;
    final density = double.tryParse(_materialDensityController.text) ?? 0;
    final surchargeAngle = double.tryParse(_surchargeAngleController.text) ?? 20;

    // Convert width to inches
    final widthInches = _widthUnit == 'mm' ? width / 25.4 : width;

    // Cross-sectional area factor based on surcharge angle
    // Approximate formula for troughed belt
    final angleRad = surchargeAngle * pi / 180;
    final areaFactor = 0.0726 * tan(angleRad);

    // Capacity = Cross-section × Speed × Density / 2000
    // Simplified formula for 20° trough angle
    final crossSection = areaFactor * widthInches * widthInches;
    return (crossSection * speed * density) / 2000;
  }

  double get _capacityMTPH => _capacityTPH * 0.9072; // metric tons

  @override
  void dispose() {
    _beltWidthController.dispose();
    _beltSpeedController.dispose();
    _materialDensityController.dispose();
    _surchargeAngleController.dispose();
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
                    'Calculate conveyor belt material handling capacity.',
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

        // Belt Width
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _beltWidthController,
                decoration: const InputDecoration(
                  labelText: 'Belt Width',
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
                initialValue: _widthUnit,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'inches', child: Text('in')),
                  DropdownMenuItem(value: 'mm', child: Text('mm')),
                ],
                onChanged: (v) => setState(() => _widthUnit = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Belt Speed
        TextField(
          controller: _beltSpeedController,
          decoration: const InputDecoration(
            labelText: 'Belt Speed (FPM)',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Material Density
        TextField(
          controller: _materialDensityController,
          decoration: const InputDecoration(
            labelText: 'Material Density (lb/ft³)',
            border: OutlineInputBorder(),
            helperText: 'Coal: 50, Sand: 100, Gravel: 110, Iron Ore: 150',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Surcharge Angle
        TextField(
          controller: _surchargeAngleController,
          decoration: const InputDecoration(
            labelText: 'Surcharge Angle (degrees)',
            border: OutlineInputBorder(),
            helperText: 'Typical: 15-25° for most materials',
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
                const Text(
                  'Belt Capacity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          _capacityTPH.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Text('TPH (US)'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          _capacityMTPH.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Text('MTPH'),
                      ],
                    ),
                  ],
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
  final _beltLengthController = TextEditingController(text: '100');
  final _liftController = TextEditingController(text: '20');
  final _capacityController = TextEditingController(text: '200');
  final _beltSpeedController = TextEditingController(text: '300');
  final _beltWeightController = TextEditingController(text: '10');
  String _lengthUnit = 'feet';

  // Horsepower calculation
  double get _horsepower {
    final length = double.tryParse(_beltLengthController.text) ?? 0;
    final lift = double.tryParse(_liftController.text) ?? 0;
    final capacity = double.tryParse(_capacityController.text) ?? 0;
    final speed = double.tryParse(_beltSpeedController.text) ?? 0;
    final beltWeight = double.tryParse(_beltWeightController.text) ?? 0;

    // Convert to feet if in meters
    final lengthFeet = _lengthUnit == 'meters' ? length * 3.281 : length;
    final liftFeet = _lengthUnit == 'meters' ? lift * 3.281 : lift;

    // HP = (Te × V) / 33000
    // Where Te = Total effective tension

    // Empty belt HP
    final emptyBeltHP = (0.03 * beltWeight * lengthFeet * speed) / 33000;

    // Material lift HP
    final liftHP = (capacity * 2000 * liftFeet) / (60 * 33000);

    // Horizontal material HP (friction)
    final frictionHP = (0.03 * capacity * 2000 * lengthFeet) / (60 * 33000);

    return emptyBeltHP + liftHP + frictionHP;
  }

  double get _kilowatts => _horsepower * 0.7457;

  @override
  void dispose() {
    _beltLengthController.dispose();
    _liftController.dispose();
    _capacityController.dispose();
    _beltSpeedController.dispose();
    _beltWeightController.dispose();
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
                    'Calculate motor power required to drive the conveyor belt.',
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

        // Belt Length
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _beltLengthController,
                decoration: const InputDecoration(
                  labelText: 'Conveyor Length',
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
                initialValue: _lengthUnit,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'feet', child: Text('ft')),
                  DropdownMenuItem(value: 'meters', child: Text('m')),
                ],
                onChanged: (v) => setState(() => _lengthUnit = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Lift Height
        TextField(
          controller: _liftController,
          decoration: InputDecoration(
            labelText: 'Lift Height (${_lengthUnit == 'meters' ? 'm' : 'ft'})',
            border: const OutlineInputBorder(),
            helperText: 'Vertical rise of conveyor',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Capacity
        TextField(
          controller: _capacityController,
          decoration: const InputDecoration(
            labelText: 'Material Capacity (TPH)',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Belt Speed
        TextField(
          controller: _beltSpeedController,
          decoration: const InputDecoration(
            labelText: 'Belt Speed (FPM)',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Belt Weight
        TextField(
          controller: _beltWeightController,
          decoration: const InputDecoration(
            labelText: 'Belt Weight (lb/ft)',
            border: OutlineInputBorder(),
            helperText: 'Includes idlers; typical: 5-20 lb/ft',
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
                const Text(
                  'Required Motor Power',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          _horsepower.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Text('HP'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          _kilowatts.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Text('kW'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, size: 18, color: Colors.amber.shade800),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Add 10-25% service factor for motor selection',
                          style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
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
