import 'package:flutter/material.dart';

class MotorNameplateDecoderScreen extends StatelessWidget {
  const MotorNameplateDecoderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motor Nameplate Decoder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Common nameplate fields
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.electric_bolt),
                      SizedBox(width: 8),
                      Text(
                        'Electrical Ratings',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFieldItem(
                    context,
                    'HP / kW',
                    'Horsepower or kilowatts output',
                    'Mechanical power at shaft. 1 HP = 0.746 kW',
                  ),
                  _buildFieldItem(
                    context,
                    'VOLTS',
                    'Rated voltage(s)',
                    '208-230/460V = dual voltage. Wire for your supply.',
                  ),
                  _buildFieldItem(
                    context,
                    'AMPS (FLA)',
                    'Full Load Amps per voltage',
                    '13.6-12.6/6.3A corresponds to voltage ratings',
                  ),
                  _buildFieldItem(
                    context,
                    'PHASE (PH)',
                    '1 or 3 phase',
                    '1Ø = single phase, 3Ø = three phase',
                  ),
                  _buildFieldItem(
                    context,
                    'HZ',
                    'Frequency',
                    '60 Hz (North America), 50 Hz (Europe/Asia)',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Performance ratings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.speed),
                      SizedBox(width: 8),
                      Text(
                        'Performance Ratings',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFieldItem(
                    context,
                    'RPM',
                    'Full load speed',
                    '1750 = 4-pole, 3500 = 2-pole, 1150 = 6-pole at 60Hz',
                  ),
                  _buildFieldItem(
                    context,
                    'SF (Service Factor)',
                    'Overload capacity',
                    '1.15 = can handle 15% overload continuously',
                  ),
                  _buildFieldItem(
                    context,
                    'EFF',
                    'Efficiency percentage',
                    'Higher % = less heat loss, lower operating cost',
                  ),
                  _buildFieldItem(
                    context,
                    'PF (Power Factor)',
                    'Power factor rating',
                    'Ratio of real to apparent power. Higher = better.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Frame and enclosure
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.straighten),
                      SizedBox(width: 8),
                      Text(
                        'Frame & Enclosure',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFieldItem(
                    context,
                    'FRAME',
                    'NEMA frame size',
                    'Defines mounting dimensions. Example: 215T',
                  ),
                  _buildFieldItem(
                    context,
                    'ENCL',
                    'Enclosure type',
                    'ODP, TEFC, TENV, TEAO, XP (see below)',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // NEMA Frame decoder
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: ExpansionTile(
              leading: Icon(Icons.grid_on, color: Theme.of(context).colorScheme.tertiary),
              title: const Text('NEMA Frame Size Decoder'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Frame number indicates shaft centerline height:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildFrameRow('First 2 digits ÷ 4', 'Shaft height in inches'),
                      _buildFrameRow('Example: 215', '21 ÷ 4 = 5.25" shaft height'),
                      _buildFrameRow('Example: 326', '32 ÷ 4 = 8" shaft height'),
                      const Divider(),
                      const Text(
                        'Frame Suffixes:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildFrameRow('T', 'Integral HP, standard since 1964'),
                      _buildFrameRow('U', 'Pre-1964 "U" frame (obsolete)'),
                      _buildFrameRow('TS', 'Short shaft (close-coupled pump)'),
                      _buildFrameRow('TC', 'C-face mounting'),
                      _buildFrameRow('JM', 'Close-coupled pump motor'),
                      _buildFrameRow('JP', 'Close-coupled pump (medium thrust)'),
                      _buildFrameRow('Z', 'Special shaft or mounting'),
                      _buildFrameRow('Y', 'Non-standard mounting'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Enclosure types
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.shield),
              title: const Text('Enclosure Types'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildEnclosureRow(
                        context,
                        'ODP',
                        'Open Drip Proof',
                        'Indoor clean areas. Vents at 0-15° from vertical.',
                      ),
                      _buildEnclosureRow(
                        context,
                        'TEFC',
                        'Totally Enclosed Fan Cooled',
                        'Most common. Outdoor/dirty areas. External fan.',
                      ),
                      _buildEnclosureRow(
                        context,
                        'TENV',
                        'Totally Enclosed Non-Ventilated',
                        'No external cooling. Low HP or intermittent duty.',
                      ),
                      _buildEnclosureRow(
                        context,
                        'TEAO',
                        'Totally Enclosed Air Over',
                        'Cooled by driven equipment airflow (fans, blowers).',
                      ),
                      _buildEnclosureRow(
                        context,
                        'TEBC',
                        'Totally Enclosed Blower Cooled',
                        'Separate blower for cooling. VFD applications.',
                      ),
                      _buildEnclosureRow(
                        context,
                        'XP / EXPL',
                        'Explosion Proof',
                        'Hazardous locations. Contains internal explosion.',
                      ),
                      _buildEnclosureRow(
                        context,
                        'WP I / WP II',
                        'Weather Protected',
                        'Large motors. WP II has 3 baffled openings.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Insulation and duty
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.thermostat),
                      SizedBox(width: 8),
                      Text(
                        'Insulation & Duty',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFieldItem(
                    context,
                    'INS CL',
                    'Insulation Class',
                    'A=105°C, B=130°C, F=155°C, H=180°C max temp',
                  ),
                  _buildFieldItem(
                    context,
                    'AMB',
                    'Ambient temp rating',
                    'Usually 40°C. Higher ambient = derate motor.',
                  ),
                  _buildFieldItem(
                    context,
                    'DUTY',
                    'Duty cycle',
                    'CONT = continuous, INT = intermittent (time rated)',
                  ),
                  _buildFieldItem(
                    context,
                    'TIME',
                    'Intermittent rating',
                    '15, 30, 60 min ratings for intermittent duty',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Design letters
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.category),
              title: const Text('NEMA Design Letters'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDesignRow(
                        context,
                        'A',
                        'High starting current, low slip',
                        'Rarely used. High efficiency.',
                      ),
                      _buildDesignRow(
                        context,
                        'B',
                        'Normal starting torque, normal starting current',
                        'Most common. General purpose.',
                      ),
                      _buildDesignRow(
                        context,
                        'C',
                        'High starting torque, normal starting current',
                        'Hard-to-start loads: conveyors, crushers.',
                      ),
                      _buildDesignRow(
                        context,
                        'D',
                        'High starting torque, high slip',
                        'High inertia: punch presses, hoists.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Code letter
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: ExpansionTile(
              leading: Icon(Icons.bolt, color: Theme.of(context).colorScheme.error),
              title: const Text('Code Letter (Starting kVA)'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Locked Rotor kVA per HP (determines inrush current)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 24,
                          columns: const [
                            DataColumn(label: Text('Code')),
                            DataColumn(label: Text('kVA/HP')),
                            DataColumn(label: Text('Code')),
                            DataColumn(label: Text('kVA/HP')),
                          ],
                          rows: const [
                            DataRow(cells: [
                              DataCell(Text('A')), DataCell(Text('0-3.15')),
                              DataCell(Text('L')), DataCell(Text('9.0-10.0')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('B')), DataCell(Text('3.15-3.55')),
                              DataCell(Text('M')), DataCell(Text('10.0-11.2')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('C')), DataCell(Text('3.55-4.0')),
                              DataCell(Text('N')), DataCell(Text('11.2-12.5')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('D')), DataCell(Text('4.0-4.5')),
                              DataCell(Text('P')), DataCell(Text('12.5-14.0')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('E')), DataCell(Text('4.5-5.0')),
                              DataCell(Text('R')), DataCell(Text('14.0-16.0')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('F')), DataCell(Text('5.0-5.6')),
                              DataCell(Text('S')), DataCell(Text('16.0-18.0')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('G')), DataCell(Text('5.6-6.3')),
                              DataCell(Text('T')), DataCell(Text('18.0-20.0')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('H')), DataCell(Text('6.3-7.1')),
                              DataCell(Text('U')), DataCell(Text('20.0-22.4')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('J')), DataCell(Text('7.1-8.0')),
                              DataCell(Text('V')), DataCell(Text('22.4+')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('K')), DataCell(Text('8.0-9.0')),
                              DataCell(Text('')), DataCell(Text('')),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Lower code letter = lower starting current. Important for sizing starters and supply.',
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

  Widget _buildFieldItem(BuildContext context, String field, String meaning, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              field,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meaning, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(details, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameRow(String item, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }

  Widget _buildEnclosureRow(BuildContext context, String code, String name, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignRow(BuildContext context, String design, String characteristics, String usage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              design,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(characteristics, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(usage, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
