import 'package:flutter/material.dart';

class CouplingTolerancesScreen extends StatefulWidget {
  const CouplingTolerancesScreen({super.key});

  @override
  State<CouplingTolerancesScreen> createState() => _CouplingTolerancesScreenState();
}

class _CouplingTolerancesScreenState extends State<CouplingTolerancesScreen> {
  String _selectedType = 'flexible';
  String _speedRange = '1800';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupling Tolerances'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Coupling type selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Coupling Type',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Flexible'),
                        selected: _selectedType == 'flexible',
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedType = 'flexible');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Gear'),
                        selected: _selectedType == 'gear',
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedType = 'gear');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Disc/Diaphragm'),
                        selected: _selectedType == 'disc',
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedType = 'disc');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Grid'),
                        selected: _selectedType == 'grid',
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedType = 'grid');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Jaw/Spider'),
                        selected: _selectedType == 'jaw',
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedType = 'jaw');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Speed selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Operating Speed (RPM)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: '900', label: Text('≤900')),
                      ButtonSegment(value: '1800', label: Text('1200-1800')),
                      ButtonSegment(value: '3600', label: Text('3600+')),
                    ],
                    selected: {_speedRange},
                    onSelectionChanged: (selection) {
                      setState(() => _speedRange = selection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tolerance table
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.straighten),
                      const SizedBox(width: 8),
                      Text(
                        'Recommended Tolerances',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildToleranceTable(context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Alignment definitions
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Alignment Definitions'),
              initiallyExpanded: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDefinitionRow(
                        context,
                        'Parallel (Offset)',
                        'Shaft centerlines are parallel but not collinear',
                        'Measured in mils (0.001") or mm',
                      ),
                      const Divider(),
                      _buildDefinitionRow(
                        context,
                        'Angular',
                        'Shaft centerlines intersect at an angle',
                        'Measured in mils/inch or mm/100mm',
                      ),
                      const Divider(),
                      _buildDefinitionRow(
                        context,
                        'Axial (Gap)',
                        'Distance between coupling halves',
                        'Per manufacturer specification',
                      ),
                      const Divider(),
                      _buildDefinitionRow(
                        context,
                        'TIR',
                        'Total Indicator Reading',
                        'Full range of dial indicator movement',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Coupling type details
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.settings),
              title: Text(_getCouplingTitle()),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildCouplingDetails(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // General guidelines
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
                        'Alignment Best Practices',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('• Always check for soft foot first'),
                  const Text('• Account for thermal growth at operating temp'),
                  const Text('• Tighter tolerance = longer bearing life'),
                  const Text('• Document final alignment readings'),
                  const Text('• Re-check after piping is connected'),
                  const Text('• Manufacturer specs take precedence'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Thermal growth reference
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.thermostat),
              title: const Text('Thermal Growth Considerations'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rule of Thumb for Steel:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Growth ≈ 0.0063" per foot per 100°F rise\n'
                          'or ≈ 0.012 mm per 100mm per 10°C rise',
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Equipment Considerations:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildThermalRow('Electric Motors', 'Typically grows 2-8 mils'),
                      _buildThermalRow('Pumps (hot)', 'Can grow 20+ mils'),
                      _buildThermalRow('Compressors', 'Check manufacturer data'),
                      _buildThermalRow('Fans/Blowers', 'Usually minimal growth'),
                      const SizedBox(height: 12),
                      const Text(
                        'Cold alignment should be set LOW on the motor to compensate for thermal growth.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
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

  Widget _buildToleranceTable(BuildContext context) {
    final tolerances = _getTolerances();

    return Table(
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(8),
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
          ),
          children: [
            _tableHeader(context, 'Condition'),
            _tableHeader(context, 'Excellent'),
            _tableHeader(context, 'Acceptable'),
          ],
        ),
        TableRow(
          children: [
            _tableCell('Parallel Offset'),
            _tableCell(tolerances['parallel_excellent']!),
            _tableCell(tolerances['parallel_acceptable']!),
          ],
        ),
        TableRow(
          children: [
            _tableCell('Angular'),
            _tableCell(tolerances['angular_excellent']!),
            _tableCell(tolerances['angular_acceptable']!),
          ],
        ),
      ],
    );
  }

  Widget _tableHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  Map<String, String> _getTolerances() {
    // Values in mils (0.001")
    switch (_selectedType) {
      case 'flexible':
        switch (_speedRange) {
          case '900':
            return {
              'parallel_excellent': '2.0 mils',
              'parallel_acceptable': '4.0 mils',
              'angular_excellent': '0.5 mils/in',
              'angular_acceptable': '1.0 mils/in',
            };
          case '1800':
            return {
              'parallel_excellent': '1.0 mils',
              'parallel_acceptable': '2.0 mils',
              'angular_excellent': '0.3 mils/in',
              'angular_acceptable': '0.5 mils/in',
            };
          default: // 3600
            return {
              'parallel_excellent': '0.5 mils',
              'parallel_acceptable': '1.0 mils',
              'angular_excellent': '0.1 mils/in',
              'angular_acceptable': '0.3 mils/in',
            };
        }
      case 'gear':
        switch (_speedRange) {
          case '900':
            return {
              'parallel_excellent': '3.0 mils',
              'parallel_acceptable': '5.0 mils',
              'angular_excellent': '1.0 mils/in',
              'angular_acceptable': '1.5 mils/in',
            };
          case '1800':
            return {
              'parallel_excellent': '2.0 mils',
              'parallel_acceptable': '3.0 mils',
              'angular_excellent': '0.5 mils/in',
              'angular_acceptable': '1.0 mils/in',
            };
          default:
            return {
              'parallel_excellent': '1.0 mils',
              'parallel_acceptable': '2.0 mils',
              'angular_excellent': '0.3 mils/in',
              'angular_acceptable': '0.5 mils/in',
            };
        }
      case 'disc':
        switch (_speedRange) {
          case '900':
            return {
              'parallel_excellent': '1.5 mils',
              'parallel_acceptable': '3.0 mils',
              'angular_excellent': '0.3 mils/in',
              'angular_acceptable': '0.5 mils/in',
            };
          case '1800':
            return {
              'parallel_excellent': '0.75 mils',
              'parallel_acceptable': '1.5 mils',
              'angular_excellent': '0.2 mils/in',
              'angular_acceptable': '0.3 mils/in',
            };
          default:
            return {
              'parallel_excellent': '0.5 mils',
              'parallel_acceptable': '0.75 mils',
              'angular_excellent': '0.1 mils/in',
              'angular_acceptable': '0.2 mils/in',
            };
        }
      case 'grid':
        switch (_speedRange) {
          case '900':
            return {
              'parallel_excellent': '2.5 mils',
              'parallel_acceptable': '4.0 mils',
              'angular_excellent': '0.75 mils/in',
              'angular_acceptable': '1.0 mils/in',
            };
          case '1800':
            return {
              'parallel_excellent': '1.5 mils',
              'parallel_acceptable': '2.5 mils',
              'angular_excellent': '0.5 mils/in',
              'angular_acceptable': '0.75 mils/in',
            };
          default:
            return {
              'parallel_excellent': '0.75 mils',
              'parallel_acceptable': '1.5 mils',
              'angular_excellent': '0.25 mils/in',
              'angular_acceptable': '0.5 mils/in',
            };
        }
      case 'jaw':
      default:
        switch (_speedRange) {
          case '900':
            return {
              'parallel_excellent': '4.0 mils',
              'parallel_acceptable': '6.0 mils',
              'angular_excellent': '1.0 mils/in',
              'angular_acceptable': '1.5 mils/in',
            };
          case '1800':
            return {
              'parallel_excellent': '2.0 mils',
              'parallel_acceptable': '4.0 mils',
              'angular_excellent': '0.5 mils/in',
              'angular_acceptable': '1.0 mils/in',
            };
          default:
            return {
              'parallel_excellent': '1.0 mils',
              'parallel_acceptable': '2.0 mils',
              'angular_excellent': '0.3 mils/in',
              'angular_acceptable': '0.5 mils/in',
            };
        }
    }
  }

  String _getCouplingTitle() {
    switch (_selectedType) {
      case 'flexible':
        return 'Flexible Element Coupling';
      case 'gear':
        return 'Gear Coupling';
      case 'disc':
        return 'Disc/Diaphragm Coupling';
      case 'grid':
        return 'Grid Coupling';
      case 'jaw':
        return 'Jaw/Spider Coupling';
      default:
        return 'Coupling Details';
    }
  }

  Widget _buildCouplingDetails(BuildContext context) {
    switch (_selectedType) {
      case 'flexible':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Characteristics:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Elastomeric element absorbs vibration'),
            Text('• No lubrication required'),
            Text('• Moderate misalignment capacity'),
            Text('• Replace element when cracked/worn'),
            SizedBox(height: 8),
            Text('Common Types:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Tire type, Sleeve type, Donut type'),
          ],
        );
      case 'gear':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Characteristics:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• High torque capacity'),
            Text('• Requires periodic lubrication'),
            Text('• Good misalignment accommodation'),
            Text('• Check for tooth wear'),
            SizedBox(height: 8),
            Text('Maintenance:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Inspect grease every 6-12 months'),
            Text('• Check seal condition'),
          ],
        );
      case 'disc':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Characteristics:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• No backlash - good for precision'),
            Text('• Maintenance-free (no lubrication)'),
            Text('• Lower misalignment tolerance'),
            Text('• Disc packs are replaceable'),
            SizedBox(height: 8),
            Text('Applications:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• High-speed turbines, compressors'),
            Text('• Applications requiring zero backlash'),
          ],
        );
      case 'grid':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Characteristics:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Tapered grid spring provides flexibility'),
            Text('• Requires lubrication'),
            Text('• Good shock absorption'),
            Text('• Replace grid when worn'),
            SizedBox(height: 8),
            Text('Maintenance:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Inspect grid for cracks'),
            Text('• Check cover seal'),
          ],
        );
      case 'jaw':
      default:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Characteristics:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Elastomer spider (insert) dampens shock'),
            Text('• Fail-safe jaw engagement'),
            Text('• No lubrication required'),
            Text('• Easy spider replacement'),
            SizedBox(height: 8),
            Text('Spider Materials:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• NBR (Buna-N) - Standard'),
            Text('• Hytrel - High torque'),
            Text('• Urethane - Oil resistant'),
          ],
        );
    }
  }

  Widget _buildDefinitionRow(BuildContext context, String term, String definition, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(term, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(definition),
              Text(unit, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThermalRow(String equipment, String growth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(equipment)),
          Text(growth, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
