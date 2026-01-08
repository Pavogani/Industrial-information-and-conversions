// Comprehensive Drill and Tap Chart Data

class DrillSize {
  final String designation;
  final double diameter; // in inches
  final double diameterMm;

  const DrillSize({
    required this.designation,
    required this.diameter,
    required this.diameterMm,
  });
}

class TapDrillInfo {
  final String threadSize;
  final String pitch; // TPI for imperial, mm for metric
  final String tapDrill;
  final double tapDrillDecimal;
  final String clearanceDrillClose;
  final String clearanceDrillFree;
  final int percentThread; // approximately 75% thread

  const TapDrillInfo({
    required this.threadSize,
    required this.pitch,
    required this.tapDrill,
    required this.tapDrillDecimal,
    required this.clearanceDrillClose,
    required this.clearanceDrillFree,
    this.percentThread = 75,
  });
}

// Number Drills (#1 - #80)
const List<DrillSize> numberDrills = [
  DrillSize(designation: '#80', diameter: 0.0135, diameterMm: 0.343),
  DrillSize(designation: '#79', diameter: 0.0145, diameterMm: 0.368),
  DrillSize(designation: '#78', diameter: 0.0160, diameterMm: 0.406),
  DrillSize(designation: '#77', diameter: 0.0180, diameterMm: 0.457),
  DrillSize(designation: '#76', diameter: 0.0200, diameterMm: 0.508),
  DrillSize(designation: '#75', diameter: 0.0210, diameterMm: 0.533),
  DrillSize(designation: '#74', diameter: 0.0225, diameterMm: 0.572),
  DrillSize(designation: '#73', diameter: 0.0240, diameterMm: 0.610),
  DrillSize(designation: '#72', diameter: 0.0250, diameterMm: 0.635),
  DrillSize(designation: '#71', diameter: 0.0260, diameterMm: 0.660),
  DrillSize(designation: '#70', diameter: 0.0280, diameterMm: 0.711),
  DrillSize(designation: '#69', diameter: 0.0292, diameterMm: 0.742),
  DrillSize(designation: '#68', diameter: 0.0310, diameterMm: 0.787),
  DrillSize(designation: '#67', diameter: 0.0320, diameterMm: 0.813),
  DrillSize(designation: '#66', diameter: 0.0330, diameterMm: 0.838),
  DrillSize(designation: '#65', diameter: 0.0350, diameterMm: 0.889),
  DrillSize(designation: '#64', diameter: 0.0360, diameterMm: 0.914),
  DrillSize(designation: '#63', diameter: 0.0370, diameterMm: 0.940),
  DrillSize(designation: '#62', diameter: 0.0380, diameterMm: 0.965),
  DrillSize(designation: '#61', diameter: 0.0390, diameterMm: 0.991),
  DrillSize(designation: '#60', diameter: 0.0400, diameterMm: 1.016),
  DrillSize(designation: '#59', diameter: 0.0410, diameterMm: 1.041),
  DrillSize(designation: '#58', diameter: 0.0420, diameterMm: 1.067),
  DrillSize(designation: '#57', diameter: 0.0430, diameterMm: 1.092),
  DrillSize(designation: '#56', diameter: 0.0465, diameterMm: 1.181),
  DrillSize(designation: '#55', diameter: 0.0520, diameterMm: 1.321),
  DrillSize(designation: '#54', diameter: 0.0550, diameterMm: 1.397),
  DrillSize(designation: '#53', diameter: 0.0595, diameterMm: 1.511),
  DrillSize(designation: '#52', diameter: 0.0635, diameterMm: 1.613),
  DrillSize(designation: '#51', diameter: 0.0670, diameterMm: 1.702),
  DrillSize(designation: '#50', diameter: 0.0700, diameterMm: 1.778),
  DrillSize(designation: '#49', diameter: 0.0730, diameterMm: 1.854),
  DrillSize(designation: '#48', diameter: 0.0760, diameterMm: 1.930),
  DrillSize(designation: '#47', diameter: 0.0785, diameterMm: 1.994),
  DrillSize(designation: '#46', diameter: 0.0810, diameterMm: 2.057),
  DrillSize(designation: '#45', diameter: 0.0820, diameterMm: 2.083),
  DrillSize(designation: '#44', diameter: 0.0860, diameterMm: 2.184),
  DrillSize(designation: '#43', diameter: 0.0890, diameterMm: 2.261),
  DrillSize(designation: '#42', diameter: 0.0935, diameterMm: 2.375),
  DrillSize(designation: '#41', diameter: 0.0960, diameterMm: 2.438),
  DrillSize(designation: '#40', diameter: 0.0980, diameterMm: 2.489),
  DrillSize(designation: '#39', diameter: 0.0995, diameterMm: 2.527),
  DrillSize(designation: '#38', diameter: 0.1015, diameterMm: 2.578),
  DrillSize(designation: '#37', diameter: 0.1040, diameterMm: 2.642),
  DrillSize(designation: '#36', diameter: 0.1065, diameterMm: 2.705),
  DrillSize(designation: '#35', diameter: 0.1100, diameterMm: 2.794),
  DrillSize(designation: '#34', diameter: 0.1110, diameterMm: 2.819),
  DrillSize(designation: '#33', diameter: 0.1130, diameterMm: 2.870),
  DrillSize(designation: '#32', diameter: 0.1160, diameterMm: 2.946),
  DrillSize(designation: '#31', diameter: 0.1200, diameterMm: 3.048),
  DrillSize(designation: '#30', diameter: 0.1285, diameterMm: 3.264),
  DrillSize(designation: '#29', diameter: 0.1360, diameterMm: 3.454),
  DrillSize(designation: '#28', diameter: 0.1405, diameterMm: 3.569),
  DrillSize(designation: '#27', diameter: 0.1440, diameterMm: 3.658),
  DrillSize(designation: '#26', diameter: 0.1470, diameterMm: 3.734),
  DrillSize(designation: '#25', diameter: 0.1495, diameterMm: 3.797),
  DrillSize(designation: '#24', diameter: 0.1520, diameterMm: 3.861),
  DrillSize(designation: '#23', diameter: 0.1540, diameterMm: 3.912),
  DrillSize(designation: '#22', diameter: 0.1570, diameterMm: 3.988),
  DrillSize(designation: '#21', diameter: 0.1590, diameterMm: 4.039),
  DrillSize(designation: '#20', diameter: 0.1610, diameterMm: 4.089),
  DrillSize(designation: '#19', diameter: 0.1660, diameterMm: 4.216),
  DrillSize(designation: '#18', diameter: 0.1695, diameterMm: 4.305),
  DrillSize(designation: '#17', diameter: 0.1730, diameterMm: 4.394),
  DrillSize(designation: '#16', diameter: 0.1770, diameterMm: 4.496),
  DrillSize(designation: '#15', diameter: 0.1800, diameterMm: 4.572),
  DrillSize(designation: '#14', diameter: 0.1820, diameterMm: 4.623),
  DrillSize(designation: '#13', diameter: 0.1850, diameterMm: 4.699),
  DrillSize(designation: '#12', diameter: 0.1890, diameterMm: 4.801),
  DrillSize(designation: '#11', diameter: 0.1910, diameterMm: 4.851),
  DrillSize(designation: '#10', diameter: 0.1935, diameterMm: 4.915),
  DrillSize(designation: '#9', diameter: 0.1960, diameterMm: 4.978),
  DrillSize(designation: '#8', diameter: 0.1990, diameterMm: 5.055),
  DrillSize(designation: '#7', diameter: 0.2010, diameterMm: 5.105),
  DrillSize(designation: '#6', diameter: 0.2040, diameterMm: 5.182),
  DrillSize(designation: '#5', diameter: 0.2055, diameterMm: 5.220),
  DrillSize(designation: '#4', diameter: 0.2090, diameterMm: 5.309),
  DrillSize(designation: '#3', diameter: 0.2130, diameterMm: 5.410),
  DrillSize(designation: '#2', diameter: 0.2210, diameterMm: 5.613),
  DrillSize(designation: '#1', diameter: 0.2280, diameterMm: 5.791),
];

