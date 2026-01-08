import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DriveType { vBelt, synchronous, chain, flatBelt }

extension DriveTypeExt on DriveType {
  String get displayName {
    switch (this) {
      case DriveType.vBelt:
        return 'V-Belt';
      case DriveType.synchronous:
        return 'Synchronous (Timing)';
      case DriveType.chain:
        return 'Roller Chain';
      case DriveType.flatBelt:
        return 'Flat Belt';
    }
  }

  String get tensionMethod {
    switch (this) {
      case DriveType.vBelt:
        return 'Deflection method: 1/64" per inch of span';
      case DriveType.synchronous:
        return 'Use belt tension gauge per manufacturer specs';
      case DriveType.chain:
        return 'Midpoint sag: 2-4% of span length';
      case DriveType.flatBelt:
        return 'Deflection method: 1/64" per inch of span';
    }
  }

  double get deflectionFactor {
    switch (this) {
      case DriveType.vBelt:
        return 1.0 / 64.0; // 1/64" per inch
      case DriveType.synchronous:
        return 1.0 / 100.0; // Tighter tolerance
      case DriveType.chain:
        return 0.03; // 3% midpoint sag (middle of 2-4% range)
      case DriveType.flatBelt:
        return 1.0 / 64.0;
    }
  }
}

class BeltTensionState {
  final double spanLength; // inches between sheaves/sprockets
  final DriveType driveType;
  final double force; // lbs of force applied for deflection test

  const BeltTensionState({
    this.spanLength = 24.0,
    this.driveType = DriveType.vBelt,
    this.force = 5.0,
  });

  // Calculate proper deflection amount
  double get properDeflection {
    if (driveType == DriveType.chain) {
      // Chain uses percentage sag
      return spanLength * driveType.deflectionFactor;
    }
    // Belts use 1/64" per inch of span
    return spanLength * driveType.deflectionFactor;
  }

  // Min/max acceptable deflection
  double get minDeflection => properDeflection * 0.8;
  double get maxDeflection => properDeflection * 1.2;

  // Format deflection as fraction for belts
  String get deflectionFraction {
    final totalSixtyFourths = (properDeflection * 64).round();
    if (totalSixtyFourths >= 64) {
      final inches = totalSixtyFourths ~/ 64;
      final remainder = totalSixtyFourths % 64;
      if (remainder == 0) return '$inches"';
      return '$inches-${_simplifyFraction(remainder, 64)}"';
    }
    return '${_simplifyFraction(totalSixtyFourths, 64)}"';
  }

  String _simplifyFraction(int numerator, int denominator) {
    int gcd = _gcd(numerator, denominator);
    return '${numerator ~/ gcd}/${denominator ~/ gcd}';
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  BeltTensionState copyWith({
    double? spanLength,
    DriveType? driveType,
    double? force,
  }) {
    return BeltTensionState(
      spanLength: spanLength ?? this.spanLength,
      driveType: driveType ?? this.driveType,
      force: force ?? this.force,
    );
  }
}

class BeltTensionNotifier extends StateNotifier<BeltTensionState> {
  BeltTensionNotifier() : super(const BeltTensionState());

