import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WeldingHubScreen extends StatelessWidget {
  const WeldingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welding & Hot Work'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _WeldingTile(
            icon: Icons.electric_bolt,
            title: 'Welding Rod Guide',
            subtitle: 'SMAW electrode selection and usage',
            onTap: () => context.push('/welding/rods'),
          ),
          _WeldingTile(
            icon: Icons.local_fire_department,
            title: 'Torch & Flame Guide',
            subtitle: 'Oxy-acetylene flame types and brazing',
            onTap: () => context.push('/welding/torch'),
          ),
          _WeldingTile(
            icon: Icons.straighten,
            title: 'Metal Gauges',
            subtitle: 'Sheet metal gauge to thickness conversion',
            onTap: () => context.push('/welding/gauges'),
          ),
          _WeldingTile(
            icon: Icons.opacity,
            title: 'Anti-Seize Guide',
            subtitle: 'Thread compound selection by material',
            onTap: () => context.push('/welding/anti-seize'),
          ),
          _WeldingTile(
            icon: Icons.architecture,
            title: 'Weld Joint Types',
            subtitle: 'Joint prep, design, and strength',
            onTap: () => context.push('/welding/joints'),
          ),
          _WeldingTile(
            icon: Icons.compare_arrows,
            title: 'Welding Processes',
            subtitle: 'SMAW, MIG, TIG, FCAW comparison',
            onTap: () => context.push('/welding/processes'),
          ),
          _WeldingTile(
            icon: Icons.speed,
            title: 'Amperage & Settings',
            subtitle: 'Rod amps, MIG wire, electrode decoder',
            onTap: () => context.push('/welding/amperage'),
          ),
          _WeldingTile(
            icon: Icons.thermostat,
            title: 'Preheat Calculator',
            subtitle: 'Carbon equivalent & preheat temps',
            onTap: () => context.push('/welding/preheat'),
          ),
        ],
      ),
    );
  }
}

class _WeldingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _WeldingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(icon, color: Colors.orange.shade800),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
