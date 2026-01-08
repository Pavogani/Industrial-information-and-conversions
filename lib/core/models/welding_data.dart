class WeldingRod {
  final String awsClass;
  final String commonName;
  final String material;
  final String polarity;
  final List<String> positions;
  final List<String> usage;
  final List<String> tips;
  final int tensileStrength; // PSI
  final String coatingType;

  const WeldingRod({
    required this.awsClass,
    required this.commonName,
    required this.material,
    required this.polarity,
    required this.positions,
    required this.usage,
    required this.tips,
    required this.tensileStrength,
    required this.coatingType,
  });
}

const List<WeldingRod> weldingRods = [
  WeldingRod(
    awsClass: 'E6010',
    commonName: '6010 / Fast Freeze',
    material: 'Carbon Steel',
    polarity: 'DCEP (DC+)',
    positions: ['All positions'],
    usage: [
      'Root passes in pipe welding',
      'Dirty or rusty metal',
      'Deep penetration needed',
      'Open root joints',
    ],
    tips: [
      'Use "whip and pause" technique',
      'Maintain tight arc length',
      'Good for outdoors/drafty areas',
      'Produces convex bead profile',
      'Slag is thin and easy to remove',
    ],
    tensileStrength: 60000,
    coatingType: 'High Cellulose Sodium',
  ),
  WeldingRod(
    awsClass: 'E6011',
    commonName: '6011 / All Purpose',
    material: 'Carbon Steel',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'General purpose welding',
      'Works on AC machines',
      'Rusty or painted surfaces',
      'Similar to 6010 but AC capable',
    ],
    tips: [
      'More forgiving than 6010',
      'Good for farm/home repairs',
      'Can run on AC buzz boxes',
      'Slightly less penetration than 6010',
    ],
    tensileStrength: 60000,
    coatingType: 'High Cellulose Potassium',
  ),
  WeldingRod(
    awsClass: 'E6013',
    commonName: '6013 / General Purpose',
    material: 'Carbon Steel',
    polarity: 'AC or DC (either)',
    positions: ['All positions'],
    usage: [
      'Sheet metal and thin materials',
      'General fabrication',
      'Clean, new metal',
      'Beginners learning to weld',
    ],
    tips: [
      'Easy arc starting',
      'Smooth, quiet arc',
      'Light to medium penetration',
      'Good bead appearance',
      'Not for structural work',
    ],
    tensileStrength: 60000,
    coatingType: 'High Titania Potassium',
  ),
  WeldingRod(
    awsClass: 'E7014',
    commonName: '7014 / Iron Powder',
    material: 'Carbon Steel',
    polarity: 'AC or DC (either)',
    positions: ['All positions'],
    usage: [
      'High deposition rate',
      'Flat and horizontal fillets',
      'General fabrication',
      'Medium to heavy sections',
    ],
    tips: [
      'Drag technique works well',
      'Higher deposition than 6013',
      'Iron powder increases efficiency',
      'Smooth, easy to control arc',
    ],
    tensileStrength: 70000,
    coatingType: 'Iron Powder, Titania',
  ),
  WeldingRod(
    awsClass: 'E7018',
    commonName: '7018 / Low Hydrogen',
    material: 'Carbon Steel',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'Structural steel (code work)',
      'Pressure vessels',
      'High-strength applications',
      'Crack-sensitive steels',
    ],
    tips: [
      'MUST keep rods dry (oven at 250-300°F)',
      'Use drag technique - short arc',
      'Do not whip - maintain puddle',
      'Most common structural rod',
      'Smooth, flat bead profile',
    ],
    tensileStrength: 70000,
    coatingType: 'Low Hydrogen Potassium',
  ),
  WeldingRod(
    awsClass: 'E7024',
    commonName: '7024 / Jet Rod',
    material: 'Carbon Steel',
    polarity: 'AC or DC (either)',
    positions: ['Flat and Horizontal only'],
    usage: [
      'High-speed horizontal fillets',
      'Production welding',
      'Heavy plate fabrication',
    ],
    tips: [
      'Very high deposition rate',
      'Can run at high amperage',
      'Self-releasing slag',
      'NOT for vertical or overhead',
    ],
    tensileStrength: 70000,
    coatingType: 'Iron Powder, Iron Oxide',
  ),
  WeldingRod(
    awsClass: 'E308L-16',
    commonName: '308L Stainless',
    material: '304 Stainless Steel',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'Welding 304 stainless to 304',
      'Food service equipment',
      'Chemical tanks',
    ],
    tips: [
      'Use lower amperage than carbon steel',
      'Keep arc short',
      'Clean base metal thoroughly',
      'L = Low carbon (prevents carbide precipitation)',
    ],
    tensileStrength: 75000,
    coatingType: 'Lime-Titania',
  ),
  WeldingRod(
    awsClass: 'E309L-16',
    commonName: '309L Stainless',
    material: 'Dissimilar Metals',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'Stainless to carbon steel',
      'Cladding',
      'First layer on dissimilar joints',
    ],
    tips: [
      'Buffer rod for dissimilar metals',
      'Higher alloy content than 308',
      'Great for repair work',
    ],
    tensileStrength: 75000,
    coatingType: 'Lime-Titania',
  ),
  WeldingRod(
    awsClass: 'ENiFe-CI',
    commonName: 'Nickel-Iron (Cast Iron)',
    material: 'Cast Iron',
    polarity: 'DCEP',
    positions: ['All positions'],
    usage: [
      'Cast iron repair',
      'Joining cast iron to steel',
      'Machine bases and housings',
    ],
    tips: [
      'Preheat casting (350-600°F)',
      'Use short beads (1-2")',
      'Peen while hot to relieve stress',
      'Let cool slowly - no quench',
      'Multiple thin passes',
    ],
    tensileStrength: 58000,
    coatingType: 'Special',
  ),
  WeldingRod(
    awsClass: 'E6012',
    commonName: '6012 / Fill-Freeze',
    material: 'Carbon Steel',
    polarity: 'AC or DC (either)',
    positions: ['All positions'],
    usage: [
      'Poor fit-up and gaps',
      'Bridging open root joints',
      'General fabrication',
      'Automotive body work',
    ],
    tips: [
      'Excellent for poor fit-up',
      'Good gap bridging ability',
      'Medium penetration',
      'Smooth arc, easy slag removal',
      'Good choice for beginners',
    ],
    tensileStrength: 60000,
    coatingType: 'High Titania Sodium',
  ),
  WeldingRod(
    awsClass: 'E7016',
    commonName: '7016 / Low Hydrogen',
    material: 'Carbon Steel',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'Structural applications',
      'Pressure vessels',
      'When 7018 not available',
      'All position structural',
    ],
    tips: [
      'Similar to 7018 but AC capable',
      'Keep dry like 7018',
      'Slightly different arc characteristics',
      'Good for field work with AC only',
    ],
    tensileStrength: 70000,
    coatingType: 'Low Hydrogen Potassium',
  ),
  WeldingRod(
    awsClass: 'E7018-1',
    commonName: '7018-1 / Low Hydrogen (Impact)',
    material: 'Carbon Steel',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'Low temperature service',
      'Impact-critical structures',
      'Offshore/arctic applications',
      'D1.1 structural code work',
    ],
    tips: [
      'Better impact toughness than standard 7018',
      'Must keep absolutely dry',
      'Premium structural rod',
      'Use rod oven at 250-300°F',
    ],
    tensileStrength: 70000,
    coatingType: 'Low Hydrogen Potassium (H4)',
  ),
  WeldingRod(
    awsClass: 'E310-16',
    commonName: '310 Stainless',
    material: '310 Stainless Steel',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'High temperature service',
      'Furnace parts',
      'Heat treating equipment',
      'Dissimilar stainless joints',
    ],
    tips: [
      'Higher chromium/nickel content',
      'Excellent high-temp properties',
      'Good for cladding',
      'More expensive than 308/309',
    ],
    tensileStrength: 80000,
    coatingType: 'Lime-Titania',
  ),
  WeldingRod(
    awsClass: 'E316L-16',
    commonName: '316L Stainless',
    material: '316 Stainless Steel',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'Marine applications',
      'Chemical processing',
      'Pharmaceutical equipment',
      'Corrosive environments',
    ],
    tips: [
      'Contains molybdenum for corrosion resistance',
      'Better pitting resistance than 308/304',
      'Use for 316 base metal',
      'L = Low carbon to prevent sensitization',
    ],
    tensileStrength: 75000,
    coatingType: 'Lime-Titania',
  ),
  WeldingRod(
    awsClass: 'ENi-CI',
    commonName: '99% Nickel (Cast Iron)',
    material: 'Cast Iron',
    polarity: 'DCEP',
    positions: ['All positions'],
    usage: [
      'Cast iron (machinable welds)',
      'Thin cast sections',
      'Critical cast iron repairs',
      'When machining is required',
    ],
    tips: [
      'Most machinable cast iron rod',
      'More expensive than NiFe',
      'Best for thin sections',
      'Preheat 300-500°F',
      'Very short beads, skip welding',
    ],
    tensileStrength: 55000,
    coatingType: 'Special',
  ),
  WeldingRod(
    awsClass: 'E4043',
    commonName: '4043 Aluminum',
    material: 'Aluminum',
    polarity: 'DCEP (TIG: AC)',
    positions: ['All positions'],
    usage: [
      'General aluminum welding',
      '6061 aluminum',
      'Automotive aluminum',
      'Most common aluminum filler',
    ],
    tips: [
      'Contains silicon for fluidity',
      'Good crack resistance',
      'Clean aluminum thoroughly before welding',
      'Use AC for TIG aluminum',
      'Shiny finish, not anodizable',
    ],
    tensileStrength: 28000,
    coatingType: 'N/A (Bare)',
  ),
  WeldingRod(
    awsClass: 'E5356',
    commonName: '5356 Aluminum',
    material: 'Aluminum',
    polarity: 'DCEP (TIG: AC)',
    positions: ['All positions'],
    usage: [
      '5xxx series aluminum',
      'Marine aluminum',
      'Structural aluminum',
      'When anodizing is needed',
    ],
    tips: [
      'Contains magnesium',
      'Better strength than 4043',
      'Can be anodized (color match)',
      'More crack sensitive than 4043',
      'Better for 5052, 5083, 5086',
    ],
    tensileStrength: 38000,
    coatingType: 'N/A (Bare)',
  ),
  WeldingRod(
    awsClass: 'ERCuSi-A',
    commonName: 'Silicon Bronze',
    material: 'Bronze/Dissimilar',
    polarity: 'DCEP',
    positions: ['All positions'],
    usage: [
      'Galvanized steel (no zinc burn)',
      'Copper to steel',
      'Automotive body panels',
      'Sheet metal with minimal distortion',
    ],
    tips: [
      'Lower heat than steel welding',
      'Less distortion on thin material',
      'Does not burn through galvanizing',
      'Looks like brass when done',
      'Good gap-bridging ability',
    ],
    tensileStrength: 50000,
    coatingType: 'N/A (Bare)',
  ),
  WeldingRod(
    awsClass: 'E11018',
    commonName: '11018 / High Strength Low Hydrogen',
    material: 'High Strength Steel',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'High strength structural steel',
      'T-1 and similar steels',
      'Heavy equipment repair',
      'Where matching strength needed',
    ],
    tips: [
      '110 ksi tensile strength',
      'MUST preheat base metal',
      'Keep absolutely dry',
      'Use for A514, T-1 steels',
      'Slow cooling required',
    ],
    tensileStrength: 110000,
    coatingType: 'Low Hydrogen',
  ),
  WeldingRod(
    awsClass: 'E312-16',
    commonName: '312 Stainless',
    material: 'Dissimilar Metals',
    polarity: 'AC or DCEP',
    positions: ['All positions'],
    usage: [
      'Unknown stainless grades',
      'Difficult to weld stainless',
      'Dissimilar stainless joints',
      'Stainless repair work',
    ],
    tips: [
      'Most forgiving stainless rod',
      'High ferrite content',
      'Good for unknown base metals',
      'Crack resistant',
      'Higher strength than 308/309',
    ],
    tensileStrength: 95000,
    coatingType: 'Lime-Titania',
  ),
];

