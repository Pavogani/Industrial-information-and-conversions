import 'package:flutter/material.dart';
import '../../core/models/pipe_thread_data.dart';

class PipeThreadScreen extends StatefulWidget {
  const PipeThreadScreen({super.key});

  @override
  State<PipeThreadScreen> createState() => _PipeThreadScreenState();
}

class _PipeThreadScreenState extends State<PipeThreadScreen>
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
        title: const Text('Pipe Thread Reference'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'NPT'),
            Tab(text: 'BSPT'),
            Tab(text: 'Sealants'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NptTab(),
          _BsptTab(),
          _SealantsTab(),
        ],
      ),
    );
  }
}

class _NptTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  'NPT (National Pipe Thread) - 60° thread angle, 1:16 taper',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: nptThreads.length,
            itemBuilder: (context, index) {
              final thread = nptThreads[index];
              return _ThreadCard(
                size: thread.nominalSize,
                od: thread.actualOd,
                tpi: thread.threadsPerInch,
                tapDrill: thread.tapDrillFraction,
                engagement: thread.minEngagement,
                isNpt: true,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BsptTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  'BSPT (British Standard Pipe Taper) - 55° thread angle, 1:16 taper',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: bsptThreads.length,
            itemBuilder: (context, index) {
              final thread = bsptThreads[index];
              return _ThreadCard(
                size: thread.nominalSize,
                od: thread.actualOd,
                tpi: thread.threadsPerInch,
                tapDrill: '${thread.tapDrill}mm',
                engagement: thread.minEngagement,
                isNpt: false,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SealantsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...threadSealants.map((sealant) => _SealantCard(sealant: sealant)),
        const SizedBox(height: 16),
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
                      Icons.tips_and_updates,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Application Tips',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _TipItem(text: 'Clean threads before applying sealant'),
                _TipItem(text: 'Apply to male threads only'),
                _TipItem(text: 'PTFE tape: wrap clockwise (3-5 turns)'),
                _TipItem(text: 'Leave first 2 threads bare to prevent contamination'),
                _TipItem(text: 'Hand-tight + 1-3 turns with wrench'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ThreadCard extends StatelessWidget {
  final String size;
  final double od;
  final double tpi;
  final String tapDrill;
  final double engagement;
  final bool isNpt;

  const _ThreadCard({
    required this.size,
    required this.od,
    required this.tpi,
    required this.tapDrill,
    required this.engagement,
    required this.isNpt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isNpt ? 'NPT' : 'BSPT',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _DataItem(label: 'OD', value: '${od.toStringAsFixed(3)}"')),
                Expanded(child: _DataItem(label: 'TPI', value: tpi % 1 == 0 ? '${tpi.toInt()}' : '$tpi')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _DataItem(label: 'Tap Drill', value: tapDrill)),
                Expanded(
                  child: _DataItem(
                    label: 'Min Engage',
                    value: isNpt ? '${engagement.toStringAsFixed(3)}"' : '${engagement}mm',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  final String label;
  final String value;

  const _DataItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SealantCard extends StatelessWidget {
  final ThreadSealant sealant;

  const _SealantCard({required this.sealant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getSealantColor(sealant.type),
          child: Icon(
            Icons.water_drop,
            color: _getSealantIconColor(sealant.type),
          ),
        ),
        title: Text(
          sealant.type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Max ${sealant.maxPressure} PSI / ${sealant.maxTemp}°F'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compatible With:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.green.shade700,
                      ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: sealant.compatible
                      .map((c) => Chip(
                            label: Text(c, style: const TextStyle(fontSize: 11)),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ))
                      .toList(),
                ),
                if (sealant.notFor.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Not For:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.red.shade700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  ...sealant.notFor.map((n) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2),
                        child: Row(
                          children: [
                            Icon(Icons.close, size: 14, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Text(n),
                          ],
                        ),
                      )),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sealant.notes,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
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

  Color _getSealantColor(String type) {
    if (type.contains('White')) return Colors.grey.shade200;
    if (type.contains('Yellow')) return Colors.yellow.shade200;
    if (type.contains('Pink')) return Colors.pink.shade100;
    if (type.contains('Green')) return Colors.green.shade200;
    if (type.contains('Anaerobic')) return Colors.red.shade100;
    return Colors.brown.shade100;
  }

  Color _getSealantIconColor(String type) {
    if (type.contains('White')) return Colors.grey.shade600;
    if (type.contains('Yellow')) return Colors.yellow.shade800;
    if (type.contains('Pink')) return Colors.pink.shade700;
    if (type.contains('Green')) return Colors.green.shade700;
    if (type.contains('Anaerobic')) return Colors.red.shade700;
    return Colors.brown.shade700;
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
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
