// O-Ring Size Data - AS568 Standard
class ORingSize {
  final String dashNumber;
  final double idInches;
  final double csInches; // Cross-section
  final double idMm;
  final double csMm;

  const ORingSize({
    required this.dashNumber,
    required this.idInches,
    required this.csInches,
    required this.idMm,
    required this.csMm,
  });

  double get odInches => idInches + (2 * csInches);
  double get odMm => idMm + (2 * csMm);
}

// AS568 Standard O-Ring Sizes (common sizes)
const List<ORingSize> oRingSizes = [
  // -001 to -050 series (1/16" cross-section)
  ORingSize(dashNumber: '-001', idInches: 0.029, csInches: 0.040, idMm: 0.74, csMm: 1.02),
  ORingSize(dashNumber: '-002', idInches: 0.042, csInches: 0.050, idMm: 1.07, csMm: 1.27),
  ORingSize(dashNumber: '-003', idInches: 0.056, csInches: 0.060, idMm: 1.42, csMm: 1.52),
  ORingSize(dashNumber: '-004', idInches: 0.070, csInches: 0.070, idMm: 1.78, csMm: 1.78),
  ORingSize(dashNumber: '-005', idInches: 0.101, csInches: 0.070, idMm: 2.57, csMm: 1.78),
  ORingSize(dashNumber: '-006', idInches: 0.114, csInches: 0.070, idMm: 2.90, csMm: 1.78),
  ORingSize(dashNumber: '-007', idInches: 0.145, csInches: 0.070, idMm: 3.68, csMm: 1.78),
  ORingSize(dashNumber: '-008', idInches: 0.176, csInches: 0.070, idMm: 4.47, csMm: 1.78),
  ORingSize(dashNumber: '-009', idInches: 0.208, csInches: 0.070, idMm: 5.28, csMm: 1.78),
  ORingSize(dashNumber: '-010', idInches: 0.239, csInches: 0.070, idMm: 6.07, csMm: 1.78),
  ORingSize(dashNumber: '-011', idInches: 0.301, csInches: 0.070, idMm: 7.65, csMm: 1.78),
  ORingSize(dashNumber: '-012', idInches: 0.364, csInches: 0.070, idMm: 9.25, csMm: 1.78),
  ORingSize(dashNumber: '-013', idInches: 0.426, csInches: 0.070, idMm: 10.82, csMm: 1.78),
  ORingSize(dashNumber: '-014', idInches: 0.489, csInches: 0.070, idMm: 12.42, csMm: 1.78),
  ORingSize(dashNumber: '-015', idInches: 0.551, csInches: 0.070, idMm: 14.00, csMm: 1.78),

  // -100 series (3/32" cross-section)
  ORingSize(dashNumber: '-102', idInches: 0.049, csInches: 0.103, idMm: 1.24, csMm: 2.62),
  ORingSize(dashNumber: '-103', idInches: 0.081, csInches: 0.103, idMm: 2.06, csMm: 2.62),
  ORingSize(dashNumber: '-104', idInches: 0.112, csInches: 0.103, idMm: 2.84, csMm: 2.62),
  ORingSize(dashNumber: '-105', idInches: 0.143, csInches: 0.103, idMm: 3.63, csMm: 2.62),
  ORingSize(dashNumber: '-106', idInches: 0.174, csInches: 0.103, idMm: 4.42, csMm: 2.62),
  ORingSize(dashNumber: '-107', idInches: 0.206, csInches: 0.103, idMm: 5.23, csMm: 2.62),
  ORingSize(dashNumber: '-108', idInches: 0.237, csInches: 0.103, idMm: 6.02, csMm: 2.62),
  ORingSize(dashNumber: '-109', idInches: 0.299, csInches: 0.103, idMm: 7.59, csMm: 2.62),
  ORingSize(dashNumber: '-110', idInches: 0.362, csInches: 0.103, idMm: 9.19, csMm: 2.62),
  ORingSize(dashNumber: '-111', idInches: 0.424, csInches: 0.103, idMm: 10.77, csMm: 2.62),
  ORingSize(dashNumber: '-112', idInches: 0.487, csInches: 0.103, idMm: 12.37, csMm: 2.62),
  ORingSize(dashNumber: '-113', idInches: 0.549, csInches: 0.103, idMm: 13.94, csMm: 2.62),
  ORingSize(dashNumber: '-114', idInches: 0.612, csInches: 0.103, idMm: 15.54, csMm: 2.62),
  ORingSize(dashNumber: '-115', idInches: 0.674, csInches: 0.103, idMm: 17.12, csMm: 2.62),
  ORingSize(dashNumber: '-116', idInches: 0.737, csInches: 0.103, idMm: 18.72, csMm: 2.62),

  // -200 series (1/8" cross-section)
  ORingSize(dashNumber: '-201', idInches: 0.171, csInches: 0.139, idMm: 4.34, csMm: 3.53),
  ORingSize(dashNumber: '-202', idInches: 0.234, csInches: 0.139, idMm: 5.94, csMm: 3.53),
  ORingSize(dashNumber: '-203', idInches: 0.296, csInches: 0.139, idMm: 7.52, csMm: 3.53),
  ORingSize(dashNumber: '-204', idInches: 0.359, csInches: 0.139, idMm: 9.12, csMm: 3.53),
  ORingSize(dashNumber: '-205', idInches: 0.421, csInches: 0.139, idMm: 10.69, csMm: 3.53),
  ORingSize(dashNumber: '-206', idInches: 0.484, csInches: 0.139, idMm: 12.29, csMm: 3.53),
  ORingSize(dashNumber: '-207', idInches: 0.546, csInches: 0.139, idMm: 13.87, csMm: 3.53),
  ORingSize(dashNumber: '-208', idInches: 0.609, csInches: 0.139, idMm: 15.47, csMm: 3.53),
  ORingSize(dashNumber: '-209', idInches: 0.671, csInches: 0.139, idMm: 17.04, csMm: 3.53),
  ORingSize(dashNumber: '-210', idInches: 0.734, csInches: 0.139, idMm: 18.64, csMm: 3.53),
  ORingSize(dashNumber: '-211', idInches: 0.796, csInches: 0.139, idMm: 20.22, csMm: 3.53),
  ORingSize(dashNumber: '-212', idInches: 0.859, csInches: 0.139, idMm: 21.82, csMm: 3.53),
  ORingSize(dashNumber: '-213', idInches: 0.921, csInches: 0.139, idMm: 23.39, csMm: 3.53),
  ORingSize(dashNumber: '-214', idInches: 0.984, csInches: 0.139, idMm: 24.99, csMm: 3.53),
  ORingSize(dashNumber: '-215', idInches: 1.046, csInches: 0.139, idMm: 26.57, csMm: 3.53),

  // -300 series (3/16" cross-section)
  ORingSize(dashNumber: '-309', idInches: 0.412, csInches: 0.210, idMm: 10.46, csMm: 5.33),
  ORingSize(dashNumber: '-310', idInches: 0.475, csInches: 0.210, idMm: 12.07, csMm: 5.33),
  ORingSize(dashNumber: '-311', idInches: 0.537, csInches: 0.210, idMm: 13.64, csMm: 5.33),
  ORingSize(dashNumber: '-312', idInches: 0.600, csInches: 0.210, idMm: 15.24, csMm: 5.33),
  ORingSize(dashNumber: '-313', idInches: 0.662, csInches: 0.210, idMm: 16.81, csMm: 5.33),
  ORingSize(dashNumber: '-314', idInches: 0.725, csInches: 0.210, idMm: 18.42, csMm: 5.33),
  ORingSize(dashNumber: '-315', idInches: 0.787, csInches: 0.210, idMm: 19.99, csMm: 5.33),
  ORingSize(dashNumber: '-316', idInches: 0.850, csInches: 0.210, idMm: 21.59, csMm: 5.33),
  ORingSize(dashNumber: '-317', idInches: 0.912, csInches: 0.210, idMm: 23.16, csMm: 5.33),
  ORingSize(dashNumber: '-318', idInches: 0.975, csInches: 0.210, idMm: 24.77, csMm: 5.33),
  ORingSize(dashNumber: '-319', idInches: 1.037, csInches: 0.210, idMm: 26.34, csMm: 5.33),
  ORingSize(dashNumber: '-320', idInches: 1.100, csInches: 0.210, idMm: 27.94, csMm: 5.33),

  // -400 series (1/4" cross-section)
  ORingSize(dashNumber: '-417', idInches: 1.475, csInches: 0.275, idMm: 37.47, csMm: 6.99),
  ORingSize(dashNumber: '-418', idInches: 1.600, csInches: 0.275, idMm: 40.64, csMm: 6.99),
  ORingSize(dashNumber: '-419', idInches: 1.725, csInches: 0.275, idMm: 43.82, csMm: 6.99),
  ORingSize(dashNumber: '-420', idInches: 1.850, csInches: 0.275, idMm: 46.99, csMm: 6.99),
  ORingSize(dashNumber: '-421', idInches: 1.975, csInches: 0.275, idMm: 50.17, csMm: 6.99),
  ORingSize(dashNumber: '-422', idInches: 2.100, csInches: 0.275, idMm: 53.34, csMm: 6.99),
  ORingSize(dashNumber: '-423', idInches: 2.225, csInches: 0.275, idMm: 56.52, csMm: 6.99),
  ORingSize(dashNumber: '-424', idInches: 2.350, csInches: 0.275, idMm: 59.69, csMm: 6.99),
  ORingSize(dashNumber: '-425', idInches: 2.475, csInches: 0.275, idMm: 62.87, csMm: 6.99),
];