// Letter Drills (A - Z)
const List<DrillSize> letterDrills = [
  DrillSize(designation: 'A', diameter: 0.2340, diameterMm: 5.944),
  DrillSize(designation: 'B', diameter: 0.2380, diameterMm: 6.045),
  DrillSize(designation: 'C', diameter: 0.2420, diameterMm: 6.147),
  DrillSize(designation: 'D', diameter: 0.2460, diameterMm: 6.248),
  DrillSize(designation: 'E', diameter: 0.2500, diameterMm: 6.350),
  DrillSize(designation: 'F', diameter: 0.2570, diameterMm: 6.528),
  DrillSize(designation: 'G', diameter: 0.2610, diameterMm: 6.629),
  DrillSize(designation: 'H', diameter: 0.2660, diameterMm: 6.756),
  DrillSize(designation: 'I', diameter: 0.2720, diameterMm: 6.909),
  DrillSize(designation: 'J', diameter: 0.2770, diameterMm: 7.036),
  DrillSize(designation: 'K', diameter: 0.2810, diameterMm: 7.137),
  DrillSize(designation: 'L', diameter: 0.2900, diameterMm: 7.366),
  DrillSize(designation: 'M', diameter: 0.2950, diameterMm: 7.493),
  DrillSize(designation: 'N', diameter: 0.3020, diameterMm: 7.671),
  DrillSize(designation: 'O', diameter: 0.3160, diameterMm: 8.026),
  DrillSize(designation: 'P', diameter: 0.3230, diameterMm: 8.204),
  DrillSize(designation: 'Q', diameter: 0.3320, diameterMm: 8.433),
  DrillSize(designation: 'R', diameter: 0.3390, diameterMm: 8.611),
  DrillSize(designation: 'S', diameter: 0.3480, diameterMm: 8.839),
  DrillSize(designation: 'T', diameter: 0.3580, diameterMm: 9.093),
  DrillSize(designation: 'U', diameter: 0.3680, diameterMm: 9.347),
  DrillSize(designation: 'V', diameter: 0.3770, diameterMm: 9.576),
  DrillSize(designation: 'W', diameter: 0.3860, diameterMm: 9.804),
  DrillSize(designation: 'X', diameter: 0.3970, diameterMm: 10.084),
  DrillSize(designation: 'Y', diameter: 0.4040, diameterMm: 10.262),
  DrillSize(designation: 'Z', diameter: 0.4130, diameterMm: 10.490),
];

