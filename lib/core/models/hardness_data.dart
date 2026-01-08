// Material Hardness Conversion Data
class HardnessConversion {
  final double rockwellC; // HRC
  final double rockwellB; // HRB (if applicable, -1 if not)
  final double brinell; // HB
  final double vickers; // HV
  final int tensileApprox; // Approximate tensile strength (ksi)

  const HardnessConversion({
    required this.rockwellC,
    this.rockwellB = -1,
    required this.brinell,
    required this.vickers,
    required this.tensileApprox,
  });
}

// Hardness conversion table (standard steel values)
const List<HardnessConversion> hardnessTable = [
  HardnessConversion(rockwellC: 68, brinell: 739, vickers: 940, tensileApprox: 0), // Too hard for tensile
  HardnessConversion(rockwellC: 67, brinell: 722, vickers: 900, tensileApprox: 0),
  HardnessConversion(rockwellC: 66, brinell: 705, vickers: 865, tensileApprox: 0),
  HardnessConversion(rockwellC: 65, brinell: 688, vickers: 832, tensileApprox: 0),
  HardnessConversion(rockwellC: 64, brinell: 670, vickers: 800, tensileApprox: 0),
  HardnessConversion(rockwellC: 63, brinell: 654, vickers: 772, tensileApprox: 0),
  HardnessConversion(rockwellC: 62, brinell: 634, vickers: 746, tensileApprox: 0),
  HardnessConversion(rockwellC: 61, brinell: 615, vickers: 720, tensileApprox: 0),
  HardnessConversion(rockwellC: 60, brinell: 595, vickers: 697, tensileApprox: 351),
  HardnessConversion(rockwellC: 59, brinell: 577, vickers: 674, tensileApprox: 338),
  HardnessConversion(rockwellC: 58, brinell: 560, vickers: 653, tensileApprox: 325),
  HardnessConversion(rockwellC: 57, brinell: 543, vickers: 633, tensileApprox: 313),
  HardnessConversion(rockwellC: 56, brinell: 525, vickers: 613, tensileApprox: 301),
  HardnessConversion(rockwellC: 55, brinell: 512, vickers: 595, tensileApprox: 292),
  HardnessConversion(rockwellC: 54, brinell: 496, vickers: 577, tensileApprox: 283),
  HardnessConversion(rockwellC: 53, brinell: 481, vickers: 560, tensileApprox: 273),
  HardnessConversion(rockwellC: 52, brinell: 469, vickers: 544, tensileApprox: 266),
  HardnessConversion(rockwellC: 51, brinell: 455, vickers: 528, tensileApprox: 257),
  HardnessConversion(rockwellC: 50, brinell: 444, vickers: 513, tensileApprox: 250),
  HardnessConversion(rockwellC: 49, brinell: 432, vickers: 498, tensileApprox: 243),
  HardnessConversion(rockwellC: 48, brinell: 421, vickers: 484, tensileApprox: 237),
  HardnessConversion(rockwellC: 47, brinell: 409, vickers: 471, tensileApprox: 231),
  HardnessConversion(rockwellC: 46, brinell: 400, vickers: 458, tensileApprox: 225),
  HardnessConversion(rockwellC: 45, brinell: 390, vickers: 446, tensileApprox: 219),
  HardnessConversion(rockwellC: 44, brinell: 381, vickers: 434, tensileApprox: 213),
  HardnessConversion(rockwellC: 43, brinell: 371, vickers: 423, tensileApprox: 208),
  HardnessConversion(rockwellC: 42, brinell: 362, vickers: 412, tensileApprox: 203),
  HardnessConversion(rockwellC: 41, brinell: 353, vickers: 402, tensileApprox: 198),
  HardnessConversion(rockwellC: 40, brinell: 344, vickers: 392, tensileApprox: 193),
  HardnessConversion(rockwellC: 39, brinell: 336, vickers: 382, tensileApprox: 188),
  HardnessConversion(rockwellC: 38, brinell: 327, vickers: 372, tensileApprox: 184),
  HardnessConversion(rockwellC: 37, brinell: 319, vickers: 363, tensileApprox: 179),
  HardnessConversion(rockwellC: 36, brinell: 311, vickers: 354, tensileApprox: 175),
  HardnessConversion(rockwellC: 35, brinell: 302, vickers: 345, tensileApprox: 170),
  HardnessConversion(rockwellC: 34, brinell: 294, vickers: 336, tensileApprox: 166),
  HardnessConversion(rockwellC: 33, brinell: 286, vickers: 327, tensileApprox: 162),
  HardnessConversion(rockwellC: 32, brinell: 279, vickers: 318, tensileApprox: 158),
  HardnessConversion(rockwellC: 31, brinell: 271, vickers: 310, tensileApprox: 154),
  HardnessConversion(rockwellC: 30, brinell: 264, vickers: 302, tensileApprox: 150),
  HardnessConversion(rockwellC: 29, brinell: 258, vickers: 294, tensileApprox: 147),
  HardnessConversion(rockwellC: 28, brinell: 253, vickers: 286, tensileApprox: 144),
  HardnessConversion(rockwellC: 27, brinell: 247, vickers: 279, tensileApprox: 141),
  HardnessConversion(rockwellC: 26, brinell: 241, vickers: 272, tensileApprox: 138),
  HardnessConversion(rockwellC: 25, brinell: 235, vickers: 266, tensileApprox: 135),
  HardnessConversion(rockwellC: 24, brinell: 229, vickers: 260, tensileApprox: 132),
  HardnessConversion(rockwellC: 23, brinell: 223, vickers: 254, tensileApprox: 129),
  HardnessConversion(rockwellC: 22, brinell: 217, vickers: 248, tensileApprox: 126),
  HardnessConversion(rockwellC: 21, brinell: 212, vickers: 243, tensileApprox: 123),
  HardnessConversion(rockwellC: 20, brinell: 207, vickers: 238, tensileApprox: 120),
];