// MIG Wire Types
class MigWire {
  final String awsClass;
  final String commonName;
  final String material;
  final String shieldingGas;
  final List<String> usage;
  final List<String> tips;
  final int tensileStrength;

  const MigWire({
    required this.awsClass,
    required this.commonName,
    required this.material,
    required this.shieldingGas,
    required this.usage,
    required this.tips,
    required this.tensileStrength,
  });
}

const List<MigWire> migWires = [
  MigWire(
    awsClass: 'ER70S-6',
    commonName: '70S-6 Solid Wire',
    material: 'Carbon Steel',
    shieldingGas: '75/25 (Ar/CO2) or 100% CO2',
    usage: [
      'General purpose MIG welding',
      'Auto body and fabrication',
      'Structural steel',
      'Most common MIG wire',
    ],
    tips: [
      'Higher silicon/manganese for dirty steel',
      '75/25 gas = smoother arc, less spatter',
      '100% CO2 = deeper penetration, more spatter',
      'Great all-around wire',
    ],
    tensileStrength: 70000,
  ),
  MigWire(
    awsClass: 'ER70S-3',
    commonName: '70S-3 Solid Wire',
    material: 'Carbon Steel',
    shieldingGas: '75/25 (Ar/CO2) or 100% CO2',
    usage: [
      'Clean steel only',
      'Single pass welds',
      'Less demanding applications',
    ],
    tips: [
      'Lower deoxidizers than 70S-6',
      'Requires cleaner base metal',
      'Less forgiving than 70S-6',
      'Lower cost option',
    ],
    tensileStrength: 70000,
  ),
  MigWire(
    awsClass: 'E71T-1',
    commonName: 'Flux Core (Gas Shielded)',
    material: 'Carbon Steel',
    shieldingGas: '75/25 (Ar/CO2) or 100% CO2',
    usage: [
      'Heavy fabrication',
      'Structural steel',
      'High deposition rates',
      'Out of position welding',
    ],
    tips: [
      'Requires shielding gas',
      'Higher deposition than solid wire',
      'Produces slag like stick welding',
      'Good penetration',
    ],
    tensileStrength: 70000,
  ),
  MigWire(
    awsClass: 'E71T-11',
    commonName: 'Flux Core (Self Shielded)',
    material: 'Carbon Steel',
    shieldingGas: 'None (Self-Shielded)',
    usage: [
      'Outdoor/windy conditions',
      'Field repairs',
      'Farm and ranch',
      'No gas bottle needed',
    ],
    tips: [
      'No shielding gas required',
      'More spatter than gas-shielded',
      'Good for windy conditions',
      'DCEN polarity usually',
      'Not for critical structural',
    ],
    tensileStrength: 70000,
  ),
  MigWire(
    awsClass: 'ER308L',
    commonName: '308L Stainless MIG',
    material: '304 Stainless Steel',
    shieldingGas: '98/2 (Ar/CO2) or Tri-Mix',
    usage: [
      '304 stainless steel',
      'Food service equipment',
      'Sanitary welding',
    ],
    tips: [
      'Use tri-mix for best results',
      'Lower heat than carbon steel',
      'Clean base metal thoroughly',
      'Use stainless brush only',
    ],
    tensileStrength: 75000,
  ),
  MigWire(
    awsClass: 'ER4043',
    commonName: '4043 Aluminum MIG',
    material: 'Aluminum',
    shieldingGas: '100% Argon',
    usage: [
      '6061 aluminum',
      'General aluminum MIG',
      'Castings',
    ],
    tips: [
      'Use push technique',
      'High wire feed speed',
      'U-groove drive rolls',
      'Teflon liner in gun',
      'Clean aluminum before welding',
    ],
    tensileStrength: 28000,
  ),
];

