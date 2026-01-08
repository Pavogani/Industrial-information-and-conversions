import 'package:flutter/material.dart';
import '../../core/models/welding_data.dart';

class WeldingProcessScreen extends StatelessWidget {
  const WeldingProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welding Processes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Comparison Summary Card
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
                        Icons.compare_arrows,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Quick Comparison',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const Divider(),
                  _ComparisonRow(
                    label: 'Easiest to Learn',
                    value: 'MIG (GMAW)',
                    icon: Icons.school,
                  ),
                  _ComparisonRow(
                    label: 'Most Portable',
                    value: 'Stick (SMAW)',
                    icon: Icons.backpack,
                  ),
                  _ComparisonRow(
                    label: 'Highest Quality',
                    value: 'TIG (GTAW)',
                    icon: Icons.star,
                  ),
                  _ComparisonRow(
                    label: 'Fastest Deposition',
                    value: 'Flux Core (FCAW)',
                    icon: Icons.speed,
                  ),
                  _ComparisonRow(
                    label: 'Best for Outdoors',
                    value: 'Stick or Self-Shield FCAW',
                    icon: Icons.wb_sunny,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Process Cards
          ...weldingProcesses.map((process) => _ProcessCard(process: process)),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ComparisonRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onPrimaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessCard extends StatelessWidget {
  final WeldingProcess process;

  const _ProcessCard({required this.process});

  Color get processColor {
    switch (process.code) {
      case 'SMAW':
        return Colors.orange;
      case 'GMAW':
        return Colors.blue;
      case 'FCAW':
        return Colors.purple;
      case 'GTAW':
        return Colors.teal;
      case 'OAW':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get processIcon {
    switch (process.code) {
      case 'SMAW':
        return Icons.electric_bolt;
      case 'GMAW':
        return Icons.air;
      case 'FCAW':
        return Icons.autorenew;
      case 'GTAW':
        return Icons.tune;
      case 'OAW':
        return Icons.local_fire_department;
      default:
        return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: processColor.withValues(alpha: 0.2),
          child: Icon(processIcon, color: processColor),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: processColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                process.code,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(process.name)),
          ],
        ),
        subtitle: Text(
          process.description,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skill Level & Equipment
                Row(
                  children: [
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.psychology,
                        label: 'Skill',
                        value: process.skillLevel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.construction, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          process.equipment,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Advantages
                _SectionHeader(
                  title: 'Advantages',
                  icon: Icons.thumb_up,
                  color: Colors.green,
                ),
                const SizedBox(height: 8),
                ...process.advantages.map((adv) => _ListItem(
                      text: adv,
                      icon: Icons.add_circle_outline,
                      color: Colors.green,
                    )),
                const SizedBox(height: 16),

                // Disadvantages
                _SectionHeader(
                  title: 'Disadvantages',
                  icon: Icons.thumb_down,
                  color: Colors.red,
                ),
                const SizedBox(height: 8),
                ...process.disadvantages.map((dis) => _ListItem(
                      text: dis,
                      icon: Icons.remove_circle_outline,
                      color: Colors.red,
                    )),
                const SizedBox(height: 16),

                // Best For
                _SectionHeader(
                  title: 'Best Used For',
                  icon: Icons.star,
                  color: Colors.amber,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: process.bestFor
                      .map((use) => Chip(
                            label: Text(use, style: const TextStyle(fontSize: 12)),
                            backgroundColor: Colors.amber.withValues(alpha: 0.2),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSecondaryContainer),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _ListItem({
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
