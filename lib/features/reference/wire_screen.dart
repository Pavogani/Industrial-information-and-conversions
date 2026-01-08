import 'package:flutter/material.dart';
import '../../core/models/wire_data.dart';

class WireScreen extends StatefulWidget {
  const WireScreen({super.key});

  @override
  State<WireScreen> createState() => _WireScreenState();
}

class _WireScreenState extends State<WireScreen>
    with SingleTickerProviderStateMixin {
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
        title: const Text('Wire & Cable Reference'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'AWG / Ampacity'),
            Tab(text: 'Insulation'),
            Tab(text: 'Volt Drop'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AwgTab(),
          _InsulationTab(),
          _VoltDropTab(),
        ],
      ),
    );
  }
}

class _AwgTab extends StatefulWidget {
  @override
  State<_AwgTab> createState() => _AwgTabState();
}

class _AwgTabState extends State<_AwgTab> {
  String _tempRating = '75C';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Temp Rating Selector
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(
                'Insulation Temp: ',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(width: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: '60C', label: Text('60°C')),
                  ButtonSegment(value: '75C', label: Text('75°C')),
                  ButtonSegment(value: '90C', label: Text('90°C')),
                ],
                selected: {_tempRating},
                onSelectionChanged: (selection) {
                  setState(() => _tempRating = selection.first);
                },
              ),
            ],
          ),
        ),

        // Info Banner
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Copper wire ampacity per NEC Table 310.16 (≤3 conductors)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              _HeaderCell(label: 'AWG', flex: 2),
              _HeaderCell(label: 'Dia (mm)'),
              _HeaderCell(label: 'Ω/kft'),
              _HeaderCell(label: 'Amps', flex: 2),
            ],
          ),
        ),

        // Wire List
        Expanded(
          child: ListView.builder(
            itemCount: wireGauges.length,
            itemBuilder: (context, index) {
              final wire = wireGauges[index];
              final isEven = index % 2 == 0;

              int ampacity;
              switch (_tempRating) {
                case '60C':
                  ampacity = wire.ampacity60C;
                  break;
                case '90C':
                  ampacity = wire.ampacity90C;
                  break;
                default:
                  ampacity = wire.ampacity75C;
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                color: isEven
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        awgDisplayName(wire.awg),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        wire.diameterMm.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        wire.resistancePerKft.toStringAsFixed(3),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '$ampacity A',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const _HeaderCell({required this.label, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _InsulationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Wire Insulation Types',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...wireInsulations.map((ins) => _InsulationCard(insulation: ins)),
      ],
    );
  }
}

class _InsulationCard extends StatelessWidget {
  final WireInsulation insulation;

  const _InsulationCard({required this.insulation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    insulation.type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    insulation.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.thermostat,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text('Max ${insulation.maxTemp}°C'),
                const SizedBox(width: 16),
                Icon(
                  insulation.wetLocation ? Icons.water_drop : Icons.water_drop_outlined,
                  size: 16,
                  color: insulation.wetLocation ? Colors.blue : Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(insulation.wetLocation ? 'Wet OK' : 'Dry only'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              insulation.application,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _VoltDropTab extends StatefulWidget {
  @override
  State<_VoltDropTab> createState() => _VoltDropTabState();
}

class _VoltDropTabState extends State<_VoltDropTab> {
  double _current = 20;
  double _length = 100;
  int _selectedWireIndex = 3; // 12 AWG default
  double _voltage = 120;
  bool _singlePhase = true;

  double get _voltageDrop {
    final wire = wireGauges[_selectedWireIndex];
    return calculateVoltageDrop(
      current: _current,
      length: _length,
      resistance: wire.resistancePerKft,
      singlePhase: _singlePhase,
    );
  }

  double get _voltageDropPercent => voltageDropPercent(_voltageDrop, _voltage);

  Color get _dropColor {
    if (_voltageDropPercent <= 3) return Colors.green;
    if (_voltageDropPercent <= 5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Phase Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Type',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('Single Phase')),
                      ButtonSegment(value: false, label: Text('Three Phase')),
                    ],
                    selected: {_singlePhase},
                    onSelectionChanged: (selection) {
                      setState(() => _singlePhase = selection.first);
                    },
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parameters',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _NumberField(
                          label: 'Current (A)',
                          value: _current,
                          onChanged: (v) => setState(() => _current = v),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _NumberField(
                          label: 'Voltage',
                          value: _voltage,
                          onChanged: (v) => setState(() => _voltage = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _NumberField(
                    label: 'One-Way Length (ft)',
                    value: _length,
                    onChanged: (v) => setState(() => _length = v),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Wire Size',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  DropdownMenu<int>(
                    initialSelection: _selectedWireIndex,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: wireGauges.asMap().entries.map((e) {
                      return DropdownMenuEntry(
                        value: e.key,
                        label: awgDisplayName(e.value.awg),
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        setState(() => _selectedWireIndex = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Voltage Drop',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_voltageDrop.toStringAsFixed(2)} V',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _dropColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_voltageDropPercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _dropColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _voltageDropPercent <= 3
                        ? 'Within NEC recommendation (≤3%)'
                        : _voltageDropPercent <= 5
                            ? 'Acceptable for feeders (≤5%)'
                            : 'Exceeds recommended limits',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
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
                        'Formula',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    _singlePhase
                        ? 'VD = 2 × I × R × L / 1000'
                        : 'VD = 1.732 × I × R × L / 1000',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Where: I = current (A), R = resistance (Ω/kft), L = length (ft)',
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

class _NumberField extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
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
        isDense: true,
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
