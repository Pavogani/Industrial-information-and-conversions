import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReferenceHubScreen extends StatelessWidget {
  const ReferenceHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reference'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ReferenceTile(
            icon: Icons.pie_chart_outline,
            title: 'Fraction Reference',
            subtitle: 'Fraction to decimal to metric conversion table',
            onTap: () => context.push('/reference/fractions'),
          ),
          _ReferenceTile(
            icon: Icons.build_circle_outlined,
            title: 'Torque Specifications',
            subtitle: 'Bolt torque values by grade and size',
            onTap: () => context.push('/reference/torque'),
          ),
          _ReferenceTile(
            icon: Icons.plumbing,
            title: 'Pipe Thread Reference',
            subtitle: 'NPT/BSPT sizes, tap drills, sealants',
            onTap: () => context.push('/reference/pipe-thread'),
          ),
          _ReferenceTile(
            icon: Icons.view_column,
            title: 'Pipe Schedule Chart',
            subtitle: 'Wall thickness for Schedule 40/80/160',
            onTap: () => context.push('/reference/pipe-schedule'),
          ),
          _ReferenceTile(
            icon: Icons.panorama_fish_eye,
            title: 'O-Ring Reference',
            subtitle: 'AS568 sizes and material selection',
            onTap: () => context.push('/reference/o-ring'),
          ),
          _ReferenceTile(
            icon: Icons.water_drop,
            title: 'Lubricant Guide',
            subtitle: 'Grease/oil selection and compatibility',
            onTap: () => context.push('/reference/lubricant'),
          ),
          _ReferenceTile(
            icon: Icons.diamond,
            title: 'Material Hardness',
            subtitle: 'Rockwell/Brinell/Vickers conversion',
            onTap: () => context.push('/reference/hardness'),
          ),
          _ReferenceTile(
            icon: Icons.cable,
            title: 'Wire & Cable Reference',
            subtitle: 'AWG sizes, ampacity, voltage drop',
            onTap: () => context.push('/reference/wire'),
          ),
          _ReferenceTile(
            icon: Icons.construction,
            title: 'Drill & Tap Chart',
            subtitle: 'Number/letter drills, UNC, UNF, metric taps',
            onTap: () => context.push('/reference/drill-tap'),
          ),
        ],
      ),
    );
  }
}

class _ReferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ReferenceTile({
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
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