  void setSpanLength(double value) => state = state.copyWith(spanLength: value);
  void setDriveType(DriveType type) => state = state.copyWith(driveType: type);
  void setForce(double value) => state = state.copyWith(force: value);
  void reset() => state = const BeltTensionState();
}

final beltTensionProvider =
    StateNotifierProvider<BeltTensionNotifier, BeltTensionState>((ref) {
  return BeltTensionNotifier();
});

class BeltTensionCalculator extends ConsumerWidget {
  const BeltTensionCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(beltTensionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Belt & Chain Tension'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(beltTensionProvider.notifier).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drive Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drive Type',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<DriveType>(
                      initialSelection: state.driveType,
                      expandedInsets: EdgeInsets.zero,
                      dropdownMenuEntries: DriveType.values.map((type) {
                        return DropdownMenuEntry(
                          value: type,
                          label: type.displayName,
                        );
                      }).toList(),
                      onSelected: (value) {
                        if (value != null) {
                          ref
                              .read(beltTensionProvider.notifier)
                              .setDriveType(value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.driveType.tensionMethod,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Span Length Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Span Length',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Distance between sheave/sprocket centers',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _SpanInput(
                      value: state.spanLength,
                      onChanged: (v) =>
                          ref.read(beltTensionProvider.notifier).setSpanLength(v),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [12, 18, 24, 36, 48].map((span) {
                        return ActionChip(
                          label: Text('$span"'),
                          onPressed: () => ref
                              .read(beltTensionProvider.notifier)
                              .setSpanLength(span.toDouble()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      state.driveType == DriveType.chain
                          ? 'Proper Chain Sag'
                          : 'Proper Belt Deflection',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.deflectionFraction,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    Text(
                      '(${state.properDeflection.toStringAsFixed(3)}" decimal)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RangeIndicator(
                          label: 'Min',
                          value: state.minDeflection.toStringAsFixed(3),
                        ),
                        const SizedBox(width: 24),
                        _RangeIndicator(
                          label: 'Max',
                          value: state.maxDeflection.toStringAsFixed(3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Visual Diagram
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deflection Test Method',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _DeflectionDiagram(
                      spanLength: state.spanLength,
                      deflection: state.properDeflection,
                      driveType: state.driveType,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Instructions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.checklist, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'How to Check Tension',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(),
                    if (state.driveType == DriveType.chain) ...[
                      _InstructionStep(number: 1, text: 'Measure span length between sprocket centers'),
                      _InstructionStep(number: 2, text: 'Lift chain at midpoint of span'),
                      _InstructionStep(number: 3, text: 'Measure total vertical movement (sag + lift)'),
                      _InstructionStep(number: 4, text: 'Should be 2-4% of span (shown above)'),
                    ] else ...[
                      _InstructionStep(number: 1, text: 'Measure span length between sheave centers'),
                      _InstructionStep(number: 2, text: 'Apply perpendicular force at belt midpoint'),
                      _InstructionStep(number: 3, text: 'Use tension gauge or calibrated force'),
                      _InstructionStep(number: 4, text: 'Belt should deflect the amount shown above'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tips Card
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pro Tips',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TipItem(text: 'Check tension when drive is at operating temperature'),
                    _TipItem(text: 'New belts stretch - recheck after 24-48 hours'),
                    _TipItem(text: 'Over-tensioning causes bearing wear and belt fatigue'),
                    _TipItem(text: 'Under-tensioning causes slippage and belt wear'),
                    if (state.driveType == DriveType.chain)
                      _TipItem(text: 'Check chain for elongation (replace at 3% stretch)'),
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

class _SpanInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _SpanInput({required this.value, required this.onChanged});

  @override
  State<_SpanInput> createState() => _SpanInputState();
}

class _SpanInputState extends State<_SpanInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Span Length (inches)',
        border: OutlineInputBorder(),
        suffixText: '"',
      ),
      onChanged: (value) {
        final parsed = double.tryParse(value);
        if (parsed != null && parsed > 0) {
          widget.onChanged(parsed);
        }
      },
    );
  }
}

class _RangeIndicator extends StatelessWidget {
  final String label;
  final String value;

  const _RangeIndicator({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
        ),
        Text(
          '$value"',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}

class _DeflectionDiagram extends StatelessWidget {
  final double spanLength;
  final double deflection;
  final DriveType driveType;

  const _DeflectionDiagram({
    required this.spanLength,
    required this.deflection,
    required this.driveType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 120),
        painter: _DeflectionPainter(
          color: Theme.of(context).colorScheme.primary,
          isChain: driveType == DriveType.chain,
        ),
      ),
    );
  }
}

class _DeflectionPainter extends CustomPainter {
  final Color color;
  final bool isChain;

  _DeflectionPainter({required this.color, required this.isChain});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw sheaves/sprockets
    final leftCenter = Offset(40, size.height / 2);
    final rightCenter = Offset(size.width - 40, size.height / 2);

    canvas.drawCircle(leftCenter, 20, paint);
    canvas.drawCircle(rightCenter, 20, paint);
    canvas.drawCircle(leftCenter, 5, circlePaint);
    canvas.drawCircle(rightCenter, 5, circlePaint);

    // Draw belt/chain with sag
    final beltPaint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(leftCenter.dx + 20, leftCenter.dy - 15);

    // Top belt (straight)
    path.lineTo(rightCenter.dx - 20, rightCenter.dy - 15);

    // Right side
    path.moveTo(rightCenter.dx + 15, rightCenter.dy);

    // Bottom belt (with sag)
    path.moveTo(leftCenter.dx + 20, leftCenter.dy + 15);
    path.quadraticBezierTo(
      size.width / 2,
      leftCenter.dy + 45, // Sag amount
      rightCenter.dx - 20,
      rightCenter.dy + 15,
    );

    canvas.drawPath(path, beltPaint);

    // Draw deflection arrow
    final arrowPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final midX = size.width / 2;
    final topY = leftCenter.dy + 15;
    final bottomY = leftCenter.dy + 45;

    // Vertical arrow
    canvas.drawLine(Offset(midX, topY), Offset(midX, bottomY), arrowPaint);

    // Arrow head
    canvas.drawLine(Offset(midX, bottomY), Offset(midX - 5, bottomY - 8), arrowPaint);
    canvas.drawLine(Offset(midX, bottomY), Offset(midX + 5, bottomY - 8), arrowPaint);

    // Labels
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Deflection',
        style: TextStyle(color: Colors.orange, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(midX + 8, (topY + bottomY) / 2 - 5));

    // Span label
    final spanPainter = TextPainter(
      text: TextSpan(
        text: 'Span',
        style: TextStyle(color: color, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    spanPainter.layout();
    spanPainter.paint(canvas, Offset(size.width / 2 - 15, 10));

    // Span arrows
    canvas.drawLine(Offset(60, 20), Offset(size.width - 60, 20), paint..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InstructionStep extends StatelessWidget {
  final int number;
  final String text;

  const _InstructionStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
