// Lubricant Reference Data
class LubricantType {
  final String name;
  final String category; // 'oil', 'grease', 'specialty'
  final String description;
  final List<String> applications;
  final List<String> notFor;
  final String tempRange;
  final List<String> notes;

  const LubricantType({
    required this.name,
    required this.category,
    required this.description,
    required this.applications,
    required this.notFor,
    required this.tempRange,
    required this.notes,
  });
}

const List<LubricantType> lubricants = [
  // Oils
  LubricantType(
    name: 'Mineral Oil (R&O)',
    category: 'oil',
    description: 'Rust & Oxidation inhibited petroleum oil',
    applications: ['General machinery', 'Gearboxes', 'Hydraulic systems', 'Bearings'],
    notFor: ['Food contact', 'Extreme temps', 'Oxygen service'],
    tempRange: '-20°F to 250°F',
    notes: ['Most common industrial lubricant', 'Good water separation', 'Multiple viscosity grades'],
  ),
  LubricantType(
    name: 'Synthetic (PAO)',
    category: 'oil',
    description: 'Polyalphaolefin synthetic oil',
    applications: ['Extreme temps', 'High-speed bearings', 'Long drain intervals', 'Compressors'],
    notFor: ['Some seal materials (check compatibility)'],
    tempRange: '-60°F to 400°F',
    notes: ['Extended life', 'Better flow at low temps', 'Higher cost justified for severe service'],
  ),
  LubricantType(
    name: 'Food Grade (H1)',
    category: 'oil',
    description: 'NSF H1 registered for incidental food contact',
    applications: ['Food processing', 'Beverage equipment', 'Pharmaceutical'],
    notFor: ['High-load gears', 'Extreme pressure'],
    tempRange: '-20°F to 400°F',
    notes: ['Required where food contact possible', 'White oil or synthetic base', 'Document usage for audits'],
  ),
  LubricantType(
    name: 'Hydraulic Fluid (AW)',
    category: 'oil',
    description: 'Anti-wear hydraulic oil',
    applications: ['Hydraulic systems', 'Vane pumps', 'Piston pumps'],
    notFor: ['Gears (unless specified)', 'Wet brakes'],
    tempRange: '-10°F to 225°F',
    notes: ['ISO VG 32, 46, 68 most common', 'Check OEM specs for zinc content', 'Monitor for water contamination'],
  ),

  // Greases
  LubricantType(
    name: 'Lithium Grease',
    category: 'grease',
    description: 'General purpose lithium thickener grease',
    applications: ['Bearings', 'Chassis', 'General lubrication', 'Electric motors'],
    notFor: ['High water exposure', 'Extreme temps'],
    tempRange: '-20°F to 275°F',
    notes: ['Most common grease', 'NLGI #2 typical', 'Good all-around performance'],
  ),
  LubricantType(
    name: 'Lithium Complex',
    category: 'grease',
    description: 'High-performance lithium complex grease',
    applications: ['High-temp bearings', 'Heavy loads', 'Steel mills', 'Paper machines'],
    notFor: ['Low temps below -20°F'],
    tempRange: '-20°F to 350°F',
    notes: ['Better than simple lithium', 'Good water resistance', 'EP versions available'],
  ),
  LubricantType(
    name: 'Polyurea Grease',
    category: 'grease',
    description: 'Synthetic polyurea thickener grease',
    applications: ['Electric motors', 'Sealed bearings', 'Long life applications'],
    notFor: ['Mixing with other grease types'],
    tempRange: '-40°F to 350°F',
    notes: ['Excellent for electric motors', 'Long service life', 'Do NOT mix with lithium'],
  ),
  LubricantType(
    name: 'Calcium Sulfonate',
    category: 'grease',
    description: 'Premium water-resistant grease',
    applications: ['Marine', 'Wet environments', 'Food grade available', 'Heavy loads'],
    notFor: ['High-speed applications'],
    tempRange: '-20°F to 350°F',
    notes: ['Excellent water resistance', 'Natural EP properties', 'Premium cost'],
  ),
  LubricantType(
    name: 'Moly (MoS2) Grease',
    category: 'grease',
    description: 'Molybdenum disulfide additive grease',
    applications: ['Sliding surfaces', 'Slow/oscillating', 'High loads', 'CV joints'],
    notFor: ['Rolling element bearings', 'High speed'],
    tempRange: '-20°F to 300°F',
    notes: ['Black color', 'Boundary lubrication', 'Good for shock loads'],
  ),

  // Specialty
  LubricantType(
    name: 'Silicone Lubricant',
    category: 'specialty',
    description: 'Silicone-based lubricant for plastic/rubber',
    applications: ['O-rings', 'Plastic parts', 'Rubber seals', 'Light mechanisms'],
    notFor: ['Metal-to-metal', 'High loads', 'Silicone rubber'],
    tempRange: '-100°F to 400°F',
    notes: ['Safe for most plastics', 'Excellent temp range', 'Not for heavy loads'],
  ),
  LubricantType(
    name: 'Dry Film (PTFE)',
    category: 'specialty',
    description: 'PTFE/Teflon dry lubricant',
    applications: ['Clean environments', 'Slides', 'Locks', 'Where oil attracts dirt'],
    notFor: ['High loads', 'High speeds', 'Heavy-duty bearings'],
    tempRange: '-100°F to 500°F',
    notes: ['Stays clean', 'Good for dusty areas', 'Reapply frequently'],
  ),
  LubricantType(
    name: 'Penetrating Oil',
    category: 'specialty',
    description: 'Low-viscosity penetrant for seized parts',
    applications: ['Frozen fasteners', 'Rust penetration', 'Freeing stuck parts'],
    notFor: ['Permanent lubrication', 'Bearings', 'Continuous use'],
    tempRange: 'N/A',
    notes: ['Not a lubricant - for freeing parts only', 'Allow time to penetrate', 'Clean and relubricate after'],
  ),
  LubricantType(
    name: 'Chain Lubricant',
    category: 'specialty',
    description: 'Specialized lubricant for roller chains',
    applications: ['Roller chains', 'Conveyor chains', 'Drive chains'],
    notFor: ['Other applications'],
    tempRange: '-20°F to 300°F',
    notes: ['Penetrates pins/bushings', 'Many formulations available', 'Match to chain speed/environment'],
  ),
];

