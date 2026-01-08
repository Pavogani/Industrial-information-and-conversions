import 'package:flutter/material.dart';

class HotWorkChecklistScreen extends StatefulWidget {
  const HotWorkChecklistScreen({super.key});

  @override
  State<HotWorkChecklistScreen> createState() => _HotWorkChecklistScreenState();
}

class _HotWorkChecklistScreenState extends State<HotWorkChecklistScreen> {
  final Map<String, bool> _preWork = {
    'Hot work permit obtained': false,
    'Fire watch assigned': false,
    'Fire extinguisher available': false,
    'Sprinklers operational (or impairment permit)': false,
    'Smoke/heat detectors covered': false,
    'Area supervisor notified': false,
  };

  final Map<String, bool> _areaPreparation = {
    'Combustibles moved 35+ feet away': false,
    'Combustibles covered with fire blankets': false,
    'Floor swept clean of debris': false,
    'Openings in floors/walls covered': false,
    'Containers purged of flammables': false,
    'Ducts and conveyors shut down': false,
  };

  final Map<String, bool> _equipment = {
    'Welding equipment inspected': false,
    'Cables and hoses in good condition': false,
    'Proper PPE available and worn': false,
    'Ventilation adequate': false,
    'Screens/barriers in place': false,
    'Ground connections secure': false,
  };

  final Map<String, bool> _fireWatch = {
    'Fire watch trained and equipped': false,
    'Fire watch has communication device': false,
    'Fire watch knows alarm locations': false,
    'Fire watch maintains 30-min post-work vigil': false,
    'Backup fire watch for breaks': false,
  };

  final Map<String, bool> _postWork = {
    'Area inspected for smoldering': false,
    'Equipment properly secured': false,
    'Permit closed out': false,
    'Final inspection at 30 minutes': false,
    'Final inspection at 60 minutes': false,
  };

  int get _completedCount {
    int count = 0;
    count += _preWork.values.where((v) => v).length;
    count += _areaPreparation.values.where((v) => v).length;
    count += _equipment.values.where((v) => v).length;
    count += _fireWatch.values.where((v) => v).length;
    count += _postWork.values.where((v) => v).length;
    return count;
  }

  int get _totalCount {
    return _preWork.length +
        _areaPreparation.length +
        _equipment.length +
        _fireWatch.length +
        _postWork.length;
  }

  void _resetAll() {
    setState(() {
      _preWork.updateAll((key, value) => false);
      _areaPreparation.updateAll((key, value) => false);
      _equipment.updateAll((key, value) => false);
      _fireWatch.updateAll((key, value) => false);
      _postWork.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Work Permit'),
        backgroundColor: Colors.orange.shade100,
        actions: [
          TextButton.icon(
            onPressed: _resetAll,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: _completedCount / _totalCount,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(
                      _completedCount == _totalCount ? Colors.green : Colors.orange,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$_completedCount / $_totalCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Checklists
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  'Pre-Work Requirements',
                  Icons.assignment,
                  Colors.blue,
                  _preWork,
                ),
                _buildSection(
                  'Area Preparation',
                  Icons.cleaning_services,
                  Colors.purple,
                  _areaPreparation,
                ),
                _buildSection(
                  'Equipment Check',
                  Icons.build,
                  Colors.teal,
                  _equipment,
                ),
                _buildSection(
                  'Fire Watch',
                  Icons.local_fire_department,
                  Colors.orange,
                  _fireWatch,
                ),
                _buildSection(
                  'Post-Work',
                  Icons.check_circle,
                  Colors.green,
                  _postWork,
                ),
                const SizedBox(height: 16),

                // Reference info
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: ExpansionTile(
                    leading: Icon(Icons.info, color: Theme.of(context).colorScheme.tertiary),
                    title: const Text('Hot Work Safety Distances'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDistanceItem('35 ft', 'Minimum clear radius for combustibles'),
                            _buildDistanceItem('50 ft', 'For flammable liquids/gases'),
                            _buildDistanceItem('30 min', 'Minimum fire watch after work'),
                            _buildDistanceItem('60 min', 'Extended watch for concealed spaces'),
                            const Divider(),
                            const Text(
                              'PPE Required:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text('• Welding helmet with proper shade'),
                            const Text('• Fire-resistant clothing'),
                            const Text('• Leather gloves and apron'),
                            const Text('• Safety glasses under helmet'),
                            const Text('• Steel-toe boots'),
                          ],
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

  Widget _buildSection(
    String title,
    IconData icon,
    Color color,
    Map<String, bool> items,
  ) {
    final completed = items.values.where((v) => v).length;
    final total = items.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: completed == total ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$completed/$total',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 1),
          ...items.entries.map((entry) {
            return CheckboxListTile(
              title: Text(entry.key),
              value: entry.value,
              onChanged: (value) {
                setState(() {
                  items[entry.key] = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.green,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDistanceItem(String distance, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              distance,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }
}
