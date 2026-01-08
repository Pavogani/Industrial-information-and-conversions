import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/welding_data.dart';

final rodSearchProvider = StateProvider<String>((ref) => '');

final filteredRodsProvider = Provider<List<WeldingRod>>((ref) {
  final query = ref.watch(rodSearchProvider);
  return searchRods(query);
});

class WeldingRodScreen extends ConsumerStatefulWidget {
  const WeldingRodScreen({super.key});

  @override
  ConsumerState<WeldingRodScreen> createState() => _WeldingRodScreenState();
}

class _WeldingRodScreenState extends ConsumerState<WeldingRodScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rods = ref.watch(filteredRodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welding Rod Guide'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by rod number, material, or use...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(rodSearchProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(rodSearchProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: rods.length,
              itemBuilder: (context, index) {
                final rod = rods[index];
                return _RodCard(rod: rod);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RodCard extends StatelessWidget {
  final WeldingRod rod;

  const _RodCard({required this.rod});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getMaterialColor(rod.material),
          child: Text(
            rod.awsClass.replaceAll('E', '').substring(0, 2),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          rod.awsClass,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(rod.commonName),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailSection(
                  title: 'Specifications',
                  children: [
                    _DetailRow(label: 'Material', value: rod.material),
                    _DetailRow(label: 'Polarity', value: rod.polarity),
                    _DetailRow(label: 'Positions', value: rod.positions.join(', ')),
                    _DetailRow(label: 'Tensile Strength', value: '${rod.tensileStrength} PSI'),
                    _DetailRow(label: 'Coating', value: rod.coatingType),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: 'Best Used For',
                  children: rod.usage
                      .map((u) => _BulletPoint(text: u))
                      .toList(),
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: 'Pro Tips',
                  children: rod.tips
                      .map((t) => _TipItem(text: t))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMaterialColor(String material) {
    if (material.contains('Stainless')) return Colors.blue.shade600;
    if (material.contains('Cast Iron')) return Colors.brown.shade600;
    if (material.contains('Dissimilar')) return Colors.purple.shade600;
    return Colors.orange.shade600; // Carbon steel
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
