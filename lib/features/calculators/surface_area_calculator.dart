import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class SurfaceAreaCalculator extends StatefulWidget {
  const SurfaceAreaCalculator({super.key});

  @override
  State<SurfaceAreaCalculator> createState() => _SurfaceAreaCalculatorState();
}

class _SurfaceAreaCalculatorState extends State<SurfaceAreaCalculator> {
  String _selectedShape = 'Cube';
  String _unit = 'in';

  // Controllers for various dimensions
  final _sideController = TextEditingController(text: '10');
  final _lengthController = TextEditingController(text: '10');
  final _widthController = TextEditingController(text: '8');
  final _heightController = TextEditingController(text: '6');
  final _radiusController = TextEditingController(text: '5');
  final _diameterController = TextEditingController(text: '10');
  final _semiMajorController = TextEditingController(text: '6');
  final _semiMinorController = TextEditingController(text: '4');

  final List<String> _shapes = [
    'Cube',
    'Rectangular Prism',
    'Cylinder',
    'Sphere',
    'Cone',
    'Pyramid (Square)',
    'Triangular Prism',
    'Pipe/Tube',
  ];

  double get _surfaceArea {
    switch (_selectedShape) {
      case 'Cube':
        final s = double.tryParse(_sideController.text) ?? 0;
        return 6 * s * s;

      case 'Rectangular Prism':
        final l = double.tryParse(_lengthController.text) ?? 0;
        final w = double.tryParse(_widthController.text) ?? 0;
        final h = double.tryParse(_heightController.text) ?? 0;
        return 2 * (l * w + l * h + w * h);

      case 'Cylinder':
        final r = double.tryParse(_radiusController.text) ?? 0;
        final h = double.tryParse(_heightController.text) ?? 0;
        return 2 * math.pi * r * (r + h);

      case 'Sphere':
        final r = double.tryParse(_radiusController.text) ?? 0;
        return 4 * math.pi * r * r;

      case 'Cone':
        final r = double.tryParse(_radiusController.text) ?? 0;
        final h = double.tryParse(_heightController.text) ?? 0;
        final slant = math.sqrt(r * r + h * h);
        return math.pi * r * (r + slant);

      case 'Pyramid (Square)':
        final b = double.tryParse(_sideController.text) ?? 0;
        final h = double.tryParse(_heightController.text) ?? 0;
        final slant = math.sqrt((b / 2) * (b / 2) + h * h);
        return b * b + 2 * b * slant;

      case 'Triangular Prism':
        final b = double.tryParse(_widthController.text) ?? 0; // base of triangle
        final th = double.tryParse(_heightController.text) ?? 0; // height of triangle
        final l = double.tryParse(_lengthController.text) ?? 0; // length/depth
        final triArea = 0.5 * b * th;
        final s1 = math.sqrt((b / 2) * (b / 2) + th * th); // slant sides (isosceles)
        return 2 * triArea + b * l + 2 * s1 * l;

      case 'Pipe/Tube':
        final od = double.tryParse(_diameterController.text) ?? 0;
        final wall = double.tryParse(_widthController.text) ?? 0;
        final l = double.tryParse(_lengthController.text) ?? 0;
        final id = od - 2 * wall;
        if (id < 0) return 0;
        // Outer surface + inner surface + 2 end rings
        final outerSurface = math.pi * od * l;
        final innerSurface = math.pi * id * l;
        final endRings = 2 * math.pi * ((od / 2) * (od / 2) - (id / 2) * (id / 2));
        return outerSurface + innerSurface + endRings;

      default:
        return 0;
    }
  }

  String get _formula {
    switch (_selectedShape) {
      case 'Cube':
        return 'SA = 6s²';
      case 'Rectangular Prism':
        return 'SA = 2(lw + lh + wh)';
      case 'Cylinder':
        return 'SA = 2πr(r + h)';
      case 'Sphere':
        return 'SA = 4πr²';
      case 'Cone':
        return 'SA = πr(r + √(r² + h²))';
      case 'Pyramid (Square)':
        return 'SA = b² + 2bs\nwhere s = √((b/2)² + h²)';
      case 'Triangular Prism':
        return 'SA = bh + (s₁ + s₂ + b)L';
      case 'Pipe/Tube':
        return 'SA = πDL + πdL + 2π(R² - r²)';
      default:
        return '';
    }
  }

  String get _areaInSqFt {
    if (_unit == 'in') {
      return (_surfaceArea / 144).toStringAsFixed(3);
    } else if (_unit == 'mm') {
      return (_surfaceArea / 92903).toStringAsFixed(4);
    }
    return _surfaceArea.toStringAsFixed(3);
  }