// Weld Joint Types
class WeldJoint {
  final String name;
  final String description;
  final List<String> applications;
  final List<String> preparation;
  final String strengthRating;
  final List<String> tips;

  const WeldJoint({
    required this.name,
    required this.description,
    required this.applications,
    required this.preparation,
    required this.strengthRating,
    required this.tips,
  });
}

const List<WeldJoint> weldJoints = [
  WeldJoint(
    name: 'Butt Joint',
    description: 'Two pieces aligned edge to edge in the same plane',
    applications: [
      'Pipe welding',
      'Plate joining',
      'Structural connections',
      'Tank fabrication',
    ],
    preparation: [
      'Square edge: Up to 3/16" thick',
      'Single V: 3/16" to 3/4" (60-75° included)',
      'Double V: Over 3/4" thick',
      'Root opening: 0-1/8" depending on process',
    ],
    strengthRating: 'Excellent (100% joint efficiency possible)',
    tips: [
      'Full penetration critical for strength',
      'Back gouge and reweld for critical work',
      'Fit-up accuracy is critical',
      'Use backing bar or open root technique',
    ],
  ),
  WeldJoint(
    name: 'T-Joint / Fillet',
    description: 'One piece perpendicular to another forming a T shape',
    applications: [
      'Structural fabrication',
      'Machine frames',
      'Brackets and supports',
      'Most common joint type',
    ],
    preparation: [
      'No bevel needed for fillet welds',
      'Bevel for full penetration T-joints',
      'Clean mill scale and rust',
      'Ensure 90° angle',
    ],
    strengthRating: 'Good (fillet size determines strength)',
    tips: [
      'Fillet leg size typically = thinner material thickness',
      'Watch for undercut on vertical leg',
      '45° gun angle for equal leg fillets',
      'Multiple passes for larger fillets',
    ],
  ),
  WeldJoint(
    name: 'Lap Joint',
    description: 'Two overlapping pieces welded along the edge',
    applications: [
      'Sheet metal work',
      'Repair patches',
      'Non-critical connections',
      'Auto body work',
    ],
    preparation: [
      'Overlap: Typically 3-5x material thickness',
      'Clean mating surfaces',
      'Clamp to prevent gap',
      'No beveling required',
    ],
    strengthRating: 'Moderate (stress concentration at weld toe)',
    tips: [
      'Weld both sides when possible',
      'Prone to crevice corrosion',
      'Not ideal for fatigue loading',
      'Easy to fit and weld',
    ],
  ),
  WeldJoint(
    name: 'Corner Joint',
    description: 'Two pieces meeting at a corner, forming an L',
    applications: [
      'Box sections',
      'Frames and enclosures',
      'Sheet metal corners',
      'Architectural work',
    ],
    preparation: [
      'Open corner: Gap between pieces',
      'Closed corner: Pieces touch',
      'Half-open: Partial contact',
      'Bevel outside for full pen',
    ],
    strengthRating: 'Good (depends on configuration)',
    tips: [
      'Closed corners easier to weld',
      'Open corners need root pass',
      'Watch for burn-through on thin material',
      'Can weld inside, outside, or both',
    ],
  ),
  WeldJoint(
    name: 'Edge Joint',
    description: 'Two pieces with edges parallel and aligned',
    applications: [
      'Sheet metal flanges',
      'Non-load bearing',
      'Sealing applications',
      'Light gauge material',
    ],
    preparation: [
      'Edges aligned flush',
      'May need edge preparation on thick material',
      'Clean edges',
      'Tack at intervals',
    ],
    strengthRating: 'Poor (not for structural loads)',
    tips: [
      'Limited strength - not for loads',
      'Easy to weld',
      'Good for sealing',
      'Prone to burn-through',
    ],
  ),
];

