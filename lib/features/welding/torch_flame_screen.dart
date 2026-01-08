import 'package:flutter/material.dart';
import '../../core/models/welding_data.dart';

class TorchFlameScreen extends StatelessWidget {
  const TorchFlameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Torch & Flame Guide'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Flame Types Section
          Text(
            'Flame Types',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...flameTypes.map((flame) => _FlameCard(flame: flame)),

          const SizedBox(height: 24),

          // Torch Pressures Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Typical Torch Pressures',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Divider(),
                  _PressureRow(
                    task: 'Cutting (up to 1")',
                    acetylene: '5-7 PSI',
                    oxygen: '30-40 PSI',
                  ),
                  _PressureRow(
                    task: 'Cutting (1"-2")',
                    acetylene: '5-7 PSI',
                    oxygen: '40-50 PSI',
                  ),
                  _PressureRow(
                    task: 'Welding',
                    acetylene: '5-7 PSI',
                    oxygen: '5-7 PSI',
                  ),
                  _PressureRow(
                    task: 'Brazing',
                    acetylene: '5-7 PSI',
                    oxygen: '5-10 PSI',
                  ),
                  _PressureRow(
                    task: 'Heating',
                    acetylene: '5-10 PSI',
                    oxygen: '10-15 PSI',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Brazing Section
          Text(
            'Brazing Reference',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...brazingData.map((braze) => _BrazingCard(braze: braze)),

          const SizedBox(height: 24),

          // Safety Card
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
                        'Safety Reminders',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SafetyItem(text: 'Always open acetylene first, close acetylene last'),
                  _SafetyItem(text: 'Check for leaks with soapy water, NEVER flame'),
                  _SafetyItem(text: 'Keep cylinders upright and secured'),
                  _SafetyItem(text: 'Acetylene max working pressure: 15 PSI'),
                  _SafetyItem(text: 'Use flashback arrestors at regulators'),
                  _SafetyItem(text: 'Never use oil or grease on oxygen equipment'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlameCard extends StatelessWidget {
  final FlameType flame;

  const _FlameCard({required this.flame});

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
                Icon(
                  Icons.local_fire_department,
                  color: _getFlameColor(flame.name),
                ),
                const SizedBox(width: 8),
                Text(
                  flame.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.visibility, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      flame.appearance,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ratio: ${flame.oxyRatio}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Best Uses:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ...flame.uses.map((use) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Row(
                    children: [
                      const Text('• '),
                      Expanded(child: Text(use)),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            ...flame.tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 14, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tip,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Color _getFlameColor(String name) {
    if (name.contains('Neutral')) return Colors.blue;
    if (name.contains('Carburizing')) return Colors.orange;
    return Colors.red; // Oxidizing
  }
}

class _BrazingCard extends StatelessWidget {
  final BrazingInfo braze;

  const _BrazingCard({required this.braze});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              braze.fillMetal,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _BrazeRow(label: 'Flux', value: braze.fluxType),
            _BrazeRow(label: 'Flow Temp', value: '${braze.tempRange}°F+'),
            _BrazeRow(label: 'Base Metals', value: braze.baseMaterials.join(', ')),
            const SizedBox(height: 8),
            ...braze.tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, size: 14, color: Colors.amber.shade700),
                      const SizedBox(width: 4),
                      Expanded(child: Text(tip, style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _BrazeRow extends StatelessWidget {
  final String label;
  final String value;

  const _BrazeRow({required this.label, required this.value});

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
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _PressureRow extends StatelessWidget {
  final String task;
  final String acetylene;
  final String oxygen;

  const _PressureRow({
    required this.task,
    required this.acetylene,
    required this.oxygen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(task)),
          Expanded(
            child: Text(
              acetylene,
              style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              oxygen,
              style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyItem extends StatelessWidget {
  final String text;

  const _SafetyItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
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
