// Wire and Cable Reference Data
class WireGauge {
  final int awg;
  final double diameterMils; // 1 mil = 0.001 inch
  final double diameterMm;
  final double areaCircularMils;
  final double areaSqMm;
  final double resistancePerKft; // Ohms per 1000 ft at 20°C (copper)
  final int ampacity60C; // Ampacity at 60°C insulation
  final int ampacity75C; // Ampacity at 75°C insulation
  final int ampacity90C; // Ampacity at 90°C insulation

  const WireGauge({
    required this.awg,
    required this.diameterMils,
    required this.diameterMm,
    required this.areaCircularMils,
    required this.areaSqMm,
    required this.resistancePerKft,
    required this.ampacity60C,
    required this.ampacity75C,
    required this.ampacity90C,
  });
}

// AWG Wire Data (copper)
const List<WireGauge> wireGauges = [
  WireGauge(awg: 18, diameterMils: 40.3, diameterMm: 1.02, areaCircularMils: 1624, areaSqMm: 0.82, resistancePerKft: 6.385, ampacity60C: 7, ampacity75C: 10, ampacity90C: 14),
  WireGauge(awg: 16, diameterMils: 50.8, diameterMm: 1.29, areaCircularMils: 2583, areaSqMm: 1.31, resistancePerKft: 4.016, ampacity60C: 10, ampacity75C: 13, ampacity90C: 18),
  WireGauge(awg: 14, diameterMils: 64.1, diameterMm: 1.63, areaCircularMils: 4107, areaSqMm: 2.08, resistancePerKft: 2.525, ampacity60C: 15, ampacity75C: 20, ampacity90C: 25),
  WireGauge(awg: 12, diameterMils: 80.8, diameterMm: 2.05, areaCircularMils: 6530, areaSqMm: 3.31, resistancePerKft: 1.588, ampacity60C: 20, ampacity75C: 25, ampacity90C: 30),
  WireGauge(awg: 10, diameterMils: 101.9, diameterMm: 2.59, areaCircularMils: 10380, areaSqMm: 5.26, resistancePerKft: 0.999, ampacity60C: 30, ampacity75C: 35, ampacity90C: 40),
  WireGauge(awg: 8, diameterMils: 128.5, diameterMm: 3.26, areaCircularMils: 16510, areaSqMm: 8.37, resistancePerKft: 0.628, ampacity60C: 40, ampacity75C: 50, ampacity90C: 55),
  WireGauge(awg: 6, diameterMils: 162.0, diameterMm: 4.11, areaCircularMils: 26240, areaSqMm: 13.30, resistancePerKft: 0.395, ampacity60C: 55, ampacity75C: 65, ampacity90C: 75),
  WireGauge(awg: 4, diameterMils: 204.3, diameterMm: 5.19, areaCircularMils: 41740, areaSqMm: 21.15, resistancePerKft: 0.249, ampacity60C: 70, ampacity75C: 85, ampacity90C: 95),
  WireGauge(awg: 3, diameterMils: 229.4, diameterMm: 5.83, areaCircularMils: 52620, areaSqMm: 26.67, resistancePerKft: 0.197, ampacity60C: 85, ampacity75C: 100, ampacity90C: 115),
  WireGauge(awg: 2, diameterMils: 257.6, diameterMm: 6.54, areaCircularMils: 66360, areaSqMm: 33.62, resistancePerKft: 0.156, ampacity60C: 95, ampacity75C: 115, ampacity90C: 130),
  WireGauge(awg: 1, diameterMils: 289.3, diameterMm: 7.35, areaCircularMils: 83690, areaSqMm: 42.41, resistancePerKft: 0.124, ampacity60C: 110, ampacity75C: 130, ampacity90C: 145),
  WireGauge(awg: 0, diameterMils: 324.9, diameterMm: 8.25, areaCircularMils: 105600, areaSqMm: 53.49, resistancePerKft: 0.098, ampacity60C: 125, ampacity75C: 150, ampacity90C: 170),
  WireGauge(awg: -1, diameterMils: 364.8, diameterMm: 9.27, areaCircularMils: 133100, areaSqMm: 67.43, resistancePerKft: 0.078, ampacity60C: 145, ampacity75C: 175, ampacity90C: 195), // 00 (2/0)
  WireGauge(awg: -2, diameterMils: 409.6, diameterMm: 10.40, areaCircularMils: 167800, areaSqMm: 85.01, resistancePerKft: 0.062, ampacity60C: 165, ampacity75C: 200, ampacity90C: 225), // 000 (3/0)
  WireGauge(awg: -3, diameterMils: 460.0, diameterMm: 11.68, areaCircularMils: 211600, areaSqMm: 107.2, resistancePerKft: 0.049, ampacity60C: 195, ampacity75C: 230, ampacity90C: 260), // 0000 (4/0)
];