// Welding Processes
class WeldingProcess {
  final String code;
  final String name;
  final String description;
  final List<String> advantages;
  final List<String> disadvantages;
  final List<String> bestFor;
  final String equipment;
  final String skillLevel;

  const WeldingProcess({
    required this.code,
    required this.name,
    required this.description,
    required this.advantages,
    required this.disadvantages,
    required this.bestFor,
    required this.equipment,
    required this.skillLevel,
  });
}

const List<WeldingProcess> weldingProcesses = [
  WeldingProcess(
    code: 'SMAW',
    name: 'Stick Welding',
    description: 'Shielded Metal Arc Welding - Uses flux-coated consumable electrode',
    advantages: [
      'Works outdoors/windy conditions',
      'Welds dirty/rusty metal',
      'Low equipment cost',
      'Highly portable',
      'All positions capable',
    ],
    disadvantages: [
      'Slower than MIG',
      'More skill required',
      'Slag must be removed',
      'Electrode stub waste',
      'Frequent rod changes',
    ],
    bestFor: [
      'Field repairs',
      'Structural steel',
      'Pipe welding',
      'Maintenance work',
      'Cast iron repair',
    ],
    equipment: 'Stick welder (transformer or inverter), electrode holder, ground clamp',
    skillLevel: 'Moderate to High',
  ),
  WeldingProcess(
    code: 'GMAW',
    name: 'MIG Welding',
    description: 'Gas Metal Arc Welding - Uses continuous solid wire and shielding gas',
    advantages: [
      'Fast and efficient',
      'Easy to learn',
      'Clean welds (no slag)',
      'Long continuous welds',
      'Good for thin materials',
    ],
    disadvantages: [
      'Requires shielding gas',
      'Not good in wind',
      'Equipment more complex',
      'Base metal must be clean',
      'Higher equipment cost',
    ],
    bestFor: [
      'Production welding',
      'Auto body work',
      'Sheet metal',
      'Fabrication shops',
      'Aluminum welding',
    ],
    equipment: 'MIG welder, wire feeder, gas cylinder, MIG gun, regulator',
    skillLevel: 'Low to Moderate',
  ),
  WeldingProcess(
    code: 'FCAW',
    name: 'Flux Core Welding',
    description: 'Flux Cored Arc Welding - Uses tubular wire with flux inside',
    advantages: [
      'High deposition rate',
      'Self-shielded option (no gas)',
      'Good penetration',
      'Works on dirty metal',
      'Outdoor capable',
    ],
    disadvantages: [
      'Produces slag',
      'More spatter than MIG',
      'Smoke/fumes',
      'Wire more expensive',
      'Not for thin material',
    ],
    bestFor: [
      'Structural steel',
      'Heavy fabrication',
      'Shipbuilding',
      'Outdoor construction',
      'Field erection',
    ],
    equipment: 'Wire feed welder, flux core wire, (gas for dual-shield)',
    skillLevel: 'Low to Moderate',
  ),
  WeldingProcess(
    code: 'GTAW',
    name: 'TIG Welding',
    description: 'Gas Tungsten Arc Welding - Uses non-consumable tungsten electrode',
    advantages: [
      'Highest quality welds',
      'Precise heat control',
      'No spatter',
      'Welds exotic metals',
      'Clean, beautiful welds',
    ],
    disadvantages: [
      'Slowest process',
      'High skill required',
      'Expensive equipment',
      'Requires very clean metal',
      'Not for thick material',
    ],
    bestFor: [
      'Stainless steel',
      'Aluminum (thin)',
      'Aerospace',
      'Food/pharmaceutical',
      'Pipe root passes',
    ],
    equipment: 'TIG welder, torch, tungsten electrodes, filler rods, argon gas',
    skillLevel: 'High',
  ),
  WeldingProcess(
    code: 'OAW',
    name: 'Oxy-Acetylene',
    description: 'Gas welding using oxygen and acetylene fuel gas',
    advantages: [
      'Very portable',
      'Also cuts and heats',
      'Good for brazing',
      'No electricity needed',
      'Visual puddle control',
    ],
    disadvantages: [
      'Slow process',
      'Limited to thin material',
      'Safety concerns (gas)',
      'Wide heat affected zone',
      'Lower weld quality',
    ],
    bestFor: [
      'Brazing',
      'Heating for bending',
      'Cutting',
      'Auto body (lead work)',
      'HVAC copper',
    ],
    equipment: 'Oxygen/acetylene cylinders, regulators, torch, tips, hoses',
    skillLevel: 'Moderate',
  ),
];

