enum LengthUnit { inches, feet, millimeters, centimeters, meters }

enum TorqueUnit { footPounds, inchPounds, newtonMeters, kilogramMeters }

enum TemperatureUnit { fahrenheit, celsius, kelvin }

class ConversionService {
  // Length Conversions
  static double convertLength(double value, LengthUnit from, LengthUnit to) {
    // First convert to inches (base unit)
    double inches = _toInches(value, from);
    // Then convert from inches to target unit
    return _fromInches(inches, to);
  }

  static double _toInches(double value, LengthUnit unit) {
    switch (unit) {
      case LengthUnit.inches:
        return value;
      case LengthUnit.feet:
        return value * 12;
      case LengthUnit.millimeters:
        return value / 25.4;
      case LengthUnit.centimeters:
        return value / 2.54;
      case LengthUnit.meters:
        return value / 0.0254;
    }
  }

  static double _fromInches(double inches, LengthUnit unit) {
    switch (unit) {
      case LengthUnit.inches:
        return inches;
      case LengthUnit.feet:
        return inches / 12;
      case LengthUnit.millimeters:
        return inches * 25.4;
      case LengthUnit.centimeters:
        return inches * 2.54;
      case LengthUnit.meters:
        return inches * 0.0254;
    }
  }

  // Torque Conversions
  static double convertTorque(double value, TorqueUnit from, TorqueUnit to) {
    // First convert to foot-pounds (base unit)
    double footPounds = _toFootPounds(value, from);
    // Then convert from foot-pounds to target unit
    return _fromFootPounds(footPounds, to);
  }

  static double _toFootPounds(double value, TorqueUnit unit) {
    switch (unit) {
      case TorqueUnit.footPounds:
        return value;
      case TorqueUnit.inchPounds:
        return value / 12;
      case TorqueUnit.newtonMeters:
        return value * 0.7376;
      case TorqueUnit.kilogramMeters:
        return value * 7.233;
    }
  }

  static double _fromFootPounds(double footPounds, TorqueUnit unit) {
    switch (unit) {
      case TorqueUnit.footPounds:
        return footPounds;
      case TorqueUnit.inchPounds:
        return footPounds * 12;
      case TorqueUnit.newtonMeters:
        return footPounds * 1.3558;
      case TorqueUnit.kilogramMeters:
        return footPounds * 0.1383;
    }
  }

  // Temperature Conversions
  static double convertTemperature(
    double value,
    TemperatureUnit from,
    TemperatureUnit to,
  ) {
    // First convert to Fahrenheit (base unit)
    double fahrenheit = _toFahrenheit(value, from);
    // Then convert from Fahrenheit to target unit
    return _fromFahrenheit(fahrenheit, to);
  }

