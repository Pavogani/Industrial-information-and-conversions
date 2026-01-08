import 'package:flutter/material.dart';
import '../../core/models/rigging_data.dart';

class SlingWllScreen extends StatefulWidget {
  const SlingWllScreen({super.key});

  @override
  State<SlingWllScreen> createState() => _SlingWllScreenState();
}

class _SlingWllScreenState extends State<SlingWllScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sling WLL Tables'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Wire Rope'),
            Tab(text: 'Chain'),
            Tab(text: 'Synthetic'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WireRopeTab(),
          _ChainTab(),
          _SyntheticTab(),
        ],
      ),
    );
  }
}

class _WireRopeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Info
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
                  '6x19 IWRC Wire Rope Slings - Working Load Limit (lbs)',
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  'Dia.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              _TableHeader(label: 'Vertical'),
              _TableHeader(label: 'Choker'),
              _TableHeader(label: '60°'),
              _TableHeader(label: '45°'),
            ],
          ),
        ),

        // Table Body
        Expanded(
          child: ListView.builder(
            itemCount: wireRopeSlings.length,
            itemBuilder: (context, index) {
              final sling = wireRopeSlings[index];
              final isEven = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: isEven
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${sling.diameter}"',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _TableCell(value: sling.verticalWll),
                    _TableCell(value: sling.chokerWll),
                    _TableCell(value: sling.basket60Wll),
                    _TableCell(value: sling.basket45Wll),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChainTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Info
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
                  'Alloy Steel Chain Slings - Single Leg Vertical WLL (lbs)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Grade Legend
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GradeBadge(label: 'Grade 80', color: Colors.blue),
              const SizedBox(width: 16),
              _GradeBadge(label: 'Grade 100', color: Colors.purple),
            ],
          ),
        ),

        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Chain Size',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Grade 80',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Grade 100',
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

        // Table Body
        Expanded(
          child: ListView.builder(
            itemCount: chainSlings.length,
            itemBuilder: (context, index) {
              final chain = chainSlings[index];
              final isEven = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: isEven
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${chain.size}"',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatWeight(chain.gradeWll80),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatWeight(chain.gradeWll100),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.purple.shade700),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Angle Factors Card
        Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Multi-Leg Angle Factors',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _AngleFactor(angle: 60, factor: 0.866),
                    _AngleFactor(angle: 45, factor: 0.707),
                    _AngleFactor(angle: 30, factor: 0.500),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatWeight(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _SyntheticTab extends StatefulWidget {
  @override
  State<_SyntheticTab> createState() => _SyntheticTabState();
}

class _SyntheticTabState extends State<_SyntheticTab> {
  int _selectedPly = 1;

  List<SyntheticSling> get filteredSlings =>
      syntheticSlings.where((s) => s.ply == _selectedPly).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Info
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
                  'Nylon Web Slings Type 3 (Eye & Eye) - WLL (lbs)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Ply Selector
        Padding(
          padding: const EdgeInsets.all(12),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('Single Ply')),
              ButtonSegment(value: 2, label: Text('Double Ply')),
            ],
            selected: {_selectedPly},
            onSelectionChanged: (selection) {
              setState(() => _selectedPly = selection.first);
            },
          ),
        ),

        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  'Width',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Vertical',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Choker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Basket',
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

        // Table Body
        Expanded(
          child: ListView.builder(
            itemCount: filteredSlings.length,
            itemBuilder: (context, index) {
              final sling = filteredSlings[index];
              final isEven = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: isEven
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${sling.width}"',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatWeight(sling.verticalWll),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatWeight(sling.chokerWll),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatWeight(sling.basketWll),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Warning Card
        Card(
          margin: const EdgeInsets.all(12),
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Protect synthetic slings from sharp edges, heat, and chemicals.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatWeight(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _TableHeader extends StatelessWidget {
  final String label;

  const _TableHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final double value;

  const _TableCell({required this.value});

  @override
  Widget build(BuildContext context) {
    String formatted;
    if (value >= 1000) {
      formatted = '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      formatted = value.toStringAsFixed(0);
    }

    return Expanded(
      child: Text(
        formatted,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _GradeBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AngleFactor extends StatelessWidget {
  final int angle;
  final double factor;

  const _AngleFactor({required this.angle, required this.factor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$angle°',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'x ${factor.toStringAsFixed(3)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
