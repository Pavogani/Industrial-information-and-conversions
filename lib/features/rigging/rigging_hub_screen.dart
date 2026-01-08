import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiggingHubScreen extends StatelessWidget {
  const RiggingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rigging Reference'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _RiggingHubCard(
            icon: Icons.link,
            title: 'Knots & Hitches',
            subtitle: 'Step-by-step guide to essential rigging knots',
            color: Colors.indigo,
            onTap: () => context.push('/rigging/knots'),
          ),
          _RiggingHubCard(
            icon: Icons.fitness_center,
            title: 'Sling WLL Tables',
            subtitle: 'Wire rope, chain, and synthetic sling capacities',
            color: Colors.teal,
            onTap: () => context.push('/rigging/sling-wll'),
          ),
          _RiggingHubCard(
            icon: Icons.calculate,
            title: 'Load Calculator',
            subtitle: 'Calculate required sling capacity for your lift',
            color: Colors.orange,
            onTap: () => context.push('/rigging/load-calc'),
          ),
        ],
      ),
    );
  }
}

class _RiggingHubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RiggingHubCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
