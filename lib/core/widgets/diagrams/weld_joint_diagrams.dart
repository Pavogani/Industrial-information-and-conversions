import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Diagrams for weld joint types
class WeldJointDiagram extends StatelessWidget {
  final String jointType;
  final double size;

  const WeldJointDiagram({
    super.key,
    required this.jointType,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WeldJointPainter(
          jointType: jointType,
          primaryColor: Theme.of(context).colorScheme.primary,
          weldColor: Colors.orange,
        ),
      ),
    );
  }
}

class _WeldJointPainter extends CustomPainter {
  final String jointType;
  final Color primaryColor;
  final Color weldColor;

  _WeldJointPainter({
    required this.jointType,
    required this.primaryColor,
    required this.weldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final metalPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final metalStroke = Paint()
      ..color = primaryColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final weldPaint = Paint()
      ..color = weldColor
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    switch (jointType.toLowerCase()) {
      case 'butt':
        _drawButtJoint(canvas, size, metalPaint, metalStroke, weldPaint, cx, cy);
        break;
      case 't-joint':
      case 'tee':
      case 'fillet':
        _drawTJoint(canvas, size, metalPaint, metalStroke, weldPaint, cx, cy);
        break;
      case 'lap':
        _drawLapJoint(canvas, size, metalPaint, metalStroke, weldPaint, cx, cy);
        break;
      case 'corner':
        _drawCornerJoint(canvas, size, metalPaint, metalStroke, weldPaint, cx, cy);
        break;
      case 'edge':
        _drawEdgeJoint(canvas, size, metalPaint, metalStroke, weldPaint, cx, cy);
        break;
    }
  }

  void _drawButtJoint(Canvas canvas, Size size, Paint metalPaint, Paint metalStroke, Paint weldPaint, double cx, double cy) {
    final thickness = size.height * 0.2;
    final gap = 4.0;

    // Left plate
    final leftPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, cy - thickness / 2, cx - gap / 2 - 10, thickness),
      const Radius.circular(2),
    );
    canvas.drawRRect(leftPlate, metalPaint);
    canvas.drawRRect(leftPlate, metalStroke);

