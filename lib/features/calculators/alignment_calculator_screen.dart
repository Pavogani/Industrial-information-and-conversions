import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/alignment_provider.dart';

class AlignmentCalculatorScreen extends ConsumerWidget {
  const AlignmentCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alignmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shaft Alignment'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(alignmentProvider.notifier).reset(),
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Machine Setup Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Machine Setup',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            label: 'Dial Spacing (in)',
                            value: state.dialSpacing,
                            onChanged: (v) => ref
                                .read(alignmentProvider.notifier)
                                .setDialSpacing(v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            label: 'Front Foot Dist (in)',
                            value: state.frontFootDistance,
                            onChanged: (v) => ref
                                .read(alignmentProvider.notifier)
                                .setFrontFootDistance(v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _NumberField(
                            label: 'Back Foot Dist (in)',
                            value: state.backFootDistance,
                            onChanged: (v) => ref
                                .read(alignmentProvider.notifier)
                                .setBackFootDistance(v),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stationary Machine Readings
            _DialReadingCard(
              title: 'Stationary Machine Readings',
              subtitle: 'Indicator mounted on movable, reading stationary',
              reading: state.stationaryReading,
              onTopChanged: (v) =>
                  ref.read(alignmentProvider.notifier).setStationaryTop(v),
              onBottomChanged: (v) =>
                  ref.read(alignmentProvider.notifier).setStationaryBottom(v),
              onLeftChanged: (v) =>
                  ref.read(alignmentProvider.notifier).setStationaryLeft(v),
              onRightChanged: (v) =>
                  ref.read(alignmentProvider.notifier).setStationaryRight(v),
            ),
            const SizedBox(height: 16),

            // Movable Machine Readings
            _DialReadingCard(
              title: 'Movable Machine Readings',
              subtitle: 'Indicator mounted on stationary, reading movable',
              reading: state.movableReading,
              onTopChanged: (v) =>
                  ref.read(alignmentProvider.notifier).setMovableTop(v),
              onBottomChanged: (v) =>
                  ref.read(alignmentProvider.notifier).setMovableBottom(v),
              onLeftChanged: (v) =>
                  ref.read(alignmentProvider.notifier).setMovableLeft(v),
              onRightChanged: (v) =>
                  ref.read(alignmentProvider.notifier).setMovableRight(v),
            ),
            const SizedBox(height: 16),

            // Results Card
            if (state.result != null) _ResultsCard(result: state.result!),
          ],
        ),
      ),
    );
  }
}

class _DialReadingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final dynamic reading;
  final ValueChanged<double> onTopChanged;
  final ValueChanged<double> onBottomChanged;
  final ValueChanged<double> onLeftChanged;
  final ValueChanged<double> onRightChanged;

  const _DialReadingCard({
    required this.title,
    required this.subtitle,
    required this.reading,
    required this.onTopChanged,
    required this.onBottomChanged,
    required this.onLeftChanged,
    required this.onRightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 16),
            // Dial indicator visual layout
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 80),
                SizedBox(
                  width: 100,
                  child: _NumberField(
                    label: 'Top (12)',
                    value: reading.top,
                    onChanged: onTopChanged,
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: _NumberField(
                    label: 'Left (9)',
                    value: reading.left,
                    onChanged: onLeftChanged,
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
                SizedBox(
                  width: 100,
                  child: _NumberField(
                    label: 'Right (3)',
                    value: reading.right,
                    onChanged: onRightChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 80),
                SizedBox(
                  width: 100,
                  child: _NumberField(
                    label: 'Bottom (6)',
                    value: reading.bottom,
                    onChanged: onBottomChanged,
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsCard extends StatelessWidget {
  final dynamic result;

  const _ResultsCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alignment Results',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            Text(
              'Offset & Angularity',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _ResultRow(
              label: 'Vertical Offset',
              value: '${result.verticalOffset.toStringAsFixed(3)}" '
                  '(${result.verticalOffset >= 0 ? "Motor High" : "Motor Low"})',
            ),
            _ResultRow(
              label: 'Horizontal Offset',
              value: '${result.horizontalOffset.toStringAsFixed(3)}" '
                  '(${result.horizontalOffset >= 0 ? "Motor Right" : "Motor Left"})',
            ),
            _ResultRow(
              label: 'Vertical Angularity',
              value: '${result.verticalAngularity.toStringAsFixed(2)} mils/in',
            ),
            _ResultRow(
              label: 'Horizontal Angularity',
              value: '${result.horizontalAngularity.toStringAsFixed(2)} mils/in',
            ),
            const Divider(),
            Text(
              'Foot Corrections (Movable Machine)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _CorrectionRow(
              label: 'Front Feet - Vertical',
              value: result.frontFootVertical,
              unit: '"',
              positiveAction: 'Add Shims',
              negativeAction: 'Remove Shims',
            ),
            _CorrectionRow(
              label: 'Back Feet - Vertical',
              value: result.backFootVertical,
              unit: '"',
              positiveAction: 'Add Shims',
              negativeAction: 'Remove Shims',
            ),
            _CorrectionRow(
              label: 'Front Feet - Horizontal',
              value: result.frontFootHorizontal,
              unit: '"',
              positiveAction: 'Move Right',
              negativeAction: 'Move Left',
            ),
            _CorrectionRow(
              label: 'Back Feet - Horizontal',
              value: result.backFootHorizontal,
              unit: '"',
              positiveAction: 'Move Right',
              negativeAction: 'Move Left',
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CorrectionRow extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final String positiveAction;
  final String negativeAction;

  const _CorrectionRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.positiveAction,
    required this.negativeAction,
  });

  @override
  Widget build(BuildContext context) {
    final action = value >= 0 ? positiveAction : negativeAction;
    final color = value.abs() < 0.002
        ? Colors.green
        : value.abs() < 0.005
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(
            flex: 2,
            child: Text(
              '${value.abs().toStringAsFixed(4)}$unit - $action',
              style: TextStyle(fontWeight: FontWeight.w600, color: color),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_NumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final newText = widget.value.toString();
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
      onChanged: (value) {
        final parsed = double.tryParse(value);
        if (parsed != null) {
          widget.onChanged(parsed);
        }
      },
    );
  }
}
