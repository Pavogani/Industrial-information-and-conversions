import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/torque_spec_data.dart';

final selectedBoltSizeProvider = StateProvider<String?>((ref) => null);
final selectedBoltGradeProvider =
    StateProvider<BoltGrade>((ref) => BoltGrade.grade5);
final isLubricatedProvider = StateProvider<bool>((ref) => false);

class TorqueSpecScreen extends ConsumerWidget {
  const TorqueSpecScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(selectedBoltSizeProvider);
    final selectedGrade = ref.watch(selectedBoltGradeProvider);
    final isLubed = ref.watch(isLubricatedProvider);
    final boltSizes = getAllTorqueBoltSizes();

    TorqueSpec? spec;
    if (selectedSize != null) {
      spec = findTorqueSpec(selectedSize);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Torque Specifications'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Grade Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bolt Grade',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<BoltGrade>(
                      initialSelection: selectedGrade,
                      expandedInsets: EdgeInsets.zero,
                      dropdownMenuEntries: BoltGrade.values.map((grade) {
                        return DropdownMenuEntry(
                          value: grade,
                          label: grade.displayName,
                        );
                      }).toList(),
                      onSelected: (value) {
                        if (value != null) {
                          ref.read(selectedBoltGradeProvider.notifier).state =
                              value;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedGrade.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    Text(
                      'Tensile Strength: ${selectedGrade.tensileStrengthPsi.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} PSI',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bolt Size Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bolt Size',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<String>(
                      initialSelection: selectedSize,
                      hintText: 'Select bolt size',
                      expandedInsets: EdgeInsets.zero,
                      dropdownMenuEntries: boltSizes.map((size) {
                        return DropdownMenuEntry(
                          value: size,
                          label: size,
                        );
                      }).toList(),
                      onSelected: (value) {
                        ref.read(selectedBoltSizeProvider.notifier).state =
                            value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Condition Toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thread Condition',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('Dry'),
                          icon: Icon(Icons.wb_sunny_outlined),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text('Lubricated'),
                          icon: Icon(Icons.water_drop_outlined),
                        ),
                      ],
                      selected: {isLubed},
                      onSelectionChanged: (selection) {
                        ref.read(isLubricatedProvider.notifier).state =
                            selection.first;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLubed
                          ? 'Use ~75% of dry torque for lubricated threads'
                          : 'For clean, dry threads without anti-seize',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results
            if (spec != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Recommended Torque',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${(isLubed ? spec.torqueValues[selectedGrade]!.lubedFtLbs : spec.torqueValues[selectedGrade]!.dryFtLbs).toStringAsFixed(0)} ft-lbs',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                      Text(
                        '${spec.boltSize} ${selectedGrade.displayName} - ${isLubed ? "Lubricated" : "Dry"}',
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

              // All grades comparison for this size
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Grades - ${spec.boltSize} (${isLubed ? "Lubed" : "Dry"})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Divider(),
                      ...BoltGrade.values.map((grade) {
                        final torque = spec!.torqueValues[grade];
                        final value =
                            isLubed ? torque!.lubedFtLbs : torque!.dryFtLbs;
                        final isSelected = grade == selectedGrade;
                        return Container(
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.3)
                              : null,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                grade.displayName,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              Text(
                                '${value.toStringAsFixed(0)} ft-lbs',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
                        Icons.build_circle_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select a bolt size to see torque specifications',
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
