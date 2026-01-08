import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/search_index.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<SearchItem> _results = [];
  bool _showRecent = true;

  // Recent searches (in a real app, persist with shared_preferences)
  final List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _showRecent = query.isEmpty;
      _results = searchFeatures(query);
    });
  }

  void _addToRecent(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _navigateTo(SearchItem item) {
    _addToRecent(_searchController.text);
    context.push(item.route);
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'swap_horiz': return Icons.swap_horiz;
      case 'hardware': return Icons.hardware;
      case 'architecture': return Icons.architecture;
      case 'sync': return Icons.sync;
      case 'speed': return Icons.speed;
      case 'compress': return Icons.compress;
      case 'content_cut': return Icons.content_cut;
      case 'stairs': return Icons.stairs;
      case 'linear_scale': return Icons.linear_scale;
      case 'circle_outlined': return Icons.circle_outlined;
      case 'settings': return Icons.settings;
      case 'electrical_services': return Icons.electrical_services;
      case 'thermostat': return Icons.thermostat;
      case 'conveyor_belt': return Icons.conveyor_belt;
      case 'water_drop': return Icons.water_drop;
      case 'pie_chart_outline': return Icons.pie_chart_outline;
      case 'build_circle_outlined': return Icons.build_circle_outlined;
      case 'plumbing': return Icons.plumbing;
      case 'view_column': return Icons.view_column;
      case 'panorama_fish_eye': return Icons.panorama_fish_eye;
      case 'diamond': return Icons.diamond;
      case 'cable': return Icons.cable;
      case 'construction': return Icons.construction;
      case 'electric_bolt': return Icons.electric_bolt;
      case 'local_fire_department': return Icons.local_fire_department;
      case 'straighten': return Icons.straighten;
      case 'opacity': return Icons.opacity;
      case 'compare_arrows': return Icons.compare_arrows;
      case 'link': return Icons.link;
      case 'fitness_center': return Icons.fitness_center;
      case 'calculate': return Icons.calculate;
      default: return Icons.help_outline;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Convert': return Colors.blue;
      case 'Fasteners': return Colors.grey;
      case 'Calculators': return Colors.green;
      case 'Reference': return Colors.purple;
      case 'Welding': return Colors.orange;
      case 'Rigging': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search tools, calculators, references...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch('');
                    },
                  )
                : null,
          ),
          onChanged: _onSearch,
          textInputAction: TextInputAction.search,
        ),
      ),
      body: _showRecent ? _buildQuickAccess() : _buildResults(),
    );
  }

  Widget _buildQuickAccess() {
    final categories = [
      ('Calculators', Icons.calculate, Colors.green, '/calculators'),
      ('Reference', Icons.menu_book, Colors.purple, '/reference'),
      ('Welding', Icons.local_fire_department, Colors.orange, '/welding'),
      ('Rigging', Icons.fitness_center, Colors.red, '/rigging'),
      ('Fasteners', Icons.hardware, Colors.grey, '/fasteners'),
      ('Convert', Icons.swap_horiz, Colors.blue, '/conversion'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Categories
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return InkWell(
              onTap: () => context.push(cat.$4),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: cat.$3.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cat.$3.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cat.$2, color: cat.$3, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      cat.$1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cat.$3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => setState(() => _recentSearches.clear()),
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((search) {
              return ActionChip(
                label: Text(search),
                avatar: const Icon(Icons.history, size: 16),
                onPressed: () {
                  _searchController.text = search;
                  _onSearch(search);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Popular Searches
        Text(
          'Popular Searches',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'torque',
            'tap drill',
            '7018',
            'belt length',
            'alignment',
            'hydraulic',
            'pump',
            'pipe',
          ].map((search) {
            return ActionChip(
              label: Text(search),
              onPressed: () {
                _searchController.text = search;
                _onSearch(search);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    final grouped = groupByCategory(_results);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final category = grouped.keys.elementAt(index);
        final items = grouped[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoryColor(category).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getCategoryColor(category),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => _SearchResultTile(
                  item: item,
                  icon: _getIcon(item.icon),
                  color: _getCategoryColor(item.category),
                  onTap: () => _navigateTo(item),
                )),
          ],
        );
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final SearchItem item;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.item,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          item.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
