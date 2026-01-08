import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalculatorsHubScreen extends StatelessWidget {
  const CalculatorsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculators'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalculatorTile(
            icon: Icons.architecture,
            title: 'Shaft Alignment',
            subtitle: 'Reverse indicator method calculations',
            onTap: () => context.push('/calculators/alignment'),
          ),
          _CalculatorTile(
            icon: Icons.sync,
            title: 'Belt Length',
            subtitle: 'Calculate V-belt length for pulleys',
            onTap: () => context.push('/calculators/belt-length'),
          ),
          _CalculatorTile(
            icon: Icons.speed,
            title: 'Pulley / RPM',
            subtitle: 'Calculate speeds and pulley sizes',
            onTap: () => context.push('/calculators/pulley-rpm'),
          ),
          _CalculatorTile(
            icon: Icons.compress,
            title: 'Hydraulic Force',
            subtitle: 'Cylinder force and pressure calculations',
            onTap: () => context.push('/calculators/hydraulic'),
          ),
          _CalculatorTile(
            icon: Icons.content_cut,
            title: 'Saw Blade TPI',
            subtitle: 'Calculate teeth per inch for material',
            onTap: () => context.push('/calculators/saw-blade'),
          ),
          _CalculatorTile(
            icon: Icons.stairs,
            title: 'Rise & Run',
            subtitle: 'Stair and ramp slope calculations',
            onTap: () => context.push('/calculators/rise-run'),
          ),
          _CalculatorTile(
            icon: Icons.linear_scale,
            title: 'Belt & Chain Tension',
            subtitle: 'Proper deflection for drives',
            onTap: () => context.push('/calculators/belt-tension'),
          ),
          _CalculatorTile(
            icon: Icons.circle_outlined,
            title: 'Bearing Fit',
            subtitle: 'Shaft/housing tolerances for fits',
            onTap: () => context.push('/calculators/bearing-fit'),
          ),
          _CalculatorTile(
            icon: Icons.settings,
            title: 'Gear Ratio',
            subtitle: 'Speed and torque through gear trains',
            onTap: () => context.push('/calculators/gear-ratio'),
          ),
          _CalculatorTile(
            icon: Icons.electrical_services,
            title: 'Motor / HP',
            subtitle: 'Horsepower, amps, torque calculations',
            onTap: () => context.push('/calculators/motor-hp'),
          ),
          _CalculatorTile(
            icon: Icons.thermostat,
            title: 'Thermal Expansion',
            subtitle: 'Calculate growth for shafts, pipes, rails',
            onTap: () => context.push('/calculators/thermal-expansion'),
          ),
          _CalculatorTile(
            icon: Icons.conveyor_belt,
            title: 'Conveyor Belt',
            subtitle: 'Belt speed, capacity, and power',
            onTap: () => context.push('/calculators/conveyor'),
          ),
          _CalculatorTile(
            icon: Icons.water_drop,
            title: 'Pump Flow',
            subtitle: 'Flow rate, head, power, NPSH',
            onTap: () => context.push('/calculators/pump'),
          ),
          _CalculatorTile(
            icon: Icons.square_foot,
            title: 'Surface Area',
            subtitle: 'Cube, cylinder, sphere, cone, pipe',
            onTap: () => context.push('/calculators/surface-area'),
          ),
        ],
      ),
    );
  }
}

class _CalculatorTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CalculatorTile({
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
