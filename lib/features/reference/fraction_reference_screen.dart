import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/fraction_data.dart';

// Provider for search query
final fractionSearchProvider = StateProvider<String>((ref) => '');

// Provider for filtered fractions
final filteredFractionsProvider = Provider<List<FractionData>>((ref) {
  final query = ref.watch(fractionSearchProvider);
  return searchFractions(query);
});

class FractionReferenceScreen extends ConsumerStatefulWidget {
  const FractionReferenceScreen({super.key});

  @override
  ConsumerState<FractionReferenceScreen> createState() =>
      _FractionReferenceScreenState();
}

class _FractionReferenceScreenState
    extends ConsumerState<FractionReferenceScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fractions = ref.watch(filteredFractionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fraction Reference'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search fractions, decimals, or mm...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(fractionSearchProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(fractionSearchProvider.notifier).state = value;
              },
            ),
          ),
          // Table Header
          Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Fraction',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Decimal',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Millimeters',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Table Body
          Expanded(
            child: fractions.isEmpty
                ? Center(
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
                          'No matching fractions found',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: fractions.length,
                    itemBuilder: (context, index) {
                      final fraction = fractions[index];
                      final isEven = index % 2 == 0;
                      return Container(
                        color: isEven
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.surfaceContainerLow,
                        child: InkWell(
                          onTap: () => _showDetailDialog(context, fraction),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    fraction.fraction,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    fraction.decimal.toStringAsFixed(4),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${fraction.millimeters.toStringAsFixed(3)} mm',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, FractionData fraction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fraction.fraction),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: 'Fraction', value: fraction.fraction),
            _DetailRow(
                label: 'Decimal (in)', value: fraction.decimal.toStringAsFixed(4)),
            _DetailRow(
                label: 'Millimeters',
                value: '${fraction.millimeters.toStringAsFixed(3)} mm'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
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
