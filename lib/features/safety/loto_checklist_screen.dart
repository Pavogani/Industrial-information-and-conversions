import 'package:flutter/material.dart';

class LotoChecklistScreen extends StatefulWidget {
  const LotoChecklistScreen({super.key});

  @override
  State<LotoChecklistScreen> createState() => _LotoChecklistScreenState();
}

class _LotoChecklistScreenState extends State<LotoChecklistScreen> {
  final Map<String, bool> _preparation = {
    'Identify all energy sources': false,
    'Notify affected employees': false,
    'Review equipment-specific procedures': false,
    'Gather locks, tags, and devices': false,
    'Identify isolation points': false,
  };

  final Map<String, bool> _shutdown = {
    'Perform orderly equipment shutdown': false,
    'Operate disconnect switches': false,
    'Apply lockout devices': false,
    'Attach danger tags': false,
  };

  final Map<String, bool> _verification = {
    'Verify zero energy state': false,
    'Test start controls (must not start)': false,
    'Check stored energy released': false,
    'Verify all personnel clear': false,
  };

  final Map<String, bool> _restoration = {
    'Remove tools and materials': false,
    'Reinstall guards and covers': false,
    'Notify affected employees': false,
    'Remove locks (only by owner)': false,
    'Restore energy sources': false,
    'Test equipment operation': false,
  };

  int get _completedCount {
    int count = 0;
    count += _preparation.values.where((v) => v).length;
    count += _shutdown.values.where((v) => v).length;
    count += _verification.values.where((v) => v).length;
    count += _restoration.values.where((v) => v).length;
    return count;
  }

  int get _totalCount {
    return _preparation.length + _shutdown.length + _verification.length + _restoration.length;
  }

  void _resetAll() {
    setState(() {
      _preparation.updateAll((key, value) => false);
      _shutdown.updateAll((key, value) => false);
      _verification.updateAll((key, value) => false);
      _restoration.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOTO Checklist'),
        backgroundColor: Colors.red.shade100,
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
                      _completedCount == _totalCount ? Colors.green : Colors.red,
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
                  'Step 1: Preparation',
                  Icons.assignment,
                  Colors.blue,
                  _preparation,
                ),
                _buildSection(
                  'Step 2: Shutdown & Lockout',
                  Icons.lock,
                  Colors.red,
                  _shutdown,
                ),
                _buildSection(
                  'Step 3: Verification',
                  Icons.verified_user,
                  Colors.orange,
                  _verification,
                ),
                _buildSection(
                  'Step 4: Restoration',
                  Icons.play_circle,
                  Colors.green,
                  _restoration,
                ),
                const SizedBox(height: 16),

                // Energy sources reference
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: ExpansionTile(
                    leading: Icon(Icons.bolt, color: Theme.of(context).colorScheme.tertiary),
                    title: const Text('Energy Types to Consider'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildEnergyItem(Icons.electric_bolt, 'Electrical', 'Disconnect, verify dead'),
                            _buildEnergyItem(Icons.compress, 'Hydraulic', 'Relieve pressure, block'),
                            _buildEnergyItem(Icons.air, 'Pneumatic', 'Bleed lines, block'),
                            _buildEnergyItem(Icons.thermostat, 'Thermal', 'Allow cooling, insulate'),
                            _buildEnergyItem(Icons.waves, 'Mechanical', 'Block, restrain'),
                            _buildEnergyItem(Icons.science, 'Chemical', 'Drain, flush, blank'),
                            _buildEnergyItem(Icons.height, 'Gravitational', 'Block, lower, support'),
                            _buildEnergyItem(Icons.sync, 'Stored/Residual', 'Release, dissipate'),
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

  Widget _buildEnergyItem(IconData icon, String type, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          SizedBox(width: 100, child: Text(type, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(action)),
        ],
      ),
    );
  }
}
