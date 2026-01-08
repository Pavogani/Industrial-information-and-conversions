import 'package:flutter/material.dart';
import '../../core/models/lubricant_data.dart';

class LubricantScreen extends StatefulWidget {
  const LubricantScreen({super.key});

  @override
  State<LubricantScreen> createState() => _LubricantScreenState();
}

class _LubricantScreenState extends State<LubricantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _categoryFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<LubricantType> get filteredLubricants {
    if (_categoryFilter == 'all') return lubricants;
    return lubricants.where((l) => l.category == _categoryFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lubricant Guide'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Types'),
            Tab(text: 'Compatibility'),
            Tab(text: 'Grades'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TypesTab(
            categoryFilter: _categoryFilter,
            onFilterChanged: (v) => setState(() => _categoryFilter = v),
            filteredLubricants: filteredLubricants,
          ),
          _CompatibilityTab(),
          _GradesTab(),
        ],
      ),
    );
  }
}

class _TypesTab extends StatelessWidget {
  final String categoryFilter;
  final ValueChanged<String> onFilterChanged;
  final List<LubricantType> filteredLubricants;

  const _TypesTab({
    required this.categoryFilter,
    required this.onFilterChanged,
    required this.filteredLubricants,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                selected: categoryFilter == 'all',
                onTap: () => onFilterChanged('all'),
              ),
              _FilterChip(
                label: 'Oils',
                selected: categoryFilter == 'oil',
                onTap: () => onFilterChanged('oil'),
                color: Colors.amber,
              ),
              _FilterChip(
                label: 'Greases',
                selected: categoryFilter == 'grease',
                onTap: () => onFilterChanged('grease'),
                color: Colors.brown,
              ),
              _FilterChip(
                label: 'Specialty',
                selected: categoryFilter == 'specialty',
                onTap: () => onFilterChanged('specialty'),
                color: Colors.purple,
              ),
            ],
          ),
        ),

        // Lubricant List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredLubricants.length,
            itemBuilder: (context, index) {
              return _LubricantCard(lubricant: filteredLubricants[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: color?.withValues(alpha: 0.3),
      ),
    );
  }
}

class _LubricantCard extends StatelessWidget {
  final LubricantType lubricant;

  const _LubricantCard({required this.lubricant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(lubricant.category),
          child: Icon(
            _getCategoryIcon(lubricant.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          lubricant.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          lubricant.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temp Range
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.thermostat, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        lubricant.tempRange,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Applications
                Text(
                  'Applications:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.green.shade700,
                      ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: lubricant.applications
                      .map((a) => Chip(
                            label: Text(a, style: const TextStyle(fontSize: 11)),
                            backgroundColor: Colors.green.shade50,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Not For
                if (lubricant.notFor.isNotEmpty) ...[
                  Text(
                    'Not Recommended For:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.red.shade700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  ...lubricant.notFor.map((n) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2),
                        child: Row(
                          children: [
                            Icon(Icons.close, size: 14, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(child: Text(n)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                ],

                // Notes
                if (lubricant.notes.isNotEmpty) ...[
                  Text(
                    'Notes:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  ...lubricant.notes.map((note) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                size: 14, color: Theme.of(context).colorScheme.outline),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                note,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'oil':
        return Colors.amber.shade700;
      case 'grease':
        return Colors.brown;
      case 'specialty':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'oil':
        return Icons.water_drop;
      case 'grease':
        return Icons.opacity;
      case 'specialty':
        return Icons.science;
      default:
        return Icons.help;
    }
  }
}

class _CompatibilityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final greaseTypes = ['Lithium', 'Lithium Complex', 'Polyurea', 'Calcium Sulfonate'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Card
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mixing incompatible greases can cause complete lubrication failure. When in doubt, purge old grease completely.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Grease Compatibility Chart',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),

          // Compatibility Matrix
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: [
                  const DataColumn(label: Text('')),
                  ...greaseTypes.map((t) => DataColumn(
                        label: RotatedBox(
                          quarterTurns: -1,
                          child: Text(t, style: const TextStyle(fontSize: 11)),
                        ),
                      )),
                ],
                rows: greaseTypes.map((rowType) {
                  return DataRow(
                    cells: [
                      DataCell(Text(rowType, style: const TextStyle(fontWeight: FontWeight.w600))),
                      ...greaseTypes.map((colType) {
                        final compat = greaseCompatibility[rowType]?[colType] ?? 'Unknown';
                        return DataCell(_CompatibilityIcon(compatibility: compat));
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _LegendItem(icon: Icons.check_circle, color: Colors.green, label: 'Compatible'),
              _LegendItem(icon: Icons.help, color: Colors.orange, label: 'Borderline'),
              _LegendItem(icon: Icons.cancel, color: Colors.red, label: 'Incompatible'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompatibilityIcon extends StatelessWidget {
  final String compatibility;

  const _CompatibilityIcon({required this.compatibility});

  @override
  Widget build(BuildContext context) {
    switch (compatibility) {
      case 'Compatible':
        return const Icon(Icons.check_circle, color: Colors.green, size: 20);
      case 'Borderline':
        return const Icon(Icons.help, color: Colors.orange, size: 20);
      case 'Incompatible':
        return const Icon(Icons.cancel, color: Colors.red, size: 20);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey, size: 20);
    }
  }
}

class _LegendItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _LegendItem({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _GradesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // NLGI Grades
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NLGI Grease Grades',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'National Lubricating Grease Institute consistency grades',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Divider(),
                ...nlgiGrades.entries.map((e) => _GradeRow(
                      grade: 'NLGI ${e.key}',
                      description: e.value,
                      highlight: e.key == '2',
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ISO VG Grades
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ISO Viscosity Grades',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Kinematic viscosity at 40°C (cSt)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Divider(),
                ...isoViscosityGrades.entries.map((e) => _ViscosityRow(
                      grade: e.key,
                      min: e.value['min']!,
                      max: e.value['max']!,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GradeRow extends StatelessWidget {
  final String grade;
  final String description;
  final bool highlight;

  const _GradeRow({
    required this.grade,
    required this.description,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: highlight
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              grade,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(description)),
          if (highlight)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'COMMON',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ViscosityRow extends StatelessWidget {
  final String grade;
  final double min;
  final double max;

  const _ViscosityRow({required this.grade, required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              grade,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text('${min.toStringAsFixed(1)} - ${max.toStringAsFixed(1)} cSt'),
          ),
        ],
      ),
    );
  }
}