    // Right plate
    final rightPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx + gap / 2, cy - thickness / 2, cx - gap / 2 - 10, thickness),
      const Radius.circular(2),
    );
    canvas.drawRRect(rightPlate, metalPaint);
    canvas.drawRRect(rightPlate, metalStroke);

    // Weld bead (convex)
    final weldPath = Path();
    weldPath.moveTo(cx - gap / 2, cy - thickness / 2);
    weldPath.quadraticBezierTo(cx, cy - thickness / 2 - 8, cx + gap / 2, cy - thickness / 2);
    weldPath.lineTo(cx + gap / 2, cy + thickness / 2);
    weldPath.quadraticBezierTo(cx, cy + thickness / 2 + 8, cx - gap / 2, cy + thickness / 2);
    weldPath.close();
    canvas.drawPath(weldPath, weldPaint);
  }

  void _drawTJoint(Canvas canvas, Size size, Paint metalPaint, Paint metalStroke, Paint weldPaint, double cx, double cy) {
    final thickness = size.height * 0.15;

    // Horizontal plate
    final horizPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, cy + 10, size.width - 20, thickness),
      const Radius.circular(2),
    );
    canvas.drawRRect(horizPlate, metalPaint);
    canvas.drawRRect(horizPlate, metalStroke);

    // Vertical plate
    final vertPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - thickness / 2, 15, thickness, cy - 5),
      const Radius.circular(2),
    );
    canvas.drawRRect(vertPlate, metalPaint);
    canvas.drawRRect(vertPlate, metalStroke);

    // Left fillet weld
    final leftFillet = Path();
    leftFillet.moveTo(cx - thickness / 2, cy + 10);
    leftFillet.lineTo(cx - thickness / 2 - 12, cy + 10);
    leftFillet.lineTo(cx - thickness / 2, cy - 2);
    leftFillet.close();
    canvas.drawPath(leftFillet, weldPaint);

    // Right fillet weld
    final rightFillet = Path();
    rightFillet.moveTo(cx + thickness / 2, cy + 10);
    rightFillet.lineTo(cx + thickness / 2 + 12, cy + 10);
    rightFillet.lineTo(cx + thickness / 2, cy - 2);
    rightFillet.close();
    canvas.drawPath(rightFillet, weldPaint);
  }

  void _drawLapJoint(Canvas canvas, Size size, Paint metalPaint, Paint metalStroke, Paint weldPaint, double cx, double cy) {
    final thickness = size.height * 0.15;
    final overlap = size.width * 0.3;

    // Bottom plate
    final bottomPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, cy + 5, size.width - 20, thickness),
      const Radius.circular(2),
    );
    canvas.drawRRect(bottomPlate, metalPaint);
    canvas.drawRRect(bottomPlate, metalStroke);

    // Top plate (overlapping)
    final topPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - overlap / 2, cy - thickness + 5, size.width / 2 + 5, thickness),
      const Radius.circular(2),
    );
    canvas.drawRRect(topPlate, metalPaint);
    canvas.drawRRect(topPlate, metalStroke);

    // Fillet welds at overlap edges
    final leftWeld = Path();
    leftWeld.moveTo(cx - overlap / 2, cy - thickness + 5);
    leftWeld.lineTo(cx - overlap / 2 - 10, cy + 5);
    leftWeld.lineTo(cx - overlap / 2, cy + 5);
    leftWeld.close();
    canvas.drawPath(leftWeld, weldPaint);
  }

  void _drawCornerJoint(Canvas canvas, Size size, Paint metalPaint, Paint metalStroke, Paint weldPaint, double cx, double cy) {
    final thickness = size.height * 0.15;

    // Horizontal plate
    final horizPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 5, cy, size.width / 2 - 5, thickness),
      const Radius.circular(2),
    );
    canvas.drawRRect(horizPlate, metalPaint);
    canvas.drawRRect(horizPlate, metalStroke);

    // Vertical plate
    final vertPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - thickness - 5, 20, thickness, cy - 15),
      const Radius.circular(2),
    );
    canvas.drawRRect(vertPlate, metalPaint);
    canvas.drawRRect(vertPlate, metalStroke);

    // Outside corner weld
    final cornerWeld = Path();
    cornerWeld.moveTo(cx - 5, cy);
    cornerWeld.quadraticBezierTo(cx - thickness - 15, cy - 10, cx - thickness - 5, cy - 15);
    cornerWeld.lineTo(cx - 5, cy - 15);
    cornerWeld.close();
    canvas.drawPath(cornerWeld, weldPaint);
  }

  void _drawEdgeJoint(Canvas canvas, Size size, Paint metalPaint, Paint metalStroke, Paint weldPaint, double cx, double cy) {
    final thickness = size.height * 0.12;
    final height = size.height * 0.4;

    // Left plate (standing)
    final leftPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - thickness - 2, cy - height / 2, thickness, height),
      const Radius.circular(2),
    );
    canvas.drawRRect(leftPlate, metalPaint);
    canvas.drawRRect(leftPlate, metalStroke);

    // Right plate (standing, adjacent)
    final rightPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx + 2, cy - height / 2, thickness, height),
      const Radius.circular(2),
    );
    canvas.drawRRect(rightPlate, metalPaint);
    canvas.drawRRect(rightPlate, metalStroke);

    // Edge weld on top
    final edgeWeld = Path();
    edgeWeld.moveTo(cx - thickness - 2, cy - height / 2);
    edgeWeld.quadraticBezierTo(cx, cy - height / 2 - 10, cx + thickness + 2, cy - height / 2);
    edgeWeld.lineTo(cx + 2, cy - height / 2);
    edgeWeld.lineTo(cx - 2, cy - height / 2);
    edgeWeld.close();
    canvas.drawPath(edgeWeld, weldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Flame type diagrams for oxy-acetylene welding
class FlameDiagram extends StatelessWidget {
  final String flameType;
  final double width;
  final double height;

  const FlameDiagram({
    super.key,
    required this.flameType,
    this.width = 160,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _FlamePainter(flameType: flameType),
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  final String flameType;

  _FlamePainter({required this.flameType});

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;

    // Torch tip
    final tipPaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, cy - 8, 25, 16),
        const Radius.circular(2),
      ),
      tipPaint,
    );

    // Inner cone (hottest part)
    final innerCone = Path();
    final innerLength = flameType == 'carburizing' ? 40.0 : 30.0;
    innerCone.moveTo(25, cy - 4);
    innerCone.lineTo(25 + innerLength, cy);
    innerCone.lineTo(25, cy + 4);
    innerCone.close();

    final innerGradient = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.blue.shade200],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(25, cy - 4, innerLength, 8));
    canvas.drawPath(innerCone, innerGradient);

    // Outer envelope
    final outerEnvelope = Path();
    double outerLength;
    Color outerColor;

    switch (flameType.toLowerCase()) {
      case 'neutral':
        outerLength = 60;
        outerColor = Colors.blue.shade300;
        break;
      case 'carburizing':
      case 'reducing':
        outerLength = 80;
        outerColor = Colors.orange.shade300;
        // Draw feather/acetylene feather
        final feather = Path();
        feather.moveTo(25 + innerLength, cy - 2);
        feather.quadraticBezierTo(25 + innerLength + 15, cy - 4, 25 + innerLength + 20, cy);
        feather.quadraticBezierTo(25 + innerLength + 15, cy + 4, 25 + innerLength, cy + 2);
        feather.close();
        canvas.drawPath(feather, Paint()..color = Colors.white.withValues(alpha: 0.8));
        break;
      case 'oxidizing':
        outerLength = 45;
        outerColor = Colors.blue.shade400;
        break;
      default:
        outerLength = 60;
        outerColor = Colors.blue.shade300;
    }

    outerEnvelope.moveTo(25, cy - 10);
    outerEnvelope.quadraticBezierTo(
      25 + outerLength * 0.7, cy - 12,
      25 + outerLength, cy,
    );
    outerEnvelope.quadraticBezierTo(
      25 + outerLength * 0.7, cy + 12,
      25, cy + 10,
    );
    outerEnvelope.close();

    final outerGradient = Paint()
      ..shader = RadialGradient(
        colors: [outerColor.withValues(alpha: 0.8), outerColor.withValues(alpha: 0.2)],
        center: const Alignment(-0.5, 0),
        radius: 1.5,
      ).createShader(Rect.fromLTWH(25, cy - 12, outerLength, 24));
    canvas.drawPath(outerEnvelope, outerGradient);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Belt/Pulley alignment diagram
