import 'package:flutter/material.dart';
import '../../core/models/rigging_data.dart';

class KnotsScreen extends StatefulWidget {
  const KnotsScreen({super.key});

  @override
  State<KnotsScreen> createState() => _KnotsScreenState();
}

class _KnotsScreenState extends State<KnotsScreen> {
  String _categoryFilter = 'All';

  List<RiggingKnot> get filteredKnots {
    if (_categoryFilter == 'All') return riggingKnots;
    return riggingKnots.where((k) => k.category == _categoryFilter.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knots & Hitches'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _categoryFilter == 'All',
                  onTap: () => setState(() => _categoryFilter = 'All'),
                ),
                _FilterChip(
                  label: 'Loops',
                  selected: _categoryFilter == 'Loop',
                  onTap: () => setState(() => _categoryFilter = 'Loop'),
                ),
                _FilterChip(
                  label: 'Hitches',
                  selected: _categoryFilter == 'Hitch',
                  onTap: () => setState(() => _categoryFilter = 'Hitch'),
                ),
                _FilterChip(
                  label: 'Bends',
                  selected: _categoryFilter == 'Bend',
                  onTap: () => setState(() => _categoryFilter = 'Bend'),
                ),
              ],
            ),
          ),

          // Knots List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredKnots.length,
              itemBuilder: (context, index) {
                return _KnotCard(knot: filteredKnots[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _KnotCard extends StatelessWidget {
  final RiggingKnot knot;

  const _KnotCard({required this.knot});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getDifficultyColor(knot.difficulty).withValues(alpha: 0.2),
          child: Icon(
            _getCategoryIcon(knot.category),
            color: _getDifficultyColor(knot.difficulty),
          ),
        ),
        title: Text(
          knot.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              knot.description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _Badge(
                  label: knot.category.toUpperCase(),
                  color: Colors.indigo,
                ),
                const SizedBox(width: 8),
                _Badge(
                  label: knot.difficulty.toUpperCase(),
                  color: _getDifficultyColor(knot.difficulty),
                ),
                const SizedBox(width: 8),
                _Badge(
                  label: '${knot.strengthRetention}% strength',
                  color: _getStrengthColor(knot.strengthRetention),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Uses
                Text(
                  'Best Uses:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ...knot.uses.map((use) => Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Row(
                        children: [
                          const Text('• '),
                          Expanded(child: Text(use)),
                        ],
                      ),
                    )),

                const Divider(height: 24),

                // Steps
                Text(
                  'How to Tie:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ...knot.steps.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(entry.value)),
                        ],
                      ),
                    )),

                // Strength Warning
                if (knot.strengthRetention < 60)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber, size: 16, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This knot significantly reduces rope strength. Consider safety factors.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade900,
                            ),
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'loop':
        return Icons.radio_button_unchecked;
      case 'hitch':
        return Icons.link;
      case 'bend':
        return Icons.compare_arrows;
      case 'stopper':
        return Icons.stop_circle_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStrengthColor(int retention) {
    if (retention >= 70) return Colors.green;
    if (retention >= 55) return Colors.orange;
    return Colors.red;
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
