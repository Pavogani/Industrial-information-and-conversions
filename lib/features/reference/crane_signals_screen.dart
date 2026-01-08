import 'package:flutter/material.dart';

class CraneSignalsScreen extends StatelessWidget {
  const CraneSignalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crane Hand Signals'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Safety note
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Only ONE designated signal person should direct crane operations. '
                      'Operator must obey STOP signal from anyone.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Basic signals
          _buildCategory(context, 'Basic Operations', Icons.pan_tool, [
            CraneSignal(
              name: 'HOIST (Raise)',
              description: 'Forearm vertical, forefinger pointing up. Move hand in small horizontal circles.',
              gesture: '☝️ ↻',
              color: Colors.green,
            ),
            CraneSignal(
              name: 'LOWER',
              description: 'Arm extended downward, forefinger pointing down. Move hand in small horizontal circles.',
              gesture: '👇 ↻',
              color: Colors.blue,
            ),
            CraneSignal(
              name: 'STOP',
              description: 'Arm extended, palm down. Move arm back and forth horizontally.',
              gesture: '✋ ↔',
              color: Colors.red,
            ),
            CraneSignal(
              name: 'EMERGENCY STOP',
              description: 'Both arms extended, palms down. Move arms back and forth horizontally.',
              gesture: '🙌 ↔',
              color: Colors.red,
            ),
          ]),
          const SizedBox(height: 16),

          // Boom signals
          _buildCategory(context, 'Boom Operations', Icons.height, [
            CraneSignal(
              name: 'RAISE BOOM',
              description: 'Arm extended, fingers closed, thumb pointing upward.',
              gesture: '👍',
              color: Colors.green,
            ),
            CraneSignal(
              name: 'LOWER BOOM',
              description: 'Arm extended, fingers closed, thumb pointing downward.',
              gesture: '👎',
              color: Colors.blue,
            ),
            CraneSignal(
              name: 'SWING',
              description: 'Arm extended, point with finger in direction of boom swing.',
              gesture: '👉 / 👈',
              color: Colors.orange,
            ),
            CraneSignal(
              name: 'RETRACT BOOM (Telescope In)',
              description: 'Both fists in front of body, thumbs pointing toward each other.',
              gesture: '👊→←👊',
              color: Colors.purple,
            ),
            CraneSignal(
              name: 'EXTEND BOOM (Telescope Out)',
              description: 'Both fists in front of body, thumbs pointing outward.',
              gesture: '←👊 👊→',
              color: Colors.teal,
            ),
          ]),
          const SizedBox(height: 16),

          // Travel signals
          _buildCategory(context, 'Travel', Icons.directions, [
            CraneSignal(
              name: 'TRAVEL (Both Tracks)',
              description: 'Arm extended forward, hand open and slightly raised. Push in direction of travel.',
              gesture: '➡️',
              color: Colors.indigo,
            ),
            CraneSignal(
              name: 'TRAVEL (One Track)',
              description: 'Lock track on side indicated by raised fist. Travel opposite track in direction of extended finger.',
              gesture: '👊 + 👉',
              color: Colors.indigo,
            ),
            CraneSignal(
              name: 'TROLLEY TRAVEL',
              description: 'Palm up, fingers closed, thumb pointing in direction of travel. Jerk hand horizontally.',
              gesture: '👍 ↔',
              color: Colors.cyan,
            ),
            CraneSignal(
              name: 'BRIDGE TRAVEL',
              description: 'Arm extended forward, hand open, make pushing motion in direction of travel.',
              gesture: '🤚 →',
              color: Colors.cyan,
            ),
          ]),
          const SizedBox(height: 16),

