import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/conversion_provider.dart';
import '../../core/services/conversion_service.dart';

class QuickConversionScreen extends ConsumerStatefulWidget {
  const QuickConversionScreen({super.key});

  @override
  ConsumerState<QuickConversionScreen> createState() =>
      _QuickConversionScreenState();
}

class _QuickConversionScreenState extends ConsumerState<QuickConversionScreen>
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
        title: const Text('Quick Conversion'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.straighten), text: 'Length'),
            Tab(icon: Icon(Icons.rotate_right), text: 'Torque'),
            Tab(icon: Icon(Icons.thermostat), text: 'Temp'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LengthConversionTab(),
          TorqueConversionTab(),
          TemperatureConversionTab(),
        ],
      ),
    );
  }
}

class LengthConversionTab extends ConsumerStatefulWidget {
  const LengthConversionTab({super.key});

  @override
  ConsumerState<LengthConversionTab> createState() =>
      _LengthConversionTabState();
}

class _LengthConversionTabState extends ConsumerState<LengthConversionTab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lengthConversionProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter value',
                      suffix: Text(state.fromUnit.abbreviation),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0;
                      ref
                          .read(lengthConversionProvider.notifier)
                          .setInputValue(parsed);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownMenu<LengthUnit>(
                    initialSelection: state.fromUnit,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: LengthUnit.values.map((unit) {
                      return DropdownMenuEntry(
                        value: unit,
                        label: unit.displayName,
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        ref
                            .read(lengthConversionProvider.notifier)
                            .setFromUnit(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: IconButton.filled(
              icon: const Icon(Icons.swap_vert),
              onPressed: () {
                ref.read(lengthConversionProvider.notifier).swapUnits();
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('To', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      '${state.result.toStringAsFixed(4)} ${state.toUnit.abbreviation}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownMenu<LengthUnit>(
                    initialSelection: state.toUnit,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: LengthUnit.values.map((unit) {
                      return DropdownMenuEntry(
                        value: unit,
                        label: unit.displayName,
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        ref
                            .read(lengthConversionProvider.notifier)
                            .setToUnit(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TorqueConversionTab extends ConsumerStatefulWidget {
  const TorqueConversionTab({super.key});

  @override
  ConsumerState<TorqueConversionTab> createState() =>
      _TorqueConversionTabState();
}

class _TorqueConversionTabState extends ConsumerState<TorqueConversionTab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(torqueConversionProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter value',
                      suffix: Text(state.fromUnit.abbreviation),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0;
                      ref
                          .read(torqueConversionProvider.notifier)
                          .setInputValue(parsed);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownMenu<TorqueUnit>(
                    initialSelection: state.fromUnit,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: TorqueUnit.values.map((unit) {
                      return DropdownMenuEntry(
                        value: unit,
                        label: unit.displayName,
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        ref
                            .read(torqueConversionProvider.notifier)
                            .setFromUnit(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: IconButton.filled(
              icon: const Icon(Icons.swap_vert),
              onPressed: () {
                ref.read(torqueConversionProvider.notifier).swapUnits();
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('To', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      '${state.result.toStringAsFixed(4)} ${state.toUnit.abbreviation}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownMenu<TorqueUnit>(
                    initialSelection: state.toUnit,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: TorqueUnit.values.map((unit) {
                      return DropdownMenuEntry(
                        value: unit,
                        label: unit.displayName,
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        ref
                            .read(torqueConversionProvider.notifier)
                            .setToUnit(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TemperatureConversionTab extends ConsumerStatefulWidget {
  const TemperatureConversionTab({super.key});

  @override
  ConsumerState<TemperatureConversionTab> createState() =>
      _TemperatureConversionTabState();
}

class _TemperatureConversionTabState
    extends ConsumerState<TemperatureConversionTab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(temperatureConversionProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter value',
                      suffix: Text(state.fromUnit.abbreviation),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0;
                      ref
                          .read(temperatureConversionProvider.notifier)
                          .setInputValue(parsed);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownMenu<TemperatureUnit>(
                    initialSelection: state.fromUnit,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: TemperatureUnit.values.map((unit) {
                      return DropdownMenuEntry(
                        value: unit,
                        label: unit.displayName,
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        ref
                            .read(temperatureConversionProvider.notifier)
                            .setFromUnit(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: IconButton.filled(
              icon: const Icon(Icons.swap_vert),
              onPressed: () {
                ref.read(temperatureConversionProvider.notifier).swapUnits();
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('To', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      '${state.result.toStringAsFixed(2)} ${state.toUnit.abbreviation}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownMenu<TemperatureUnit>(
                    initialSelection: state.toUnit,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: TemperatureUnit.values.map((unit) {
                      return DropdownMenuEntry(
                        value: unit,
                        label: unit.displayName,
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        ref
                            .read(temperatureConversionProvider.notifier)
                            .setToUnit(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