class AlignmentDiagram extends StatelessWidget {
  final String alignmentType;
  final double size;

  const AlignmentDiagram({
    super.key,
    required this.alignmentType,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.5,
      height: size,
      child: CustomPaint(
        painter: _AlignmentPainter(
          alignmentType: alignmentType,
          primaryColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _AlignmentPainter extends CustomPainter {
  final String alignmentType;
  final Color primaryColor;

  _AlignmentPainter({required this.alignmentType, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final shaftPaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final cy = size.height / 2;

    // Draw two shafts/couplings
    final leftCoupling = Rect.fromCenter(
      center: Offset(size.width * 0.25, cy),
      width: 30,
      height: 50,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(leftCoupling, const Radius.circular(4)),
      shaftPaint,
    );

    double rightOffset = 0;
    double rightAngle = 0;

    switch (alignmentType.toLowerCase()) {
      case 'aligned':
        rightOffset = 0;
        rightAngle = 0;
        break;
      case 'offset':
      case 'parallel':
        rightOffset = 12;
        rightAngle = 0;
        break;
      case 'angular':
        rightOffset = 0;
        rightAngle = 0.15;
        break;
      case 'combined':
        rightOffset = 8;
        rightAngle = 0.1;
        break;
    }

    canvas.save();
    canvas.translate(size.width * 0.75, cy + rightOffset);
    canvas.rotate(rightAngle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 30, height: 50),
        const Radius.circular(4),
      ),
      shaftPaint,
    );
    canvas.restore();

    // Centerline
    canvas.drawLine(
      Offset(10, cy),
      Offset(size.width - 10, cy),
      centerPaint..color = centerPaint.color.withValues(alpha: 0.5),
    );

    // Dimension arrows for offset
    if (rightOffset != 0) {
      final arrowPaint = Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawLine(
        Offset(size.width * 0.5, cy),
        Offset(size.width * 0.5, cy + rightOffset),
        arrowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bearing fit diagram showing interference/clearance
class BearingFitDiagram extends StatelessWidget {
  final String fitType;
  final double size;

  const BearingFitDiagram({
    super.key,
    required this.fitType,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BearingFitPainter(
          fitType: fitType,
          primaryColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _BearingFitPainter extends CustomPainter {
  final String fitType;
  final Color primaryColor;

  _BearingFitPainter({required this.fitType, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerRadius = size.width * 0.4;
    final innerRadius = size.width * 0.25;

    // Housing (outer ring)
    final housingPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), outerRadius, housingPaint);

    // Bearing ring
    final bearingPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    double bearingRadius = innerRadius;
    if (fitType.toLowerCase().contains('interference') || fitType.toLowerCase().contains('press')) {
      bearingRadius = innerRadius + 2; // Slightly larger to show interference
    } else if (fitType.toLowerCase().contains('clearance') || fitType.toLowerCase().contains('loose')) {
      bearingRadius = innerRadius - 2; // Slightly smaller to show clearance
    }

    canvas.drawCircle(Offset(cx, cy), bearingRadius, bearingPaint);

    // Inner bore
    final borePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), innerRadius * 0.6, borePaint);

    // Shaft
    final shaftPaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.fill;

    double shaftRadius = innerRadius * 0.55;
    if (fitType.toLowerCase().contains('interference') || fitType.toLowerCase().contains('press')) {
      shaftRadius = innerRadius * 0.62;
    }

    canvas.drawCircle(Offset(cx, cy), shaftRadius, shaftPaint);

    // Center mark
    final centerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(cx - 5, cy), Offset(cx + 5, cy), centerPaint);
    canvas.drawLine(Offset(cx, cy - 5), Offset(cx, cy + 5), centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Hydraulic cylinder diagram
class HydraulicCylinderDiagram extends StatelessWidget {
  final double size;

  const HydraulicCylinderDiagram({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 2,
      height: size,
      child: CustomPaint(
        painter: _HydraulicCylinderPainter(
          primaryColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _HydraulicCylinderPainter extends CustomPainter {
  final Color primaryColor;

  _HydraulicCylinderPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;

    // Cylinder body
    final bodyPaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, cy - 25, size.width * 0.6, 50),
        const Radius.circular(4),
      ),
      bodyPaint,
    );

    // Piston rod
    final rodPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.6, cy - 8, size.width * 0.35, 16),
        const Radius.circular(2),
      ),
      rodPaint,
    );

    // Port indicators
    final portPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(40, cy - 25), 6, portPaint);
    canvas.drawCircle(Offset(size.width * 0.5, cy - 25), 6, portPaint);

    // Arrows for force direction
    final arrowPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Extension arrow
    final arrowPath = Path();
    arrowPath.moveTo(size.width * 0.85, cy);
    arrowPath.lineTo(size.width - 10, cy);
    arrowPath.moveTo(size.width - 20, cy - 8);
    arrowPath.lineTo(size.width - 10, cy);
    arrowPath.lineTo(size.width - 20, cy + 8);
    canvas.drawPath(arrowPath, arrowPaint);

    // Labels
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'F',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 25, cy + 12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Rigging angle diagram
class RiggingAngleDiagram extends StatelessWidget {
  final double angle;
  final double size;

  const RiggingAngleDiagram({
    super.key,
    required this.angle,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RiggingAnglePainter(
          angle: angle,
          primaryColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _RiggingAnglePainter extends CustomPainter {
  final double angle;
  final Color primaryColor;

  _RiggingAnglePainter({required this.angle, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final hookY = 15.0;
    final loadY = size.height - 20;

    // Hook point
    final hookPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, hookY), 8, hookPaint);

    // Sling lines
    final slingPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final angleRad = angle * math.pi / 180;
    final slingLength = (loadY - hookY) / math.cos(angleRad);
    final spread = slingLength * math.sin(angleRad);

    // Left sling
    canvas.drawLine(
      Offset(cx, hookY),
      Offset(cx - spread, loadY),
      slingPaint,
    );

    // Right sling
    canvas.drawLine(
      Offset(cx, hookY),
      Offset(cx + spread, loadY),
      slingPaint,
    );

    // Load
    final loadPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, loadY), width: spread * 1.5, height: 15),
        const Radius.circular(2),
      ),
      loadPaint,
    );

    // Angle arc
    final arcPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, hookY), width: 30, height: 30),
      math.pi / 2 - angleRad,
      angleRad,
      false,
      arcPaint,
    );

    // Angle label
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${angle.toInt()}°',
        style: TextStyle(
          color: Colors.red,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(cx + 18, hookY + 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