// UNC (Coarse Thread) Tap Drill Chart
const List<TapDrillInfo> uncTapDrills = [
  TapDrillInfo(threadSize: '#1', pitch: '64', tapDrill: '#53', tapDrillDecimal: 0.0595, clearanceDrillClose: '#48', clearanceDrillFree: '#46'),
  TapDrillInfo(threadSize: '#2', pitch: '56', tapDrill: '#50', tapDrillDecimal: 0.0700, clearanceDrillClose: '#43', clearanceDrillFree: '#41'),
  TapDrillInfo(threadSize: '#3', pitch: '48', tapDrill: '#47', tapDrillDecimal: 0.0785, clearanceDrillClose: '#37', clearanceDrillFree: '#35'),
  TapDrillInfo(threadSize: '#4', pitch: '40', tapDrill: '#43', tapDrillDecimal: 0.0890, clearanceDrillClose: '#32', clearanceDrillFree: '#30'),
  TapDrillInfo(threadSize: '#5', pitch: '40', tapDrill: '#38', tapDrillDecimal: 0.1015, clearanceDrillClose: '#30', clearanceDrillFree: '#29'),
  TapDrillInfo(threadSize: '#6', pitch: '32', tapDrill: '#36', tapDrillDecimal: 0.1065, clearanceDrillClose: '#27', clearanceDrillFree: '#25'),
  TapDrillInfo(threadSize: '#8', pitch: '32', tapDrill: '#29', tapDrillDecimal: 0.1360, clearanceDrillClose: '#18', clearanceDrillFree: '#16'),
  TapDrillInfo(threadSize: '#10', pitch: '24', tapDrill: '#25', tapDrillDecimal: 0.1495, clearanceDrillClose: '#9', clearanceDrillFree: '#7'),
  TapDrillInfo(threadSize: '#12', pitch: '24', tapDrill: '#16', tapDrillDecimal: 0.1770, clearanceDrillClose: '#2', clearanceDrillFree: '#1'),
  TapDrillInfo(threadSize: '1/4"', pitch: '20', tapDrill: '#7', tapDrillDecimal: 0.2010, clearanceDrillClose: 'F', clearanceDrillFree: 'H'),
  TapDrillInfo(threadSize: '5/16"', pitch: '18', tapDrill: 'F', tapDrillDecimal: 0.2570, clearanceDrillClose: 'P', clearanceDrillFree: 'Q'),
  TapDrillInfo(threadSize: '3/8"', pitch: '16', tapDrill: '5/16"', tapDrillDecimal: 0.3125, clearanceDrillClose: 'W', clearanceDrillFree: 'X'),
  TapDrillInfo(threadSize: '7/16"', pitch: '14', tapDrill: 'U', tapDrillDecimal: 0.3680, clearanceDrillClose: '29/64"', clearanceDrillFree: '15/32"'),
  TapDrillInfo(threadSize: '1/2"', pitch: '13', tapDrill: '27/64"', tapDrillDecimal: 0.4219, clearanceDrillClose: '33/64"', clearanceDrillFree: '17/32"'),
  TapDrillInfo(threadSize: '9/16"', pitch: '12', tapDrill: '31/64"', tapDrillDecimal: 0.4844, clearanceDrillClose: '37/64"', clearanceDrillFree: '19/32"'),
  TapDrillInfo(threadSize: '5/8"', pitch: '11', tapDrill: '17/32"', tapDrillDecimal: 0.5313, clearanceDrillClose: '41/64"', clearanceDrillFree: '21/32"'),
  TapDrillInfo(threadSize: '3/4"', pitch: '10', tapDrill: '21/32"', tapDrillDecimal: 0.6563, clearanceDrillClose: '49/64"', clearanceDrillFree: '25/32"'),
  TapDrillInfo(threadSize: '7/8"', pitch: '9', tapDrill: '49/64"', tapDrillDecimal: 0.7656, clearanceDrillClose: '57/64"', clearanceDrillFree: '29/32"'),
  TapDrillInfo(threadSize: '1"', pitch: '8', tapDrill: '7/8"', tapDrillDecimal: 0.8750, clearanceDrillClose: '1-1/64"', clearanceDrillFree: '1-1/32"'),
  TapDrillInfo(threadSize: '1-1/8"', pitch: '7', tapDrill: '63/64"', tapDrillDecimal: 0.9844, clearanceDrillClose: '1-9/64"', clearanceDrillFree: '1-5/32"'),
  TapDrillInfo(threadSize: '1-1/4"', pitch: '7', tapDrill: '1-7/64"', tapDrillDecimal: 1.1094, clearanceDrillClose: '1-17/64"', clearanceDrillFree: '1-9/32"'),
  TapDrillInfo(threadSize: '1-1/2"', pitch: '6', tapDrill: '1-11/32"', tapDrillDecimal: 1.3438, clearanceDrillClose: '1-33/64"', clearanceDrillFree: '1-17/32"'),
];