  static double _toFahrenheit(double value, TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return value;
      case TemperatureUnit.celsius:
        return (value * 9 / 5) + 32;
      case TemperatureUnit.kelvin:
        return (value - 273.15) * 9 / 5 + 32;
    }
  }

  static double _fromFahrenheit(double fahrenheit, TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return fahrenheit;
      case TemperatureUnit.celsius:
        return (fahrenheit - 32) * 5 / 9;
      case TemperatureUnit.kelvin:
        return (fahrenheit - 32) * 5 / 9 + 273.15;
    }
  }

  // Fraction to Decimal Conversion
  static double fractionToDecimal(String fraction) {
    fraction = fraction.trim().replaceAll('"', '');

    // Check for mixed number (e.g., "1-1/2")
    if (fraction.contains('-') && fraction.contains('/')) {
      final parts = fraction.split('-');
      if (parts.length == 2) {
        final whole = double.tryParse(parts[0]) ?? 0;
        final fractionPart = _parseFraction(parts[1]);
        return whole + fractionPart;
      }
    }

    // Check for simple fraction (e.g., "1/2")
    if (fraction.contains('/')) {
      return _parseFraction(fraction);
    }

    // Otherwise, try to parse as decimal
    return double.tryParse(fraction) ?? 0;
  }

  static double _parseFraction(String fraction) {
    final parts = fraction.split('/');
    if (parts.length == 2) {
      final numerator = double.tryParse(parts[0]) ?? 0;
      final denominator = double.tryParse(parts[1]) ?? 1;
      if (denominator != 0) {
        return numerator / denominator;
      }
    }
    return 0;
  }

  // Decimal to Fraction Conversion (approximate to nearest 64th)
  static String decimalToFraction(double decimal, {int maxDenominator = 64}) {
    if (decimal == 0) return '0';

    int wholePart = decimal.truncate();
    double fractionalPart = decimal - wholePart;

    if (fractionalPart == 0) return wholePart.toString();

    // Find best fraction approximation
    int bestNumerator = 0;
    int bestDenominator = 1;
    double bestError = double.infinity;

    for (int denom = 1; denom <= maxDenominator; denom++) {
      int numer = (fractionalPart * denom).round();
      if (numer > 0 && numer <= denom) {
        double error = (fractionalPart - numer / denom).abs();
        if (error < bestError) {
          bestError = error;
          bestNumerator = numer;
          bestDenominator = denom;
        }
      }
    }

    // Simplify fraction
    int gcd = _gcd(bestNumerator, bestDenominator);
    bestNumerator ~/= gcd;
    bestDenominator ~/= gcd;

    if (wholePart == 0) {
      return '$bestNumerator/$bestDenominator';
    } else if (bestNumerator == 0) {
      return wholePart.toString();
    } else {
      return '$wholePart-$bestNumerator/$bestDenominator';
    }
  }

  static int _gcd(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  // Standard to Metric (quick conversion)
  static double inchesToMillimeters(double inches) => inches * 25.4;

  static double millimetersToInches(double mm) => mm / 25.4;
}

// Unit display names for UI
extension LengthUnitExtension on LengthUnit {
  String get displayName {
    switch (this) {
      case LengthUnit.inches:
        return 'Inches (in)';
      case LengthUnit.feet:
        return 'Feet (ft)';
      case LengthUnit.millimeters:
        return 'Millimeters (mm)';
      case LengthUnit.centimeters:
        return 'Centimeters (cm)';
      case LengthUnit.meters:
        return 'Meters (m)';
    }
  }

  String get abbreviation {
    switch (this) {
      case LengthUnit.inches:
        return 'in';
      case LengthUnit.feet:
        return 'ft';
      case LengthUnit.millimeters:
        return 'mm';
      case LengthUnit.centimeters:
        return 'cm';
      case LengthUnit.meters:
        return 'm';
    }
  }
}

extension TorqueUnitExtension on TorqueUnit {
  String get displayName {
    switch (this) {
      case TorqueUnit.footPounds:
        return 'Foot-Pounds (ft-lb)';
      case TorqueUnit.inchPounds:
        return 'Inch-Pounds (in-lb)';
      case TorqueUnit.newtonMeters:
        return 'Newton-Meters (N-m)';
      case TorqueUnit.kilogramMeters:
        return 'Kilogram-Meters (kg-m)';
    }
  }

  String get abbreviation {
    switch (this) {
      case TorqueUnit.footPounds:
        return 'ft-lb';
      case TorqueUnit.inchPounds:
        return 'in-lb';
      case TorqueUnit.newtonMeters:
        return 'N-m';
      case TorqueUnit.kilogramMeters:
        return 'kg-m';
    }
  }
}

extension TemperatureUnitExtension on TemperatureUnit {
  String get displayName {
    switch (this) {
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit (°F)';
      case TemperatureUnit.celsius:
        return 'Celsius (°C)';
      case TemperatureUnit.kelvin:
        return 'Kelvin (K)';
    }
  }

  String get abbreviation {
    switch (this) {
      case TemperatureUnit.fahrenheit:
        return '°F';
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.kelvin:
        return 'K';
    }
  }
}