// Amperage Settings Guide
class AmperageGuide {
  final String rodSize;
  final String diameter;
  final int minAmps;
  final int maxAmps;
  final int typicalAmps;
  final String notes;

  const AmperageGuide({
    required this.rodSize,
    required this.diameter,
    required this.minAmps,
    required this.maxAmps,
    required this.typicalAmps,
    required this.notes,
  });
}

const List<AmperageGuide> amperageGuide6010 = [
  AmperageGuide(rodSize: '3/32"', diameter: '2.4mm', minAmps: 40, maxAmps: 80, typicalAmps: 60, notes: 'Thin material, root passes'),
  AmperageGuide(rodSize: '1/8"', diameter: '3.2mm', minAmps: 75, maxAmps: 130, typicalAmps: 100, notes: 'Most common size'),
  AmperageGuide(rodSize: '5/32"', diameter: '4.0mm', minAmps: 110, maxAmps: 170, typicalAmps: 140, notes: 'General purpose'),
  AmperageGuide(rodSize: '3/16"', diameter: '4.8mm', minAmps: 140, maxAmps: 210, typicalAmps: 175, notes: 'Heavy work'),
];

const List<AmperageGuide> amperageGuide7018 = [
  AmperageGuide(rodSize: '3/32"', diameter: '2.4mm', minAmps: 70, maxAmps: 100, typicalAmps: 85, notes: 'Thin material'),
  AmperageGuide(rodSize: '1/8"', diameter: '3.2mm', minAmps: 110, maxAmps: 150, typicalAmps: 130, notes: 'Most common size'),
  AmperageGuide(rodSize: '5/32"', diameter: '4.0mm', minAmps: 150, maxAmps: 210, typicalAmps: 180, notes: 'Fill passes'),
  AmperageGuide(rodSize: '3/16"', diameter: '4.8mm', minAmps: 200, maxAmps: 275, typicalAmps: 240, notes: 'Heavy structural'),
  AmperageGuide(rodSize: '7/32"', diameter: '5.6mm', minAmps: 260, maxAmps: 340, typicalAmps: 300, notes: 'Production welding'),
];