// UNF (Fine Thread) Tap Drill Chart
const List<TapDrillInfo> unfTapDrills = [
  TapDrillInfo(threadSize: '#0', pitch: '80', tapDrill: '3/64"', tapDrillDecimal: 0.0469, clearanceDrillClose: '#52', clearanceDrillFree: '#50'),
  TapDrillInfo(threadSize: '#1', pitch: '72', tapDrill: '#53', tapDrillDecimal: 0.0595, clearanceDrillClose: '#48', clearanceDrillFree: '#46'),
  TapDrillInfo(threadSize: '#2', pitch: '64', tapDrill: '#50', tapDrillDecimal: 0.0700, clearanceDrillClose: '#43', clearanceDrillFree: '#41'),
  TapDrillInfo(threadSize: '#3', pitch: '56', tapDrill: '#45', tapDrillDecimal: 0.0820, clearanceDrillClose: '#37', clearanceDrillFree: '#35'),
  TapDrillInfo(threadSize: '#4', pitch: '48', tapDrill: '#42', tapDrillDecimal: 0.0935, clearanceDrillClose: '#32', clearanceDrillFree: '#30'),
  TapDrillInfo(threadSize: '#5', pitch: '44', tapDrill: '#37', tapDrillDecimal: 0.1040, clearanceDrillClose: '#30', clearanceDrillFree: '#29'),
  TapDrillInfo(threadSize: '#6', pitch: '40', tapDrill: '#33', tapDrillDecimal: 0.1130, clearanceDrillClose: '#27', clearanceDrillFree: '#25'),
  TapDrillInfo(threadSize: '#8', pitch: '36', tapDrill: '#29', tapDrillDecimal: 0.1360, clearanceDrillClose: '#18', clearanceDrillFree: '#16'),
  TapDrillInfo(threadSize: '#10', pitch: '32', tapDrill: '#21', tapDrillDecimal: 0.1590, clearanceDrillClose: '#9', clearanceDrillFree: '#7'),
  TapDrillInfo(threadSize: '#12', pitch: '28', tapDrill: '#14', tapDrillDecimal: 0.1820, clearanceDrillClose: '#2', clearanceDrillFree: '#1'),
  TapDrillInfo(threadSize: '1/4"', pitch: '28', tapDrill: '#3', tapDrillDecimal: 0.2130, clearanceDrillClose: 'F', clearanceDrillFree: 'H'),
  TapDrillInfo(threadSize: '5/16"', pitch: '24', tapDrill: 'I', tapDrillDecimal: 0.2720, clearanceDrillClose: 'P', clearanceDrillFree: 'Q'),
  TapDrillInfo(threadSize: '3/8"', pitch: '24', tapDrill: 'Q', tapDrillDecimal: 0.3320, clearanceDrillClose: 'W', clearanceDrillFree: 'X'),
  TapDrillInfo(threadSize: '7/16"', pitch: '20', tapDrill: '25/64"', tapDrillDecimal: 0.3906, clearanceDrillClose: '29/64"', clearanceDrillFree: '15/32"'),
  TapDrillInfo(threadSize: '1/2"', pitch: '20', tapDrill: '29/64"', tapDrillDecimal: 0.4531, clearanceDrillClose: '33/64"', clearanceDrillFree: '17/32"'),
  TapDrillInfo(threadSize: '9/16"', pitch: '18', tapDrill: '33/64"', tapDrillDecimal: 0.5156, clearanceDrillClose: '37/64"', clearanceDrillFree: '19/32"'),
  TapDrillInfo(threadSize: '5/8"', pitch: '18', tapDrill: '37/64"', tapDrillDecimal: 0.5781, clearanceDrillClose: '41/64"', clearanceDrillFree: '21/32"'),
  TapDrillInfo(threadSize: '3/4"', pitch: '16', tapDrill: '11/16"', tapDrillDecimal: 0.6875, clearanceDrillClose: '49/64"', clearanceDrillFree: '25/32"'),
  TapDrillInfo(threadSize: '7/8"', pitch: '14', tapDrill: '13/16"', tapDrillDecimal: 0.8125, clearanceDrillClose: '57/64"', clearanceDrillFree: '29/32"'),
  TapDrillInfo(threadSize: '1"', pitch: '12', tapDrill: '15/16"', tapDrillDecimal: 0.9375, clearanceDrillClose: '1-1/64"', clearanceDrillFree: '1-1/32"'),
  TapDrillInfo(threadSize: '1-1/8"', pitch: '12', tapDrill: '1-3/64"', tapDrillDecimal: 1.0469, clearanceDrillClose: '1-9/64"', clearanceDrillFree: '1-5/32"'),
  TapDrillInfo(threadSize: '1-1/4"', pitch: '12', tapDrill: '1-11/64"', tapDrillDecimal: 1.1719, clearanceDrillClose: '1-17/64"', clearanceDrillFree: '1-9/32"'),
  TapDrillInfo(threadSize: '1-1/2"', pitch: '12', tapDrill: '1-27/64"', tapDrillDecimal: 1.4219, clearanceDrillClose: '1-33/64"', clearanceDrillFree: '1-17/32"'),
];