// O-Ring Material Properties
class ORingMaterial {
  final String name;
  final String code;
  final int minTemp; // °F
  final int maxTemp; // °F
  final List<String> compatible;
  final List<String> notFor;

  const ORingMaterial({
    required this.name,
    required this.code,
    required this.minTemp,
    required this.maxTemp,
    required this.compatible,
    required this.notFor,
  });
}

const List<ORingMaterial> oRingMaterials = [
  ORingMaterial(
    name: 'Buna-N (Nitrile)',
    code: 'NBR',
    minTemp: -40,
    maxTemp: 250,
    compatible: ['Petroleum oils', 'Water', 'Hydraulic fluids', 'Air'],
    notFor: ['Ozone', 'Ketones', 'Strong acids', 'Brake fluid'],
  ),
  ORingMaterial(
    name: 'Viton (Fluorocarbon)',
    code: 'FKM',
    minTemp: -15,
    maxTemp: 400,
    compatible: ['Most chemicals', 'Fuels', 'Acids', 'High temp oils'],
    notFor: ['Ketones', 'Ammonia', 'Hot water steam'],
  ),
  ORingMaterial(
    name: 'EPDM',
    code: 'EPDM',
    minTemp: -65,
    maxTemp: 300,
    compatible: ['Water', 'Steam', 'Brake fluid', 'Phosphate esters'],
    notFor: ['Petroleum oils', 'Gasoline', 'Mineral oils'],
  ),
  ORingMaterial(
    name: 'Silicone',
    code: 'VMQ',
    minTemp: -80,
    maxTemp: 450,
    compatible: ['Air', 'Water', 'Food grade', 'High/low temp'],
    notFor: ['Petroleum oils', 'Fuels', 'High pressure'],
  ),
  ORingMaterial(
    name: 'Neoprene',
    code: 'CR',
    minTemp: -50,
    maxTemp: 250,
    compatible: ['Refrigerants', 'Moderate oils', 'Ozone', 'Weather'],
    notFor: ['Strong acids', 'Ketones', 'Chlorinated solvents'],
  ),
  ORingMaterial(
    name: 'PTFE (Teflon)',
    code: 'PTFE',
    minTemp: -100,
    maxTemp: 500,
    compatible: ['Almost all chemicals', 'Acids', 'Solvents'],
    notFor: ['Molten alkali metals', 'High pressure (low elasticity)'],
  ),
];

// Calculate groove dimensions for face seal
Map<String, double> calculateGrooveDimensions(double crossSection) {
  // Standard groove design (approx 25% squeeze)
  final grooveDepth = crossSection * 0.75;
  final grooveWidth = crossSection * 1.3;

  return {
    'depth': grooveDepth,
    'width': grooveWidth,
    'squeeze': (crossSection - grooveDepth) / crossSection * 100,
  };
}