  String get _areaInSqM {
    if (_unit == 'in') {
      return (_surfaceArea / 1550).toStringAsFixed(4);
    } else if (_unit == 'ft') {
      return (_surfaceArea / 10.764).toStringAsFixed(4);
    } else if (_unit == 'mm') {
      return (_surfaceArea / 1000000).toStringAsFixed(6);
    }
    return (_surfaceArea / 10000).toStringAsFixed(4);
  }

  @override
  void dispose() {
    _sideController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _radiusController.dispose();
    _diameterController.dispose();
    _semiMajorController.dispose();
    _semiMinorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surface Area'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Shape selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Shape',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedShape,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _shapes.map((shape) {
                      return DropdownMenuItem(value: shape, child: Text(shape));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedShape = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Shape diagram
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ShapeDiagram(shape: _selectedShape),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formula,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Unit selector
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('Units: '),
                  const Spacer(),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'in', label: Text('in')),
                      ButtonSegment(value: 'ft', label: Text('ft')),
                      ButtonSegment(value: 'mm', label: Text('mm')),
                      ButtonSegment(value: 'cm', label: Text('cm')),
                    ],
                    selected: {_unit},
                    onSelectionChanged: (selection) {
                      setState(() => _unit = selection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dimension inputs
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dimensions ($_unit)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ..._buildDimensionInputs(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Surface Area',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_surfaceArea.toStringAsFixed(2)} $_unit²',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ConversionResult(
                        label: 'sq ft',
                        value: _areaInSqFt,
                      ),
                      _ConversionResult(
                        label: 'sq m',
                        value: _areaInSqM,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tips
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Common Uses',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTips(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDimensionInputs() {
    switch (_selectedShape) {
      case 'Cube':
        return [
          _DimensionField(
            label: 'Side Length (s)',
            controller: _sideController,
            onChanged: (_) => setState(() {}),
          ),
        ];

      case 'Rectangular Prism':
        return [
          _DimensionField(
            label: 'Length (l)',
            controller: _lengthController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Width (w)',
            controller: _widthController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Height (h)',
            controller: _heightController,
            onChanged: (_) => setState(() {}),
          ),
        ];

      case 'Cylinder':
        return [
          _DimensionField(
            label: 'Radius (r)',
            controller: _radiusController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Height (h)',
            controller: _heightController,
            onChanged: (_) => setState(() {}),
          ),
        ];

      case 'Sphere':
        return [
          _DimensionField(
            label: 'Radius (r)',
            controller: _radiusController,
            onChanged: (_) => setState(() {}),
          ),
        ];

      case 'Cone':
        return [
          _DimensionField(
            label: 'Base Radius (r)',
            controller: _radiusController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Height (h)',
            controller: _heightController,
            onChanged: (_) => setState(() {}),
          ),
        ];

      case 'Pyramid (Square)':
        return [
          _DimensionField(
            label: 'Base Side (b)',
            controller: _sideController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Height (h)',
            controller: _heightController,
            onChanged: (_) => setState(() {}),
          ),
        ];

      case 'Triangular Prism':
        return [
          _DimensionField(
            label: 'Triangle Base (b)',
            controller: _widthController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Triangle Height (h)',
            controller: _heightController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Prism Length (L)',
            controller: _lengthController,
            onChanged: (_) => setState(() {}),
          ),
        ];

      case 'Pipe/Tube':
        return [
          _DimensionField(
            label: 'Outer Diameter (OD)',
            controller: _diameterController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Wall Thickness',
            controller: _widthController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _DimensionField(
            label: 'Length (L)',
            controller: _lengthController,
            onChanged: (_) => setState(() {}),
          ),
        ];

      default:
        return [];
    }
  }

  Widget _buildTips() {
    final tips = <String>[];
    switch (_selectedShape) {
      case 'Cube':
      case 'Rectangular Prism':
        tips.addAll([
          'Tanks and containers',
          'Material for boxes/enclosures',
          'Paint coverage for machinery guards',
        ]);
        break;
      case 'Cylinder':
        tips.addAll([
          'Tank painting/coating',
          'Pipe insulation',
          'Drum surface area',
        ]);
        break;
      case 'Sphere':
        tips.addAll([
          'Ball valve surface',
          'Spherical tank coating',
          'Flotation ball sizing',
        ]);
        break;
      case 'Cone':
        tips.addAll([
          'Hopper lining',
          'Funnel fabrication',
          'Conical tank heads',
        ]);
        break;
      case 'Pyramid (Square)':
        tips.addAll([
          'Hopper design',
          'Deflector shields',
          'Custom fabrication',
        ]);
        break;
      case 'Pipe/Tube':
        tips.addAll([
          'Pipe insulation coverage',
          'Coating requirements',
          'Heat transfer calculations',
        ]);
        break;
      default:
        tips.add('General surface calculations');
    }

    return Column(
      children: tips.map((tip) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            const Icon(Icons.check, size: 16, color: Colors.green),
            const SizedBox(width: 8),
            Text(tip, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      )).toList(),
    );
  }
}

class _DimensionField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const _DimensionField({
    required this.label,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      onChanged: onChanged,
    );
  }
}

class _ConversionResult extends StatelessWidget {
  final String label;
  final String value;

  const _ConversionResult({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ShapeDiagram extends StatelessWidget {
  final String shape;

  const _ShapeDiagram({required this.shape});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: CustomPaint(
        size: const Size(150, 100),
        painter: _ShapePainter(
          shape: shape,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final String shape;
  final Color color;

  _ShapePainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final cx = size.width / 2;
    final cy = size.height / 2;

    switch (shape) {
      case 'Cube':
        _drawCube(canvas, cx, cy, 35, paint, strokePaint);
        break;
      case 'Rectangular Prism':
        _drawRectPrism(canvas, cx, cy, 50, 30, 25, paint, strokePaint);
        break;
      case 'Cylinder':
        _drawCylinder(canvas, cx, cy, 25, 60, paint, strokePaint);
        break;
      case 'Sphere':
        _drawSphere(canvas, cx, cy, 40, paint, strokePaint);
        break;
      case 'Cone':
        _drawCone(canvas, cx, cy, 30, 60, paint, strokePaint);
        break;
      case 'Pyramid (Square)':
        _drawPyramid(canvas, cx, cy, 40, 50, paint, strokePaint);
        break;
      case 'Triangular Prism':
        _drawTriPrism(canvas, cx, cy, 40, 50, paint, strokePaint);
        break;
      case 'Pipe/Tube':
        _drawPipe(canvas, cx, cy, 20, 35, 60, paint, strokePaint);
        break;
    }
  }

  void _drawCube(Canvas canvas, double cx, double cy, double s, Paint fill, Paint stroke) {
    final offset = s * 0.4;
    // Front face
    final front = Rect.fromCenter(center: Offset(cx - offset / 2, cy + offset / 2), width: s, height: s);
    canvas.drawRect(front, fill);
    canvas.drawRect(front, stroke);
    // Top face
    final topPath = Path()
      ..moveTo(front.left, front.top)
      ..lineTo(front.left + offset, front.top - offset)
      ..lineTo(front.right + offset, front.top - offset)
      ..lineTo(front.right, front.top)
      ..close();
    canvas.drawPath(topPath, fill);
    canvas.drawPath(topPath, stroke);
    // Right face
    final rightPath = Path()
      ..moveTo(front.right, front.top)
      ..lineTo(front.right + offset, front.top - offset)
      ..lineTo(front.right + offset, front.bottom - offset)
      ..lineTo(front.right, front.bottom)
      ..close();
    canvas.drawPath(rightPath, fill);
    canvas.drawPath(rightPath, stroke);
  }

  void _drawRectPrism(Canvas canvas, double cx, double cy, double l, double w, double h, Paint fill, Paint stroke) {
    final offset = w * 0.5;
    final front = Rect.fromLTWH(cx - l / 2 - offset / 2, cy - h / 2 + offset / 2, l, h);
    canvas.drawRect(front, fill);
    canvas.drawRect(front, stroke);
    final topPath = Path()
      ..moveTo(front.left, front.top)
      ..lineTo(front.left + offset, front.top - offset)
      ..lineTo(front.right + offset, front.top - offset)
      ..lineTo(front.right, front.top)
      ..close();
    canvas.drawPath(topPath, fill);
    canvas.drawPath(topPath, stroke);
    final rightPath = Path()
      ..moveTo(front.right, front.top)
      ..lineTo(front.right + offset, front.top - offset)
      ..lineTo(front.right + offset, front.bottom - offset)
      ..lineTo(front.right, front.bottom)
      ..close();
    canvas.drawPath(rightPath, fill);
    canvas.drawPath(rightPath, stroke);
  }

  void _drawCylinder(Canvas canvas, double cx, double cy, double r, double h, Paint fill, Paint stroke) {
    // Body
    canvas.drawRect(Rect.fromLTWH(cx - r, cy - h / 2 + 8, r * 2, h - 16), fill);
    canvas.drawLine(Offset(cx - r, cy - h / 2 + 8), Offset(cx - r, cy + h / 2 - 8), stroke);
    canvas.drawLine(Offset(cx + r, cy - h / 2 + 8), Offset(cx + r, cy + h / 2 - 8), stroke);
    // Top ellipse
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - h / 2 + 8), width: r * 2, height: 16), fill);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - h / 2 + 8), width: r * 2, height: 16), stroke);
    // Bottom ellipse
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h / 2 - 8), width: r * 2, height: 16), fill);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + h / 2 - 8), width: r * 2, height: 16), 0, math.pi, false, stroke);
  }

  void _drawSphere(Canvas canvas, double cx, double cy, double r, Paint fill, Paint stroke) {
    canvas.drawCircle(Offset(cx, cy), r, fill);
    canvas.drawCircle(Offset(cx, cy), r, stroke);
    // Horizontal ellipse for 3D effect
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 0.6), stroke..color = stroke.color.withValues(alpha: 0.5));
  }

  void _drawCone(Canvas canvas, double cx, double cy, double r, double h, Paint fill, Paint stroke) {
    final path = Path()
      ..moveTo(cx, cy - h / 2)
      ..lineTo(cx - r, cy + h / 2 - 8)
      ..lineTo(cx + r, cy + h / 2 - 8)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h / 2 - 8), width: r * 2, height: 16), fill);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + h / 2 - 8), width: r * 2, height: 16), 0, math.pi, false, stroke);
  }

  void _drawPyramid(Canvas canvas, double cx, double cy, double b, double h, Paint fill, Paint stroke) {
    final apex = Offset(cx, cy - h / 2);
    // Front face
    final frontPath = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(cx - b / 2, cy + h / 2)
      ..lineTo(cx + b / 2, cy + h / 2)
      ..close();
    canvas.drawPath(frontPath, fill);
    canvas.drawPath(frontPath, stroke);
    // Base hint
    canvas.drawLine(Offset(cx - b / 2, cy + h / 2), Offset(cx - b / 4, cy + h / 2 - 10), stroke..color = stroke.color.withValues(alpha: 0.5));
    canvas.drawLine(Offset(cx + b / 2, cy + h / 2), Offset(cx - b / 4, cy + h / 2 - 10), stroke..color = stroke.color.withValues(alpha: 0.5));
  }

  void _drawTriPrism(Canvas canvas, double cx, double cy, double b, double l, Paint fill, Paint stroke) {
    final offset = 15.0;
    // Front triangle
    final frontPath = Path()
      ..moveTo(cx - offset, cy - 20)
      ..lineTo(cx - b / 2 - offset, cy + 20)
      ..lineTo(cx + b / 2 - offset, cy + 20)
      ..close();
    canvas.drawPath(frontPath, fill);
    canvas.drawPath(frontPath, stroke);
    // Top face
    final topPath = Path()
      ..moveTo(cx - offset, cy - 20)
      ..lineTo(cx + offset, cy - 20 - 10)
      ..lineTo(cx + b / 2 + offset, cy + 20 - 10)
      ..lineTo(cx + b / 2 - offset, cy + 20)
      ..close();
    canvas.drawPath(topPath, fill);
    canvas.drawPath(topPath, stroke);
    // Side edge
    canvas.drawLine(Offset(cx + b / 2 - offset, cy + 20), Offset(cx + b / 2 + offset, cy + 20 - 10), stroke);
  }

  void _drawPipe(Canvas canvas, double cx, double cy, double innerR, double outerR, double h, Paint fill, Paint stroke) {
    // Outer cylinder
    canvas.drawRect(Rect.fromLTWH(cx - outerR, cy - h / 2 + 10, outerR * 2, h - 20), fill);
    canvas.drawLine(Offset(cx - outerR, cy - h / 2 + 10), Offset(cx - outerR, cy + h / 2 - 10), stroke);
    canvas.drawLine(Offset(cx + outerR, cy - h / 2 + 10), Offset(cx + outerR, cy + h / 2 - 10), stroke);
    // Top ellipse (outer)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - h / 2 + 10), width: outerR * 2, height: 20), stroke);
    // Inner hole
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - h / 2 + 10), width: innerR * 2, height: 12), Paint()..color = Colors.white);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - h / 2 + 10), width: innerR * 2, height: 12), stroke);
    // Bottom
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + h / 2 - 10), width: outerR * 2, height: 20), 0, math.pi, false, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
