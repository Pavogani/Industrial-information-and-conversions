import 'package:flutter/material.dart';
import '../../core/models/hardness_data.dart';

class HardnessScreen extends StatefulWidget {
  const HardnessScreen({super.key});

  @override
  State<HardnessScreen> createState() => _HardnessScreenState();
}

class _HardnessScreenState extends State<HardnessScreen>
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
        title: const Text('Hardness Reference'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Conversion'),
            Tab(text: 'Materials'),
            Tab(text: 'Test Methods'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ConversionTab(),
          _MaterialsTab(),
          _TestMethodsTab(),
        ],
      ),
    );
  }
}

class _ConversionTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Info Banner
        Container(
          padding: const EdgeInsets.all(12),
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Approximate conversions for steel. Actual values vary by material and condition.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              _HeaderCell(label: 'HRC'),
              _HeaderCell(label: 'HB'),
              _HeaderCell(label: 'HV'),
              _HeaderCell(label: 'Tensile'),
            ],
          ),
        ),

        // Conversion Table
        Expanded(
          child: ListView.builder(
            itemCount: hardnessTable.length,
            itemBuilder: (context, index) {
              final conv = hardnessTable[index];
              final isEven = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: isEven
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${conv.rockwellC.toInt()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${conv.brinell.toInt()}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${conv.vickers.toInt()}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        conv.tensileApprox > 0 ? '${conv.tensileApprox} ksi' : '-',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: conv.tensileApprox > 0
                              ? null
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Legend
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('HRC = Rockwell C', style: Theme.of(context).textTheme.bodySmall),
              Text('HB = Brinell', style: Theme.of(context).textTheme.bodySmall),
              Text('HV = Vickers', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;

  const _HeaderCell({required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _MaterialsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Common Material Hardness Ranges',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...commonHardnesses.map((mat) => _MaterialHardnessCard(material: mat)),
      ],
    );
  }
}

class _MaterialHardnessCard extends StatelessWidget {
  final MaterialHardness material;

  const _MaterialHardnessCard({required this.material});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    material.material,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    material.condition,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _HardnessValue(label: 'HRC', value: material.hrcRange),
                _HardnessValue(label: 'HRB', value: material.hrbRange),
                _HardnessValue(label: 'BHN', value: material.brinellRange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HardnessValue extends StatelessWidget {
  final String label;
  final String value;

  const _HardnessValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: value != 'N/A' ? FontWeight.w600 : null,
              color: value == 'N/A' ? Theme.of(context).colorScheme.outline : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _TestMethodsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Hardness Test Methods',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...hardnessTests.map((test) => _TestMethodCard(test: test)),
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
                      'Selection Guide',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _TipItem(text: 'Use HRC for hardened steel (>20 HRC)'),
                _TipItem(text: 'Use HRB for softer materials (<20 HRC equivalent)'),
                _TipItem(text: 'Use Brinell for castings and rough surfaces'),
                _TipItem(text: 'Use Vickers for precision and thin sections'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TestMethodCard extends StatelessWidget {
  final HardnessTest test;

  const _TestMethodCard({required this.test});

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
                    test.code,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  test.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _DetailRow(label: 'Indenter', value: test.indenter),
            _DetailRow(label: 'Load', value: test.load),
            const SizedBox(height: 8),
            Text(
              'Best For:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: test.bestFor
                  .map((b) => Chip(
                        label: Text(b, style: const TextStyle(fontSize: 11)),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
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