// Common material hardness ranges
class MaterialHardness {
  final String material;
  final String condition;
  final String hrcRange;
  final String hrbRange;
  final String brinellRange;

  const MaterialHardness({
    required this.material,
    required this.condition,
    required this.hrcRange,
    required this.hrbRange,
    required this.brinellRange,
  });
}

const List<MaterialHardness> commonHardnesses = [
  MaterialHardness(
    material: 'Mild Steel (1018)',
    condition: 'Annealed',
    hrcRange: 'N/A',
    hrbRange: '71',
    brinellRange: '126',
  ),
  MaterialHardness(
    material: 'Medium Carbon (1045)',
    condition: 'Annealed',
    hrcRange: 'N/A',
    hrbRange: '84',
    brinellRange: '163',
  ),
  MaterialHardness(
    material: 'Medium Carbon (1045)',
    condition: 'Q&T',
    hrcRange: '45-55',
    hrbRange: 'N/A',
    brinellRange: '420-560',
  ),
  MaterialHardness(
    material: 'Alloy Steel (4140)',
    condition: 'Annealed',
    hrcRange: 'N/A',
    hrbRange: '92',
    brinellRange: '197',
  ),
  MaterialHardness(
    material: 'Alloy Steel (4140)',
    condition: 'Q&T 400°F',
    hrcRange: '54-59',
    hrbRange: 'N/A',
    brinellRange: '500-580',
  ),
  MaterialHardness(
    material: 'Tool Steel (D2)',
    condition: 'Hardened',
    hrcRange: '58-62',
    hrbRange: 'N/A',
    brinellRange: '555-640',
  ),
  MaterialHardness(
    material: 'Tool Steel (O1)',
    condition: 'Hardened',
    hrcRange: '57-62',
    hrbRange: 'N/A',
    brinellRange: '540-640',
  ),
  MaterialHardness(
    material: 'Stainless (304)',
    condition: 'Annealed',
    hrcRange: 'N/A',
    hrbRange: '70-88',
    brinellRange: '123-170',
  ),
  MaterialHardness(
    material: 'Stainless (440C)',
    condition: 'Hardened',
    hrcRange: '58-60',
    hrbRange: 'N/A',
    brinellRange: '555-615',
  ),
  MaterialHardness(
    material: 'Aluminum (6061)',
    condition: 'T6',
    hrcRange: 'N/A',
    hrbRange: '60',
    brinellRange: '95',
  ),
  MaterialHardness(
    material: 'Brass (C36000)',
    condition: 'Half-hard',
    hrcRange: 'N/A',
    hrbRange: '70',
    brinellRange: '120',
  ),
  MaterialHardness(
    material: 'Cast Iron (Gray)',
    condition: 'As cast',
    hrcRange: 'N/A',
    hrbRange: '80-100',
    brinellRange: '150-250',
  ),
];

// Hardness test methods info
class HardnessTest {
  final String name;
  final String code;
  final String indenter;
  final String load;
  final List<String> bestFor;

  const HardnessTest({
    required this.name,
    required this.code,
    required this.indenter,
    required this.load,
    required this.bestFor,
  });
}

const List<HardnessTest> hardnessTests = [
  HardnessTest(
    name: 'Rockwell C',
    code: 'HRC',
    indenter: 'Diamond cone (120°)',
    load: '150 kgf',
    bestFor: ['Hardened steel', 'Tool steel', 'Hard alloys', 'HRC 20-70'],
  ),
  HardnessTest(
    name: 'Rockwell B',
    code: 'HRB',
    indenter: '1/16" steel ball',
    load: '100 kgf',
    bestFor: ['Soft steel', 'Brass', 'Aluminum', 'HRB 0-100'],
  ),
  HardnessTest(
    name: 'Brinell',
    code: 'HB / BHN',
    indenter: '10mm steel/carbide ball',
    load: '3000 kgf (steel)',
    bestFor: ['Cast iron', 'Forgings', 'Large parts', 'Coarse grain'],
  ),
  HardnessTest(
    name: 'Vickers',
    code: 'HV',
    indenter: 'Diamond pyramid (136°)',
    load: '1-120 kgf',
    bestFor: ['All materials', 'Small parts', 'Surface hardness', 'Case depth'],
  ),
];