// Quick amperage rule of thumb
String amperageRuleOfThumb(double rodDiameterInches) {
  // Rule: 1 amp per 0.001" of rod diameter
  final amps = (rodDiameterInches * 1000).round();
  return '~$amps amps (±15%)';
}

// Electrode number decoder
class ElectrodeDecoder {
  static String decode(String electrode) {
    if (!electrode.startsWith('E') || electrode.length < 4) {
      return 'Invalid electrode number';
    }

    final number = electrode.substring(1);
    if (number.length < 4) return 'Invalid electrode number';

    // First two or three digits = tensile strength (ksi)
    final tensile = number.length == 4
        ? '${number.substring(0, 2)},000 PSI'
        : '${number.substring(0, 3)},000 PSI';

    // Third digit (or 4th for 5-digit) = positions
    final posDigit = number.length == 4 ? number[2] : number[3];
    String positions;
    switch (posDigit) {
      case '1':
        positions = 'All positions';
        break;
      case '2':
        positions = 'Flat and Horizontal only';
        break;
      case '4':
        positions = 'All positions (vertical down OK)';
        break;
      default:
        positions = 'Check manufacturer specs';
    }

    // Last digit = coating and current type
    final coatingDigit = number.length == 4 ? number[3] : number[4];
    String coating;
    switch (coatingDigit) {
      case '0':
        coating = 'High cellulose sodium (DCEP only)';
        break;
      case '1':
        coating = 'High cellulose potassium (AC or DCEP)';
        break;
      case '2':
        coating = 'High titania sodium (AC or DCEN)';
        break;
      case '3':
        coating = 'High titania potassium (AC or DC either)';
        break;
      case '4':
        coating = 'Iron powder titania (AC or DC either)';
        break;
      case '5':
        coating = 'Low hydrogen sodium (DCEP only)';
        break;
      case '6':
        coating = 'Low hydrogen potassium (AC or DCEP)';
        break;
      case '7':
        coating = 'Iron powder iron oxide (AC or DC either)';
        break;
      case '8':
        coating = 'Low hydrogen iron powder (AC or DCEP)';
        break;
      default:
        coating = 'Check manufacturer specs';
    }

    return '''
Tensile Strength: $tensile
Position: $positions
Coating/Current: $coating''';
  }
}