// Display name for AWG
String awgDisplayName(int awg) {
  if (awg >= 0) return '$awg AWG';
  switch (awg) {
    case -1:
      return '2/0 AWG';
    case -2:
      return '3/0 AWG';
    case -3:
      return '4/0 AWG';
    default:
      return '$awg AWG';
  }
}

// Conduit Fill Data
class ConduitSize {
  final String size;
  final double tradeSize; // inches
  final double internalArea; // sq inches (EMT)
  final int maxWires40Pct; // 40% fill for multiple wires

  const ConduitSize({
    required this.size,
    required this.tradeSize,
    required this.internalArea,
    required this.maxWires40Pct,
  });
}

const List<ConduitSize> conduitSizes = [
  ConduitSize(size: '1/2"', tradeSize: 0.5, internalArea: 0.304, maxWires40Pct: 0),
  ConduitSize(size: '3/4"', tradeSize: 0.75, internalArea: 0.533, maxWires40Pct: 0),
  ConduitSize(size: '1"', tradeSize: 1.0, internalArea: 0.864, maxWires40Pct: 0),
  ConduitSize(size: '1-1/4"', tradeSize: 1.25, internalArea: 1.496, maxWires40Pct: 0),
  ConduitSize(size: '1-1/2"', tradeSize: 1.5, internalArea: 2.036, maxWires40Pct: 0),
  ConduitSize(size: '2"', tradeSize: 2.0, internalArea: 3.356, maxWires40Pct: 0),
  ConduitSize(size: '2-1/2"', tradeSize: 2.5, internalArea: 5.858, maxWires40Pct: 0),
  ConduitSize(size: '3"', tradeSize: 3.0, internalArea: 8.846, maxWires40Pct: 0),
  ConduitSize(size: '4"', tradeSize: 4.0, internalArea: 15.68, maxWires40Pct: 0),
];

// Wire insulation types
class WireInsulation {
  final String type;
  final String name;
  final int maxTemp; // °C
  final String application;
  final bool wetLocation;

  const WireInsulation({
    required this.type,
    required this.name,
    required this.maxTemp,
    required this.application,
    required this.wetLocation,
  });
}

const List<WireInsulation> wireInsulations = [
  WireInsulation(
    type: 'TW',
    name: 'Thermoplastic',
    maxTemp: 60,
    application: 'Dry and wet locations',
    wetLocation: true,
  ),
  WireInsulation(
    type: 'THW',
    name: 'Thermoplastic Heat & Water resistant',
    maxTemp: 75,
    application: 'Dry and wet locations',
    wetLocation: true,
  ),
  WireInsulation(
    type: 'THWN',
    name: 'Thermoplastic Heat & Water resistant Nylon',
    maxTemp: 75,
    application: 'Dry and wet locations, conduit',
    wetLocation: true,
  ),
  WireInsulation(
    type: 'THHN',
    name: 'Thermoplastic High Heat Nylon',
    maxTemp: 90,
    application: 'Dry and damp locations',
    wetLocation: false,
  ),
  WireInsulation(
    type: 'XHHW',
    name: 'Cross-linked High Heat Water resistant',
    maxTemp: 90,
    application: 'Dry and wet locations',
    wetLocation: true,
  ),
  WireInsulation(
    type: 'USE',
    name: 'Underground Service Entrance',
    maxTemp: 75,
    application: 'Underground, direct burial',
    wetLocation: true,
  ),
  WireInsulation(
    type: 'RHW',
    name: 'Rubber Heat & Water resistant',
    maxTemp: 75,
    application: 'Dry and wet locations',
    wetLocation: true,
  ),
];

// Voltage drop calculation
double calculateVoltageDrop({
  required double current, // amps
  required double length, // feet (one way)
  required double resistance, // ohms per 1000 ft
  required bool singlePhase,
}) {
  // VD = 2 × I × R × L / 1000 for single phase
  // VD = 1.732 × I × R × L / 1000 for three phase
  final multiplier = singlePhase ? 2.0 : 1.732;
  return multiplier * current * resistance * length / 1000;
}

// Calculate voltage drop percentage
double voltageDropPercent(double voltageDrop, double systemVoltage) {
  return (voltageDrop / systemVoltage) * 100;
}
