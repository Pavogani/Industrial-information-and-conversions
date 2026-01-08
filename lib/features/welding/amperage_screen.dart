import 'package:flutter/material.dart';
import '../../core/models/welding_data.dart';

class AmperageScreen extends StatefulWidget {
  const AmperageScreen({super.key});

  @override
  State<AmperageScreen> createState() => _AmperageScreenState();
}

class _AmperageScreenState extends State<AmperageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _electrodeController = TextEditingController();
  String _decodedResult = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _electrodeController.dispose();
    super.dispose();
  }

  void _decodeElectrode() {
    final input = _electrodeController.text.trim().toUpperCase();
    if (input.isEmpty) {
      setState(() => _decodedResult = '');
      return;
    }

    String electrode = input;
    if (!electrode.startsWith('E')) {
      electrode = 'E$electrode';
    }

    setState(() {
      _decodedResult = ElectrodeDecoder.decode(electrode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amperage & Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Stick'),
            Tab(text: 'MIG Wire'),
            Tab(text: 'Decoder'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StickAmperageTab(),
          _MigWireTab(),
          _DecoderTab(
            controller: _electrodeController,
            result: _decodedResult,
            onDecode: _decodeElectrode,
          ),
        ],
      ),
    );
  }
}

class _StickAmperageTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Rule of Thumb Card
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rule of Thumb',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '1 amp per 0.001" of electrode diameter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Example: 1/8" (0.125") rod ≈ 125 amps (±15%)',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 6010/6011 Amperage
        _AmperageTable(
          title: 'E6010 / E6011 Amperage',
          subtitle: 'Deep penetration, all position',
          data: amperageGuide6010,
          color: Colors.orange,
        ),
        const SizedBox(height: 16),

        // 7018 Amperage
        _AmperageTable(
          title: 'E7018 Amperage',
          subtitle: 'Low hydrogen, structural',
          data: amperageGuide7018,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),

        // Tips Card
        Card(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Setting Tips',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _TipItem(text: 'Start in middle of range, adjust by sound'),
                _TipItem(text: 'Crackling bacon = good; loud popping = too hot'),
                _TipItem(text: 'Rod sticking = too cold; excessive spatter = too hot'),
                _TipItem(text: 'Vertical up: reduce 10-15% from flat'),
                _TipItem(text: 'Overhead: reduce 5-10% from flat'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AmperageTable extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<AmperageGuide> data;
  final Color color;

  const _AmperageTable({
    required this.title,
    required this.subtitle,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.electric_bolt, color: color),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Expanded(child: Text('Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text('Min', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text('Max', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text('Typical', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              ],
            ),
          ),
          // Table Rows
          ...data.asMap().entries.map((entry) {
            final index = entry.key;
            final guide = entry.value;
            final isEven = index % 2 == 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isEven ? null : Theme.of(context).colorScheme.surfaceContainerLowest,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(guide.rodSize, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(guide.diameter, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text('${guide.minAmps}', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text('${guide.maxAmps}', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text(
                      '${guide.typicalAmps}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MigWireTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
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
                    'MIG/FCAW wire selection depends on base metal, shielding gas, and application requirements.',
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

        // Wire Cards
        ...migWires.map((wire) => _MigWireCard(wire: wire)),
      ],
    );
  }
}

class _MigWireCard extends StatelessWidget {
  final MigWire wire;

  const _MigWireCard({required this.wire});

  Color get wireColor {
    if (wire.material.contains('Carbon')) return Colors.orange;
    if (wire.material.contains('Stainless')) return Colors.blue;
    if (wire.material.contains('Aluminum')) return Colors.grey;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: wireColor.withValues(alpha: 0.2),
          child: Icon(
            wire.shieldingGas.contains('None') ? Icons.air : Icons.cloud,
            color: wireColor,
            size: 20,
          ),
        ),
        title: Text(
          wire.awsClass,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(wire.commonName),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Material and Gas
                Row(
                  children: [
                    Expanded(
                      child: _InfoBox(
                        label: 'Material',
                        value: wire.material,
                        icon: Icons.category,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoBox(
                        label: 'Tensile',
                        value: '${(wire.tensileStrength / 1000).toInt()} ksi',
                        icon: Icons.fitness_center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoBox(
                  label: 'Shielding Gas',
                  value: wire.shieldingGas,
                  icon: Icons.air,
                ),
                const SizedBox(height: 16),

                // Usage
                Text(
                  'Best Used For:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...wire.usage.map((use) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(child: Text(use)),
                        ],
                      ),
                    )),
                const SizedBox(height: 16),

                // Tips
                Text(
                  'Tips:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...wire.tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecoderTab extends StatelessWidget {
  final TextEditingController controller;
  final String result;
  final VoidCallback onDecode;

  const _DecoderTab({
    required this.controller,
    required this.result,
    required this.onDecode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Explanation Card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'How to Read Electrode Numbers',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Example: E7018',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _DecoderLine(label: 'E', meaning: 'Electrode'),
                  _DecoderLine(label: '70', meaning: '70,000 PSI tensile strength'),
                  _DecoderLine(label: '1', meaning: 'All position welding'),
                  _DecoderLine(label: '8', meaning: 'Low hydrogen, iron powder (AC/DCEP)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Input Field
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter Electrode Number',
              hintText: 'e.g., E7018, 6010, 308L',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: onDecode,
              ),
            ),
            onSubmitted: (_) => onDecode(),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: onDecode,
            icon: const Icon(Icons.translate),
            label: const Text('Decode Electrode'),
          ),
          const SizedBox(height: 24),

          // Result
          if (result.isNotEmpty)
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Decoded Result',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      result,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Position Codes Reference
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Position Digit Reference',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(),
                  _ReferenceRow(code: '1', meaning: 'All positions (F, H, V-up, OH)'),
                  _ReferenceRow(code: '2', meaning: 'Flat and Horizontal only'),
                  _ReferenceRow(code: '4', meaning: 'All positions (Vertical down OK)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Coating Codes Reference
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coating/Current Digit Reference',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(),
                  _ReferenceRow(code: '0', meaning: 'High cellulose sodium (DCEP)'),
                  _ReferenceRow(code: '1', meaning: 'High cellulose potassium (AC/DCEP)'),
                  _ReferenceRow(code: '2', meaning: 'High titania sodium (AC/DCEN)'),
                  _ReferenceRow(code: '3', meaning: 'High titania potassium (AC/DC)'),
                  _ReferenceRow(code: '4', meaning: 'Iron powder titania (AC/DC)'),
                  _ReferenceRow(code: '5', meaning: 'Low hydrogen sodium (DCEP)'),
                  _ReferenceRow(code: '6', meaning: 'Low hydrogen potassium (AC/DCEP)'),
                  _ReferenceRow(code: '7', meaning: 'Iron powder iron oxide (AC/DC)'),
                  _ReferenceRow(code: '8', meaning: 'Low hydrogen iron powder (AC/DCEP)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecoderLine extends StatelessWidget {
  final String label;
  final String meaning;

  const _DecoderLine({required this.label, required this.meaning});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            meaning,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferenceRow extends StatelessWidget {
  final String code;
  final String meaning;

  const _ReferenceRow({required this.code, required this.meaning});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(meaning)),
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
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