// Torch/Acetylene data
class FlameType {
  final String name;
  final String appearance;
  final List<String> uses;
  final String oxyRatio;
  final List<String> tips;

  const FlameType({
    required this.name,
    required this.appearance,
    required this.uses,
    required this.oxyRatio,
    required this.tips,
  });
}

const List<FlameType> flameTypes = [
  FlameType(
    name: 'Neutral Flame',
    appearance: 'Rounded inner cone, light blue outer flame',
    uses: [
      'Most welding applications',
      'Steel and stainless steel',
      'Copper and copper alloys',
      'General purpose cutting',
    ],
    oxyRatio: '1:1 (Oxygen to Acetylene)',
    tips: [
      'Inner cone clearly defined',
      'No acetylene feather',
      'Most commonly used flame',
      'Best heat control',
    ],
  ),
  FlameType(
    name: 'Carburizing (Reducing)',
    appearance: 'White feather around inner cone, excess acetylene',
    uses: [
      'Hardfacing',
      'Silver brazing',
      'High-carbon steels',
      'Adding carbon to surface',
    ],
    oxyRatio: 'Excess Acetylene',
    tips: [
      'Feather 2-3x inner cone length',
      'Sooty, carbon-rich flame',
      'Lower temperature than neutral',
      'Never use on steel (causes brittleness)',
    ],
  ),
  FlameType(
    name: 'Oxidizing Flame',
    appearance: 'Short, pointed inner cone, hissing sound',
    uses: [
      'Brass and bronze welding',
      'Some brazing applications',
      'Cutting (not welding steel)',
    ],
    oxyRatio: 'Excess Oxygen',
    tips: [
      'Hottest flame type',
      'Causes oxidation/burning of steel',
      'Creates porous, weak welds on steel',
      'Small inner cone, loud hiss',
    ],
  ),
];

