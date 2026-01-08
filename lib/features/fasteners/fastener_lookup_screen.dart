import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/fastener_provider.dart';
import '../../core/providers/favorites_provider.dart';

class FastenerLookupScreen extends ConsumerWidget {
  const FastenerLookupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boltDiameters = ref.watch(boltDiametersProvider);
    final selectedBolt = ref.watch(selectedBoltProvider);
    final isHeavyHex = ref.watch(hexTypeProvider);
    final fastener = ref.watch(selectedFastenerProvider);
    final wrenchSize = ref.watch(wrenchSizeProvider);
    final favorites = ref.watch(favoritesProvider);

    final isFavorite = selectedBolt != null && favorites.contains(selectedBolt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fastener Lookup'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (selectedBolt != null)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : null,
              ),
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(selectedBolt);
              },
              tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Favorites Quick Access
            if (favorites.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Favorites',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: favorites.map((diameter) {
                          final isSelected = diameter == selectedBolt;
                          return ActionChip(
                            label: Text(diameter),
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            onPressed: () {
                              ref.read(selectedBoltProvider.notifier).select(diameter);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Hex Type Toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hex Type',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('Standard Hex'),
                          icon: Icon(Icons.hexagon_outlined),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text('Heavy Hex'),
                          icon: Icon(Icons.hexagon),
                        ),
                      ],
                      selected: {isHeavyHex},
                      onSelectionChanged: (selection) {
                        ref
                            .read(hexTypeProvider.notifier)
                            .setHeavyHex(selection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bolt Diameter Dropdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bolt Diameter',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<String>(
                      initialSelection: selectedBolt,
                      hintText: 'Select bolt diameter',
                      expandedInsets: EdgeInsets.zero,
                      dropdownMenuEntries: boltDiameters.map((diameter) {
                        final isFav = favorites.contains(diameter);
                        return DropdownMenuEntry(
                          value: diameter,
                          label: diameter,
                          trailingIcon: isFav
                              ? const Icon(Icons.star, color: Colors.amber, size: 16)
                              : null,
                        );
                      }).toList(),
                      onSelected: (value) {
                        ref.read(selectedBoltProvider.notifier).select(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results Card
            if (fastener != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Required Wrench Size',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wrenchSize ?? '-',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                      Text(
                        isHeavyHex ? '(Heavy Hex)' : '(Standard Hex)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Additional Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Divider(),
                      _InfoRow(
                        label: 'Decimal Equivalent',
                        value: '${fastener.decimalEquivalent}"',
                      ),
                      _InfoRow(
                        label: 'Metric Equivalent',
                        value: '${fastener.metricEquivalent.toStringAsFixed(2)} mm',
                      ),
                      _InfoRow(
                        label: 'Tap Drill Size',
                        value: fastener.tapDrillSize,
                      ),
                      _InfoRow(
                        label: 'Threads/Inch (Coarse)',
                        value: fastener.threadsPerInchCoarse.toString(),
                      ),
                      if (fastener.threadsPerInchFine > 0)
                        _InfoRow(
                          label: 'Threads/Inch (Fine)',
                          value: fastener.threadsPerInchFine.toString(),
                        ),
                    ],
                  ),
                ),
              ),
            ] else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select a bolt diameter to see specifications',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
