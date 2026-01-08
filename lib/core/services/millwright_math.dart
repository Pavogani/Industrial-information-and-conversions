import 'dart:math';

class MillwrightMath {
  // Volume of Cylinder for hydraulic fluid or tank capacity
  static double cylinderVolume(double radius, double height) {
    return pi * (radius * radius) * height;
  }

  // Volume in gallons (from cubic inches)
  static double cubicInchesToGallons(double cubicInches) {
    return cubicInches / 231;
  }

  // Pulley Ratio: D1 × RPM1 = D2 × RPM2
  static double solvePulleyRpm2(double d1, double rpm1, double d2) {
    if (d2 == 0) return 0;
    return (d1 * rpm1) / d2;
  }

  static double solvePulleyD2(double d1, double rpm1, double rpm2) {
    if (rpm2 == 0) return 0;
    return (d1 * rpm1) / rpm2;
  }

  static double solvePulleyD1(double d2, double rpm1, double rpm2) {
    if (rpm1 == 0) return 0;
    return (d2 * rpm2) / rpm1;
  }

  // Saw Blade TPI - minimum 3 teeth in work at all times
  // TPI = 3 / material_thickness (minimum)
  static int recommendedTpi(double materialThickness) {
    if (materialThickness <= 0) return 0;
    return (3 / materialThickness).ceil();
  }

  // Rise and Run calculations
  // OSHA standard: 7" max riser, 11" min tread
  static int calculateSteps(double totalRise, double riserHeight) {
    if (riserHeight <= 0) return 0;
    return (totalRise / riserHeight).ceil();
  }

  static double calculateRun(int steps, double treadDepth) {
    return steps * treadDepth;
  }

  static double calculateAngle(double rise, double run) {
    if (run == 0) return 0;
    return atan(rise / run) * 180 / pi;
  }

  // Sling WLL calculations
  // Basic formula: WLL = (Rope Diameter² × 8) for wire rope
  static double wireRopeWll(double diameter) {
    return pow(diameter, 2) * 8;
  }

  // Synthetic sling capacity reduction by angle
  // At 90° (vertical) = 100%, 60° = 86.6%, 45° = 70.7%, 30° = 50%
  static double slingCapacityFactor(double angleDegrees) {
    return sin(angleDegrees * pi / 180);
  }

  // Belt deflection force calculation
  // Rule of thumb: 1/64" deflection per inch of span
  static double beltDeflection(double spanInches) {
    return spanInches / 64;
  }

  // Chain slack for roller chain
  // Recommended: 2-4% of span
  static double chainSlack(double spanInches, {double percent = 3}) {
    return spanInches * (percent / 100);
  }
}