// Grease compatibility chart
const Map<String, Map<String, String>> greaseCompatibility = {
  'Lithium': {
    'Lithium': 'Compatible',
    'Lithium Complex': 'Compatible',
    'Calcium': 'Borderline',
    'Polyurea': 'Incompatible',
    'Calcium Sulfonate': 'Borderline',
  },
  'Lithium Complex': {
    'Lithium': 'Compatible',
    'Lithium Complex': 'Compatible',
    'Calcium': 'Borderline',
    'Polyurea': 'Incompatible',
    'Calcium Sulfonate': 'Compatible',
  },
  'Polyurea': {
    'Lithium': 'Incompatible',
    'Lithium Complex': 'Incompatible',
    'Calcium': 'Incompatible',
    'Polyurea': 'Compatible',
    'Calcium Sulfonate': 'Incompatible',
  },
  'Calcium Sulfonate': {
    'Lithium': 'Borderline',
    'Lithium Complex': 'Compatible',
    'Calcium': 'Compatible',
    'Polyurea': 'Incompatible',
    'Calcium Sulfonate': 'Compatible',
  },
};

// NLGI grades
const Map<String, String> nlgiGrades = {
  '000': 'Semi-fluid (centralized systems)',
  '00': 'Semi-fluid (gearboxes)',
  '0': 'Very soft (centralized systems)',
  '1': 'Soft (low temp, high speed)',
  '2': 'Normal (general purpose)',
  '3': 'Firm (high temp, vertical shafts)',
  '4': 'Very firm (high temp)',
  '5': 'Hard (block grease)',
  '6': 'Very hard (block grease)',
};

// ISO Viscosity Grades
const Map<String, Map<String, double>> isoViscosityGrades = {
  'ISO VG 10': {'min': 9.0, 'max': 11.0},
  'ISO VG 15': {'min': 13.5, 'max': 16.5},
  'ISO VG 22': {'min': 19.8, 'max': 24.2},
  'ISO VG 32': {'min': 28.8, 'max': 35.2},
  'ISO VG 46': {'min': 41.4, 'max': 50.6},
  'ISO VG 68': {'min': 61.2, 'max': 74.8},
  'ISO VG 100': {'min': 90.0, 'max': 110.0},
  'ISO VG 150': {'min': 135.0, 'max': 165.0},
  'ISO VG 220': {'min': 198.0, 'max': 242.0},
  'ISO VG 320': {'min': 288.0, 'max': 352.0},
  'ISO VG 460': {'min': 414.0, 'max': 506.0},
  'ISO VG 680': {'min': 612.0, 'max': 748.0},
};