// Metric Tap Drill Chart
const List<TapDrillInfo> metricTapDrills = [
  TapDrillInfo(threadSize: 'M1.6', pitch: '0.35', tapDrill: '1.25mm', tapDrillDecimal: 0.0492, clearanceDrillClose: '1.7mm', clearanceDrillFree: '1.8mm'),
  TapDrillInfo(threadSize: 'M2', pitch: '0.4', tapDrill: '1.6mm', tapDrillDecimal: 0.0630, clearanceDrillClose: '2.2mm', clearanceDrillFree: '2.4mm'),
  TapDrillInfo(threadSize: 'M2.5', pitch: '0.45', tapDrill: '2.05mm', tapDrillDecimal: 0.0807, clearanceDrillClose: '2.7mm', clearanceDrillFree: '2.9mm'),
  TapDrillInfo(threadSize: 'M3', pitch: '0.5', tapDrill: '2.5mm', tapDrillDecimal: 0.0984, clearanceDrillClose: '3.2mm', clearanceDrillFree: '3.4mm'),
  TapDrillInfo(threadSize: 'M3.5', pitch: '0.6', tapDrill: '2.9mm', tapDrillDecimal: 0.1142, clearanceDrillClose: '3.7mm', clearanceDrillFree: '3.9mm'),
  TapDrillInfo(threadSize: 'M4', pitch: '0.7', tapDrill: '3.3mm', tapDrillDecimal: 0.1299, clearanceDrillClose: '4.3mm', clearanceDrillFree: '4.5mm'),
  TapDrillInfo(threadSize: 'M5', pitch: '0.8', tapDrill: '4.2mm', tapDrillDecimal: 0.1654, clearanceDrillClose: '5.3mm', clearanceDrillFree: '5.5mm'),
  TapDrillInfo(threadSize: 'M6', pitch: '1.0', tapDrill: '5.0mm', tapDrillDecimal: 0.1969, clearanceDrillClose: '6.4mm', clearanceDrillFree: '6.6mm'),
  TapDrillInfo(threadSize: 'M7', pitch: '1.0', tapDrill: '6.0mm', tapDrillDecimal: 0.2362, clearanceDrillClose: '7.4mm', clearanceDrillFree: '7.6mm'),
  TapDrillInfo(threadSize: 'M8', pitch: '1.25', tapDrill: '6.8mm', tapDrillDecimal: 0.2677, clearanceDrillClose: '8.4mm', clearanceDrillFree: '9.0mm'),
  TapDrillInfo(threadSize: 'M10', pitch: '1.5', tapDrill: '8.5mm', tapDrillDecimal: 0.3346, clearanceDrillClose: '10.5mm', clearanceDrillFree: '11.0mm'),
  TapDrillInfo(threadSize: 'M12', pitch: '1.75', tapDrill: '10.2mm', tapDrillDecimal: 0.4016, clearanceDrillClose: '13.0mm', clearanceDrillFree: '14.0mm'),
  TapDrillInfo(threadSize: 'M14', pitch: '2.0', tapDrill: '12.0mm', tapDrillDecimal: 0.4724, clearanceDrillClose: '15.0mm', clearanceDrillFree: '16.0mm'),
  TapDrillInfo(threadSize: 'M16', pitch: '2.0', tapDrill: '14.0mm', tapDrillDecimal: 0.5512, clearanceDrillClose: '17.0mm', clearanceDrillFree: '18.0mm'),
  TapDrillInfo(threadSize: 'M18', pitch: '2.5', tapDrill: '15.5mm', tapDrillDecimal: 0.6102, clearanceDrillClose: '19.0mm', clearanceDrillFree: '20.0mm'),
  TapDrillInfo(threadSize: 'M20', pitch: '2.5', tapDrill: '17.5mm', tapDrillDecimal: 0.6890, clearanceDrillClose: '21.0mm', clearanceDrillFree: '22.0mm'),
  TapDrillInfo(threadSize: 'M22', pitch: '2.5', tapDrill: '19.5mm', tapDrillDecimal: 0.7677, clearanceDrillClose: '23.0mm', clearanceDrillFree: '24.0mm'),
  TapDrillInfo(threadSize: 'M24', pitch: '3.0', tapDrill: '21.0mm', tapDrillDecimal: 0.8268, clearanceDrillClose: '25.0mm', clearanceDrillFree: '26.0mm'),
  TapDrillInfo(threadSize: 'M27', pitch: '3.0', tapDrill: '24.0mm', tapDrillDecimal: 0.9449, clearanceDrillClose: '28.0mm', clearanceDrillFree: '30.0mm'),
  TapDrillInfo(threadSize: 'M30', pitch: '3.5', tapDrill: '26.5mm', tapDrillDecimal: 1.0433, clearanceDrillClose: '31.0mm', clearanceDrillFree: '33.0mm'),
];