          // Multiple operation signals
          _buildCategory(context, 'Multiple Operations', Icons.sync, [
            CraneSignal(
              name: 'RAISE BOOM & LOWER LOAD',
              description: 'Arm extended, thumb up, flex fingers in and out while boom raises.',
              gesture: '👍 + 🤏',
              color: Colors.amber,
            ),
            CraneSignal(
              name: 'LOWER BOOM & RAISE LOAD',
              description: 'Arm extended, thumb down, flex fingers in and out while boom lowers.',
              gesture: '👎 + 🤏',
              color: Colors.amber,
            ),
            CraneSignal(
              name: 'USE MAIN HOIST',
              description: 'Tap fist on head, then use regular signals.',
              gesture: '👊 (head)',
              color: Colors.brown,
            ),
            CraneSignal(
              name: 'USE WHIPLINE (Auxiliary)',
              description: 'Tap elbow with one hand, then use regular signals.',
              gesture: '✋ (elbow)',
              color: Colors.brown,
            ),
          ]),
          const SizedBox(height: 16),

          // Slow/careful signals
          _buildCategory(context, 'Speed Control', Icons.speed, [
            CraneSignal(
              name: 'MOVE SLOWLY',
              description: 'Use one hand to give motion signal, place other hand motionless in front of signal hand. (Hoist Slowly shown)',
              gesture: '☝️ + ✋',
              color: Colors.orange,
            ),
            CraneSignal(
              name: 'DOG EVERYTHING',
              description: 'Clasp hands in front of body. Crane operations temporarily suspended.',
              gesture: '🤝',
              color: Colors.grey,
            ),
          ]),
          const SizedBox(height: 16),

          // Additional reference
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Theme.of(context).colorScheme.tertiary),
                      const SizedBox(width: 8),
                      Text(
                        'Signal Person Requirements',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('• Must be qualified and designated'),
                  const Text('• Wear high-visibility vest/gloves'),
                  const Text('• Maintain clear line of sight to operator'),
                  const Text('• Stay clear of load and swing radius'),
                  const Text('• Know the weight of the load'),
                  const Text('• Understand crane capacity'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Radio/voice commands reference
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.radio),
              title: const Text('Voice/Radio Commands'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Standard voice commands when radio communication is used:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildVoiceCommand('HOIST UP / HOIST DOWN', 'Raise or lower the load'),
                      _buildVoiceCommand('BOOM UP / BOOM DOWN', 'Raise or lower the boom'),
                      _buildVoiceCommand('SWING LEFT / SWING RIGHT', 'Rotate the crane'),
                      _buildVoiceCommand('TRAVEL FORWARD / BACK', 'Move the crane'),
                      _buildVoiceCommand('EXTEND / RETRACT', 'Telescope boom in/out'),
                      _buildVoiceCommand('STOP', 'Cease current motion'),
                      _buildVoiceCommand('ALL STOP / EMERGENCY STOP', 'Stop all operations immediately'),
                      _buildVoiceCommand('HOLD', 'Maintain current position'),
                      const Divider(),
                      const Text(
                        'Always use clear, concise commands. Confirm understanding with repeat-back.',
                        style: TextStyle(fontStyle: FontStyle.italic),
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

  Widget _buildCategory(BuildContext context, String title, IconData icon, List<CraneSignal> signals) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const Divider(height: 1),
          ...signals.map((signal) => _buildSignalTile(context, signal)),
        ],
      ),
    );
  }

  Widget _buildSignalTile(BuildContext context, CraneSignal signal) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: signal.color.withValues(alpha: 0.2),
        child: Text(
          signal.gesture.substring(0, signal.gesture.length > 2 ? 2 : signal.gesture.length),
          style: const TextStyle(fontSize: 16),
        ),
      ),
      title: Text(
        signal.name,
        style: TextStyle(fontWeight: FontWeight.bold, color: signal.color),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: signal.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: signal.color.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      signal.gesture,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      signal.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceCommand(String command, String meaning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mic, size: 16),
          const SizedBox(width: 8),
          SizedBox(
            width: 160,
            child: Text(
              command,
              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
            ),
          ),
          Expanded(child: Text(meaning)),
        ],
      ),
    );
  }
}

class CraneSignal {
  final String name;
  final String description;
  final String gesture;
  final Color color;

  const CraneSignal({
    required this.name,
    required this.description,
    required this.gesture,
    required this.color,
  });
}
