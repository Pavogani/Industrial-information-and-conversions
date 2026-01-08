import 'package:flutter/material.dart';
import '../../core/models/metal_gauge_data.dart';

class AntiSeizeScreen extends StatelessWidget {
  const AntiSeizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anti-Seize Guide'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
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
                      'Anti-seize prevents galling, seizing, and corrosion on threaded connections. Choose the right type for your application.',
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

          // Anti-Seize Cards
          ...antiSeizeTypes.map((antiSeize) => _AntiSeizeCard(antiSeize: antiSeize)),

          const SizedBox(height: 16),

          // Application Tips Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tips_and_updates, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Application Tips',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Divider(),
                  _TipItem(text: 'Apply thin, even coat to male threads only'),
                  _TipItem(text: 'Wipe excess from first 2-3 threads at end'),
                  _TipItem(text: 'Reduce torque by 20-30% when using anti-seize'),
                  _TipItem(text: 'Clean threads before application'),
                  _TipItem(text: 'Use brush or applicator cap, avoid fingers'),
                  _TipItem(text: 'Store in cool, dry place with lid tight'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Warning Card
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Important Warnings',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _WarningItem(text: 'Never use copper-based anti-seize on oxygen equipment'),
                  _WarningItem(text: 'Check torque reduction factors for critical applications'),
                  _WarningItem(text: 'Some compounds can cause galvanic corrosion on dissimilar metals'),
                  _WarningItem(text: 'Always verify compatibility with gaskets and seals'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AntiSeizeCard extends StatelessWidget {
  final AntiSeize antiSeize;

  const _AntiSeizeCard({required this.antiSeize});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForType(antiSeize.color),
          child: Text(
            antiSeize.type[0],
            style: TextStyle(
              color: _getTextColorForType(antiSeize.color),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          antiSeize.type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.thermostat, size: 14, color: Theme.of(context).colorScheme.outline),
            const SizedBox(width: 4),
            Text(
              'Max ${antiSeize.maxTemp}°F',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getColorForType(antiSeize.color).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                antiSeize.color,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best For:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.green.shade700,
                      ),
                ),
                const SizedBox(height: 4),
                ...antiSeize.bestFor.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 14, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),
                Text(
                  'Avoid With:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.red.shade700,
                      ),
                ),
                const SizedBox(height: 4),
                ...antiSeize.avoidWith.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Row(
                        children: [
                          Icon(Icons.close, size: 14, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )),
                if (antiSeize.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Notes:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  ...antiSeize.notes.map((note) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                size: 14, color: Theme.of(context).colorScheme.outline),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                note,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForType(String color) {
    if (color.contains('Copper') || color.contains('Bronze')) {
      return Colors.orange.shade300;
    } else if (color.contains('Silver') || color.contains('Gray')) {
      return Colors.grey.shade400;
    } else if (color.contains('Black')) {
      return Colors.grey.shade800;
    } else if (color.contains('White')) {
      return Colors.grey.shade100;
    }
    return Colors.grey.shade400;
  }

  Color _getTextColorForType(String color) {
    if (color.contains('White')) {
      return Colors.black;
    } else if (color.contains('Black')) {
      return Colors.white;
    }
    return Colors.black87;
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
          Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber.shade700),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _WarningItem extends StatelessWidget {
  final String text;

  const _WarningItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