// Metric Fine Thread Tap Drill Chart
const List<TapDrillInfo> metricFineTapDrills = [
  TapDrillInfo(threadSize: 'M3x0.35', pitch: '0.35', tapDrill: '2.65mm', tapDrillDecimal: 0.1043, clearanceDrillClose: '3.2mm', clearanceDrillFree: '3.4mm'),
  TapDrillInfo(threadSize: 'M4x0.5', pitch: '0.5', tapDrill: '3.5mm', tapDrillDecimal: 0.1378, clearanceDrillClose: '4.3mm', clearanceDrillFree: '4.5mm'),
  TapDrillInfo(threadSize: 'M5x0.5', pitch: '0.5', tapDrill: '4.5mm', tapDrillDecimal: 0.1772, clearanceDrillClose: '5.3mm', clearanceDrillFree: '5.5mm'),
  TapDrillInfo(threadSize: 'M6x0.75', pitch: '0.75', tapDrill: '5.25mm', tapDrillDecimal: 0.2067, clearanceDrillClose: '6.4mm', clearanceDrillFree: '6.6mm'),
  TapDrillInfo(threadSize: 'M8x1.0', pitch: '1.0', tapDrill: '7.0mm', tapDrillDecimal: 0.2756, clearanceDrillClose: '8.4mm', clearanceDrillFree: '9.0mm'),
  TapDrillInfo(threadSize: 'M10x1.0', pitch: '1.0', tapDrill: '9.0mm', tapDrillDecimal: 0.3543, clearanceDrillClose: '10.5mm', clearanceDrillFree: '11.0mm'),
  TapDrillInfo(threadSize: 'M10x1.25', pitch: '1.25', tapDrill: '8.75mm', tapDrillDecimal: 0.3445, clearanceDrillClose: '10.5mm', clearanceDrillFree: '11.0mm'),
  TapDrillInfo(threadSize: 'M12x1.25', pitch: '1.25', tapDrill: '10.8mm', tapDrillDecimal: 0.4252, clearanceDrillClose: '13.0mm', clearanceDrillFree: '14.0mm'),
  TapDrillInfo(threadSize: 'M12x1.5', pitch: '1.5', tapDrill: '10.5mm', tapDrillDecimal: 0.4134, clearanceDrillClose: '13.0mm', clearanceDrillFree: '14.0mm'),
  TapDrillInfo(threadSize: 'M14x1.5', pitch: '1.5', tapDrill: '12.5mm', tapDrillDecimal: 0.4921, clearanceDrillClose: '15.0mm', clearanceDrillFree: '16.0mm'),
  TapDrillInfo(threadSize: 'M16x1.5', pitch: '1.5', tapDrill: '14.5mm', tapDrillDecimal: 0.5709, clearanceDrillClose: '17.0mm', clearanceDrillFree: '18.0mm'),
  TapDrillInfo(threadSize: 'M18x1.5', pitch: '1.5', tapDrill: '16.5mm', tapDrillDecimal: 0.6496, clearanceDrillClose: '19.0mm', clearanceDrillFree: '20.0mm'),
  TapDrillInfo(threadSize: 'M20x1.5', pitch: '1.5', tapDrill: '18.5mm', tapDrillDecimal: 0.7283, clearanceDrillClose: '21.0mm', clearanceDrillFree: '22.0mm'),
  TapDrillInfo(threadSize: 'M20x2.0', pitch: '2.0', tapDrill: '18.0mm', tapDrillDecimal: 0.7087, clearanceDrillClose: '21.0mm', clearanceDrillFree: '22.0mm'),
  TapDrillInfo(threadSize: 'M24x2.0', pitch: '2.0', tapDrill: '22.0mm', tapDrillDecimal: 0.8661, clearanceDrillClose: '25.0mm', clearanceDrillFree: '26.0mm'),
];