// Brazing data
class BrazingInfo {
  final String fillMetal;
  final String fluxType;
  final int tempRange; // °F
  final List<String> baseMaterials;
  final List<String> tips;

  const BrazingInfo({
    required this.fillMetal,
    required this.fluxType,
    required this.tempRange,
    required this.baseMaterials,
    required this.tips,
  });
}

const List<BrazingInfo> brazingData = [
  BrazingInfo(
    fillMetal: 'Silver Brazing Alloy (BAg)',
    fluxType: 'White flux paste',
    tempRange: 1145,
    baseMaterials: ['Steel', 'Stainless', 'Copper', 'Brass'],
    tips: [
      'Use neutral to slightly carburizing flame',
      'Heat base metal, let filler flow by capillary action',
      'Silver follows the heat',
      'Clean joint - flux is not a cleaner',
    ],
  ),
  BrazingInfo(
    fillMetal: 'Brass Rod (RBCuZn)',
    fluxType: 'Brazing flux',
    tempRange: 1630,
    baseMaterials: ['Steel', 'Cast iron', 'Copper'],
    tips: [
      'Use slightly oxidizing flame',
      'Higher temp than silver braze',
      'Good gap-filling ability',
      'Common for automotive/repair work',
    ],
  ),
];

WeldingRod? findRodByClass(String awsClass) {
  try {
    return weldingRods.firstWhere(
      (rod) => rod.awsClass.toLowerCase() == awsClass.toLowerCase(),
    );
  } catch (e) {
    return null;
  }
}

List<WeldingRod> searchRods(String query) {
  if (query.isEmpty) return weldingRods;
  final lowercaseQuery = query.toLowerCase();
  return weldingRods.where((rod) {
    return rod.awsClass.toLowerCase().contains(lowercaseQuery) ||
        rod.commonName.toLowerCase().contains(lowercaseQuery) ||
        rod.material.toLowerCase().contains(lowercaseQuery) ||
        rod.usage.any((u) => u.toLowerCase().contains(lowercaseQuery));
  }).toList();
}
