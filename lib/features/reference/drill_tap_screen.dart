import 'package:flutter/material.dart';
import '../../core/models/drill_tap_data.dart';

class DrillTapScreen extends StatefulWidget {
  const DrillTapScreen({super.key});

  @override
  State<DrillTapScreen> createState() => _DrillTapScreenState();
}

class _DrillTapScreenState extends State<DrillTapScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drill & Tap Chart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Drills'),
            Tab(text: 'UNC'),
            Tab(text: 'UNF'),
            Tab(text: 'Metric'),
            Tab(text: 'NPT'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search drill or thread size...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _DrillSizesTab(searchQuery: _searchQuery),
                _TapDrillTab(
                  title: 'UNC (Coarse Thread)',
                  data: uncTapDrills,
                  searchQuery: _searchQuery,
                  pitchLabel: 'TPI',
                ),
                _TapDrillTab(
                  title: 'UNF (Fine Thread)',
                  data: unfTapDrills,
                  searchQuery: _searchQuery,
                  pitchLabel: 'TPI',
                ),
                _MetricTapTab(searchQuery: _searchQuery),
                _TapDrillTab(
                  title: 'NPT (Pipe Thread)',
                  data: nptTapDrills,
                  searchQuery: _searchQuery,
                  pitchLabel: 'TPI',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrillSizesTab extends StatelessWidget {
  final String searchQuery;

  const _DrillSizesTab({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final filteredNumber = numberDrills.where((d) =>
        d.designation.toLowerCase().contains(searchQuery) ||
        d.diameter.toString().contains(searchQuery)).toList();

    final filteredLetter = letterDrills.where((d) =>
        d.designation.toLowerCase().contains(searchQuery) ||
        d.diameter.toString().contains(searchQuery)).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Info Card
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Number drills: #80 (smallest) to #1\nLetter drills: A (smallest) to Z',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Number Drills Section
        if (filteredNumber.isNotEmpty) ...[
          Text(
            'Number Drills',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 2, child: Text('Drill', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('Inch', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('mm', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                ...filteredNumber.map((drill) => _DrillRow(drill: drill)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Letter Drills Section
        if (filteredLetter.isNotEmpty) ...[
          Text(
            'Letter Drills',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 2, child: Text('Drill', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('Inch', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('mm', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                ...filteredLetter.map((drill) => _DrillRow(drill: drill)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _DrillRow extends StatelessWidget {
  final DrillSize drill;

  const _DrillRow({required this.drill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              drill.designation,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(drill.diameter.toStringAsFixed(4)),
          ),
          Expanded(
            flex: 3,
            child: Text(drill.diameterMm.toStringAsFixed(3)),
          ),
        ],
      ),
    );
  }
}

class _TapDrillTab extends StatelessWidget {
  final String title;
  final List<TapDrillInfo> data;
  final String searchQuery;
  final String pitchLabel;

  const _TapDrillTab({
    required this.title,
    required this.data,
    required this.searchQuery,
    required this.pitchLabel,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = data.where((t) =>
        t.threadSize.toLowerCase().contains(searchQuery) ||
        t.tapDrill.toLowerCase().contains(searchQuery)).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text('No results for "$searchQuery"'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...filtered.map((tap) => _TapDrillCard(tap: tap, pitchLabel: pitchLabel)),
      ],
    );
  }
}

class _TapDrillCard extends StatelessWidget {
  final TapDrillInfo tap;
  final String pitchLabel;

  const _TapDrillCard({required this.tap, required this.pitchLabel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tap.threadSize,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${tap.pitch} $pitchLabel',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoBox(
                    label: 'Tap Drill',
                    value: tap.tapDrill,
                    subValue: '(${tap.tapDrillDecimal.toStringAsFixed(4)}")',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InfoBox(
                    label: 'Close Fit',
                    value: tap.clearanceDrillClose,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InfoBox(
                    label: 'Free Fit',
                    value: tap.clearanceDrillFree,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final Color color;

  const _InfoBox({
    required this.label,
    required this.value,
    this.subValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          if (subValue != null)
            Text(
              subValue!,
              style: TextStyle(
                fontSize: 9,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricTapTab extends StatelessWidget {
  final String searchQuery;

  const _MetricTapTab({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final filteredCoarse = metricTapDrills.where((t) =>
        t.threadSize.toLowerCase().contains(searchQuery) ||
        t.tapDrill.toLowerCase().contains(searchQuery)).toList();

    final filteredFine = metricFineTapDrills.where((t) =>
        t.threadSize.toLowerCase().contains(searchQuery) ||
        t.tapDrill.toLowerCase().contains(searchQuery)).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Coarse Thread
        if (filteredCoarse.isNotEmpty) ...[
          Text(
            'Metric Coarse (Standard)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...filteredCoarse.map((tap) => _TapDrillCard(tap: tap, pitchLabel: 'mm')),
          const SizedBox(height: 16),
        ],

        // Fine Thread
        if (filteredFine.isNotEmpty) ...[
          Text(
            'Metric Fine',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...filteredFine.map((tap) => _TapDrillCard(tap: tap, pitchLabel: 'mm')),
        ],
      ],
    );
  }
}