// Pipe Tap Drill Chart (NPT)
const List<TapDrillInfo> nptTapDrills = [
  TapDrillInfo(threadSize: '1/8" NPT', pitch: '27', tapDrill: 'R (0.339")', tapDrillDecimal: 0.3390, clearanceDrillClose: '23/64"', clearanceDrillFree: '3/8"'),
  TapDrillInfo(threadSize: '1/4" NPT', pitch: '18', tapDrill: '7/16"', tapDrillDecimal: 0.4375, clearanceDrillClose: '29/64"', clearanceDrillFree: '15/32"'),
  TapDrillInfo(threadSize: '3/8" NPT', pitch: '18', tapDrill: '37/64"', tapDrillDecimal: 0.5781, clearanceDrillClose: '19/32"', clearanceDrillFree: '5/8"'),
  TapDrillInfo(threadSize: '1/2" NPT', pitch: '14', tapDrill: '23/32"', tapDrillDecimal: 0.7188, clearanceDrillClose: '3/4"', clearanceDrillFree: '25/32"'),
  TapDrillInfo(threadSize: '3/4" NPT', pitch: '14', tapDrill: '59/64"', tapDrillDecimal: 0.9219, clearanceDrillClose: '15/16"', clearanceDrillFree: '31/32"'),
  TapDrillInfo(threadSize: '1" NPT', pitch: '11.5', tapDrill: '1-5/32"', tapDrillDecimal: 1.1563, clearanceDrillClose: '1-3/16"', clearanceDrillFree: '1-7/32"'),
  TapDrillInfo(threadSize: '1-1/4" NPT', pitch: '11.5', tapDrill: '1-1/2"', tapDrillDecimal: 1.5000, clearanceDrillClose: '1-17/32"', clearanceDrillFree: '1-9/16"'),
  TapDrillInfo(threadSize: '1-1/2" NPT', pitch: '11.5', tapDrill: '1-23/32"', tapDrillDecimal: 1.7188, clearanceDrillClose: '1-3/4"', clearanceDrillFree: '1-25/32"'),
  TapDrillInfo(threadSize: '2" NPT', pitch: '11.5', tapDrill: '2-7/32"', tapDrillDecimal: 2.2188, clearanceDrillClose: '2-1/4"', clearanceDrillFree: '2-9/32"'),
];
