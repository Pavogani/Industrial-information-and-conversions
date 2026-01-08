import 'package:flutter/material.dart';
import '../../core/models/pipe_schedule_data.dart';

class PipeScheduleScreen extends StatefulWidget {
  const PipeScheduleScreen({super.key});

  @override
  State<PipeScheduleScreen> createState() => _PipeScheduleScreenState();
}

class _PipeScheduleScreenState extends State<PipeScheduleScreen> {
  String _selectedSchedule = '40';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pipe Schedule Chart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Schedule Selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Schedule: ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: '40', label: Text('Sch 40')),
                    ButtonSegment(value: '80', label: Text('Sch 80')),
                    ButtonSegment(value: '160', label: Text('Sch 160')),
                  ],
                  selected: {_selectedSchedule},
                  onSelectionChanged: (selection) {
                    setState(() => _selectedSchedule = selection.first);
                  },
                ),
              ],
            ),
          ),

          // Info Banner
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Standard pipe OD is constant per nominal size. Schedule determines wall thickness.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                _HeaderCell(label: 'Nom.', flex: 2),
                _HeaderCell(label: 'OD'),
                _HeaderCell(label: 'Wall'),
                _HeaderCell(label: 'ID'),
                _HeaderCell(label: 'lb/ft'),
              ],
            ),
          ),

          // Data List
          Expanded(
            child: ListView.builder(
              itemCount: pipeSchedules.length,
              itemBuilder: (context, index) {
                final pipe = pipeSchedules[index];
                final wall = pipe.schedules[_selectedSchedule];

                if (wall == null) {
                  // Schedule not available for this size
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    color: index % 2 == 0
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.surfaceContainerLowest,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${pipe.nominalSize}"',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(pipe.od.toStringAsFixed(3)),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'N/A for this schedule',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final id = pipe.getID(_selectedSchedule);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: index % 2 == 0
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.surfaceContainerLowest,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${pipe.nominalSize}"',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(pipe.od.toStringAsFixed(3)),
                      ),
                      Expanded(
                        child: Text(wall.wallThickness.toStringAsFixed(3)),
                      ),
                      Expanded(
                        child: Text(
                          id.toStringAsFixed(3),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(wall.weightPerFoot.toStringAsFixed(1)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Legend Card
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _LegendItem(label: 'OD', description: 'Outside Dia.'),
                  _LegendItem(label: 'Wall', description: 'Wall Thick.'),
                  _LegendItem(label: 'ID', description: 'Inside Dia.'),
                  _LegendItem(label: 'lb/ft', description: 'Weight/ft'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const _HeaderCell({required this.label, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final String description;

  const _LegendItem({required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
