import 'package:flutter/material.dart';

class ConfinedSpaceScreen extends StatefulWidget {
  const ConfinedSpaceScreen({super.key});

  @override
  State<ConfinedSpaceScreen> createState() => _ConfinedSpaceScreenState();
}

class _ConfinedSpaceScreenState extends State<ConfinedSpaceScreen> {
  final Map<String, bool> _preEntry = {
    'Entry permit issued and posted': false,
    'Attendant assigned and briefed': false,
    'Entry supervisor available': false,
    'Rescue team notified/available': false,
    'Communication system tested': false,
    'Emergency procedures reviewed': false,
  };

  final Map<String, bool> _atmosphericTesting = {
    'Oxygen level tested (19.5-23.5%)': false,
    'LEL tested (<10% of LEL)': false,
    'Toxic gases tested (H2S, CO, etc.)': false,
    'Continuous monitoring set up': false,
    'Calibration of monitors verified': false,
    'Test all levels (top, middle, bottom)': false,
  };

  final Map<String, bool> _isolation = {
    'All energy sources locked out': false,
    'Piping blanked or disconnected': false,
    'Electrical isolated and tagged': false,
    'Mechanical hazards blocked': false,
    'Pneumatic/hydraulic bled down': false,
  };

  final Map<String, bool> _ventilation = {
    'Natural ventilation assessed': false,
    'Forced air ventilation in place': false,
    'Air supply positioned correctly': false,
    'Exhaust positioned at low points': false,
    'Ventilation running 15+ min before entry': false,
  };

  final Map<String, bool> _entryEquipment = {
    'Full body harness worn': false,
    'Retrieval line attached': false,
    'Tripod/davit arm positioned': false,
    'Lighting adequate': false,
    'Proper PPE for hazards': false,
    'SCBA/SAR available if needed': false,
  };

  final Map<String, bool> _duringEntry = {
    'Attendant maintains contact': false,
    'Continuous atmospheric monitoring': false,
    'Entry log maintained': false,
    'Conditions unchanged': false,
    'No unauthorized entry': false,
  };

  int get _completedCount {
    int count = 0;
    count += _preEntry.values.where((v) => v).length;
    count += _atmosphericTesting.values.where((v) => v).length;
    count += _isolation.values.where((v) => v).length;
    count += _ventilation.values.where((v) => v).length;
    count += _entryEquipment.values.where((v) => v).length;
    count += _duringEntry.values.where((v) => v).length;
    return count;
  }

  int get _totalCount {
    return _preEntry.length +
        _atmosphericTesting.length +
        _isolation.length +
        _ventilation.length +
        _entryEquipment.length +
        _duringEntry.length;
  }

  void _resetAll() {
    setState(() {
      _preEntry.updateAll((key, value) => false);
      _atmosphericTesting.updateAll((key, value) => false);
      _isolation.updateAll((key, value) => false);
      _ventilation.updateAll((key, value) => false);
      _entryEquipment.updateAll((key, value) => false);
      _duringEntry.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confined Space Entry'),
        backgroundColor: Colors.purple.shade100,
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
                      _completedCount == _totalCount ? Colors.green : Colors.purple,
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
                  'Pre-Entry Requirements',
                  Icons.assignment,
                  Colors.blue,
                  _preEntry,
                ),
                _buildSection(
                  'Atmospheric Testing',
                  Icons.air,
                  Colors.cyan,
                  _atmosphericTesting,
                ),
                _buildSection(
                  'Isolation & Lockout',
                  Icons.lock,
                  Colors.red,
                  _isolation,
                ),
                _buildSection(
                  'Ventilation',
                  Icons.wind_power,
                  Colors.teal,
                  _ventilation,
                ),
                _buildSection(
                  'Entry Equipment',
                  Icons.engineering,
                  Colors.orange,
                  _entryEquipment,
                ),
                _buildSection(
                  'During Entry',
                  Icons.visibility,
                  Colors.green,
                  _duringEntry,
                ),
                const SizedBox(height: 16),

                // Atmospheric limits reference
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
                            const SizedBox(width: 8),
                            Text(
                              'Atmospheric Limits',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildLimitRow('Oxygen', '19.5% - 23.5%', 'IDLH <16% or >25%'),
                        _buildLimitRow('LEL', '< 10%', 'Action level'),
                        _buildLimitRow('H₂S', '< 10 ppm', 'IDLH 100 ppm'),
                        _buildLimitRow('CO', '< 25 ppm', 'IDLH 1200 ppm'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Roles reference
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: ExpansionTile(
                    leading: Icon(Icons.people, color: Theme.of(context).colorScheme.tertiary),
                    title: const Text('Required Personnel Roles'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRoleItem(
                              'Entry Supervisor',
                              'Authorizes entry, verifies conditions safe, terminates entry',
                            ),
                            const SizedBox(height: 12),
                            _buildRoleItem(
                              'Attendant',
                              'Monitors entrants, maintains communication, summons rescue',
                            ),
                            const SizedBox(height: 12),
                            _buildRoleItem(
                              'Entrant',
                              'Trained in hazards, uses equipment properly, exits on order',
                            ),
                            const SizedBox(height: 12),
                            _buildRoleItem(
                              'Rescue Team',
                              'Trained, equipped, and available for emergency response',
                            ),
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

  Widget _buildLimitRow(String gas, String safe, String danger) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(gas, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(safe, textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              danger,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleItem(String role, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.person, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
