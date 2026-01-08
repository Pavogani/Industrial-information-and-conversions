import 'package:flutter/material.dart';
import '../../core/models/oring_data.dart';

class ORingScreen extends StatefulWidget {
  const ORingScreen({super.key});

  @override
  State<ORingScreen> createState() => _ORingScreenState();
}

class _ORingScreenState extends State<ORingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _showMetric = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ORingSize> get filteredSizes {
    if (_searchQuery.isEmpty) return oRingSizes;
    return oRingSizes
        .where((o) => o.dashNumber.contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O-Ring Reference'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showMetric ? Icons.straighten : Icons.square_foot),
            tooltip: _showMetric ? 'Show Imperial' : 'Show Metric',
            onPressed: () => setState(() => _showMetric = !_showMetric),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sizes (AS568)'),
            Tab(text: 'Materials'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SizesTab(
            searchQuery: _searchQuery,
            onSearchChanged: (v) => setState(() => _searchQuery = v),
            filteredSizes: filteredSizes,
            showMetric: _showMetric,
          ),
          _MaterialsTab(),
        ],
      ),
    );
  }
}

class _SizesTab extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final List<ORingSize> filteredSizes;
  final bool showMetric;

  const _SizesTab({
    required this.searchQuery,
    required this.onSearchChanged,
    required this.filteredSizes,
    required this.showMetric,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search by dash number (e.g., -210)',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: onSearchChanged,
          ),
        ),

        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Dash #',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'ID',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'CS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'OD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Size List
        Expanded(
          child: ListView.builder(
            itemCount: filteredSizes.length,
            itemBuilder: (context, index) {
              final oring = filteredSizes[index];
              final isEven = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: isEven
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        oring.dashNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        showMetric
                            ? oring.idMm.toStringAsFixed(2)
                            : oring.idInches.toStringAsFixed(3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        showMetric
                            ? oring.csMm.toStringAsFixed(2)
                            : oring.csInches.toStringAsFixed(3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        showMetric
                            ? oring.odMm.toStringAsFixed(2)
                            : oring.odInches.toStringAsFixed(3),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Units Legend
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showMetric ? 'Dimensions in mm' : 'Dimensions in inches',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Text(
                'ID = Inside Dia. • CS = Cross-Section • OD = Outside Dia.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MaterialsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info Card
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
                    'Select material based on chemical compatibility, temperature range, and application requirements.',
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

        // Material Cards
        ...oRingMaterials.map((material) => _MaterialCard(material: material)),
      ],
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final ORingMaterial material;

  const _MaterialCard({required this.material});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            material.code.substring(0, 2),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          material.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.thermostat, size: 14, color: Theme.of(context).colorScheme.outline),
            const SizedBox(width: 4),
            Text(
              '${material.minTemp}°F to ${material.maxTemp}°F',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compatible With:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.green.shade700,
                      ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: material.compatible
                      .map((c) => Chip(
                            label: Text(c, style: const TextStyle(fontSize: 11)),
                            backgroundColor: Colors.green.shade50,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Not Recommended For:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.red.shade700,
                      ),
                ),
                const SizedBox(height: 4),
                ...material.notFor.map((n) => Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Row(
                        children: [
                          Icon(Icons.close, size: 14, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text(n),
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
