import 'package:flutter/material.dart';
import '../../core/models/welding_data.dart';
import '../../core/widgets/diagrams/weld_joint_diagrams.dart';

class WeldJointsScreen extends StatelessWidget {
  const WeldJointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weld Joint Types'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
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
                      'Joint design affects weld strength, preparation time, and cost. Choose the right joint for your application.',
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

          // Joint Cards
          ...weldJoints.map((joint) => _JointCard(joint: joint)),
        ],
      ),
    );
  }
}

class _JointCard extends StatelessWidget {
  final WeldJoint joint;

  const _JointCard({required this.joint});

  String get jointDiagramType {
    switch (joint.name) {
      case 'Butt Joint':
        return 'butt';
      case 'T-Joint / Fillet':
        return 't-joint';
      case 'Lap Joint':
        return 'lap';
      case 'Corner Joint':
        return 'corner';
      case 'Edge Joint':
        return 'edge';
      default:
        return 'butt';
    }
  }

  Color strengthColor(BuildContext context) {
    if (joint.strengthRating.contains('Excellent')) return Colors.green;
    if (joint.strengthRating.contains('Good')) return Colors.blue;
    if (joint.strengthRating.contains('Moderate')) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: WeldJointDiagram(
          jointType: jointDiagramType,
          size: 60,
        ),
        title: Text(
          joint.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          joint.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Diagram
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: WeldJointDiagram(
                      jointType: jointDiagramType,
                      size: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Strength Rating
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: strengthColor(context).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: strengthColor(context)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, size: 18, color: strengthColor(context)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Strength: ${joint.strengthRating}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: strengthColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Applications
                _SectionTitle(title: 'Applications'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: joint.applications
                      .map((app) => Chip(
                            label: Text(app, style: const TextStyle(fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Preparation
                _SectionTitle(title: 'Joint Preparation'),
                const SizedBox(height: 8),
                ...joint.preparation.map((prep) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.build_outlined,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(prep)),
                        ],
                      ),
                    )),
                const SizedBox(height: 16),

                // Tips
                _SectionTitle(title: 'Welding Tips'),
                const SizedBox(height: 8),
                ...joint.tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
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
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
