class DialReading {
  final double top; // 12 o'clock
  final double bottom; // 6 o'clock
  final double left; // 9 o'clock
  final double right; // 3 o'clock

  const DialReading({
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  double get verticalTIR => (bottom - top).abs();
  double get horizontalTIR => (right - left).abs();

  DialReading copyWith({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return DialReading(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }
}

class AlignmentResult {
  final double verticalOffset; // Positive = motor high
  final double horizontalOffset; // Positive = motor right
  final double verticalAngularity; // mils per inch
  final double horizontalAngularity; // mils per inch
  final double frontFootVertical; // Shim adjustment
  final double backFootVertical; // Shim adjustment
  final double frontFootHorizontal; // Move adjustment
  final double backFootHorizontal; // Move adjustment

  const AlignmentResult({
    required this.verticalOffset,
    required this.horizontalOffset,
    required this.verticalAngularity,
    required this.horizontalAngularity,
    required this.frontFootVertical,
    required this.backFootVertical,
    required this.frontFootHorizontal,
    required this.backFootHorizontal,
  });
}

class AlignmentCalculator {
  /// Calculate alignment corrections using reverse indicator method
  ///
  /// [stationaryReading] - Dial indicator readings taken on stationary machine
  /// [movableReading] - Dial indicator readings taken on movable machine
  /// [dialSpacing] - Distance between dial indicator positions (inches)
  /// [frontFootDistance] - Distance from coupling to front foot (inches)
  /// [backFootDistance] - Distance from coupling to back foot (inches)
  static AlignmentResult calculate({
    required DialReading stationaryReading,
    required DialReading movableReading,
    required double dialSpacing,
    required double frontFootDistance,
    required double backFootDistance,
  }) {
    // Calculate vertical offset and angularity
    // Offset = (S bottom - S top) / 2 where S is stationary reading
    double verticalOffset = (stationaryReading.bottom - stationaryReading.top) / 2;

    // Combined vertical = (M bottom - M top) / 2 where M is movable reading
    double movableVertical = (movableReading.bottom - movableReading.top) / 2;

    // Angularity in mils per inch
    double verticalAngularity = 0;
    if (dialSpacing > 0) {
      verticalAngularity = ((movableVertical - verticalOffset) / dialSpacing) * 1000;
    }

    // Calculate horizontal offset and angularity
    double horizontalOffset = (stationaryReading.right - stationaryReading.left) / 2;
    double movableHorizontal = (movableReading.right - movableReading.left) / 2;

    double horizontalAngularity = 0;
    if (dialSpacing > 0) {
      horizontalAngularity = ((movableHorizontal - horizontalOffset) / dialSpacing) * 1000;
    }

    // Calculate foot corrections
    // Front foot = offset + (angularity * front distance / 1000)
    // Back foot = offset + (angularity * back distance / 1000)
    double frontFootVertical = -verticalOffset - (verticalAngularity * frontFootDistance / 1000);
    double backFootVertical = -verticalOffset - (verticalAngularity * backFootDistance / 1000);

    double frontFootHorizontal = -horizontalOffset - (horizontalAngularity * frontFootDistance / 1000);
    double backFootHorizontal = -horizontalOffset - (horizontalAngularity * backFootDistance / 1000);

    return AlignmentResult(
      verticalOffset: verticalOffset,
      horizontalOffset: horizontalOffset,
      verticalAngularity: verticalAngularity,
      horizontalAngularity: horizontalAngularity,
      frontFootVertical: frontFootVertical,
      backFootVertical: backFootVertical,
      frontFootHorizontal: frontFootHorizontal,
      backFootHorizontal: backFootHorizontal,
    );
  }
}
