// Searchable index of all app features and content

class SearchItem {
  final String title;
  final String description;
  final String route;
  final String category;
  final List<String> keywords;
  final String icon;

  const SearchItem({
    required this.title,
    required this.description,
    required this.route,
    required this.category,
    required this.keywords,
    required this.icon,
  });

  bool matches(String query) {
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q) ||
        keywords.any((k) => k.toLowerCase().contains(q)) ||
        category.toLowerCase().contains(q);
  }
}

const List<SearchItem> searchIndex = [
  // Converters
  SearchItem(
    title: 'Quick Conversion',
    description: 'Convert between imperial and metric units',
    route: '/conversion',
    category: 'Convert',
    keywords: ['inch', 'mm', 'feet', 'meters', 'celsius', 'fahrenheit', 'temperature', 'length', 'weight', 'pressure', 'psi', 'bar'],
    icon: 'swap_horiz',
  ),

  // Fasteners
  SearchItem(
    title: 'Fastener Lookup',
    description: 'Bolt sizes, wrench sizes, tap drills',
    route: '/fasteners',
    category: 'Fasteners',
    keywords: ['bolt', 'nut', 'wrench', 'socket', 'hex', 'thread', 'tap drill', 'tpi', 'coarse', 'fine'],
    icon: 'hardware',
  ),

  // Calculators
  SearchItem(
    title: 'Shaft Alignment',
    description: 'Reverse indicator method calculations',
    route: '/calculators/alignment',
    category: 'Calculators',
    keywords: ['alignment', 'shaft', 'coupling', 'motor', 'pump', 'rim', 'face', 'indicator', 'dial'],
    icon: 'architecture',
  ),
  SearchItem(
    title: 'Belt Length Calculator',
    description: 'Calculate V-belt length for pulleys',
    route: '/calculators/belt-length',
    category: 'Calculators',
    keywords: ['belt', 'v-belt', 'pulley', 'sheave', 'drive', 'length', 'center distance'],
    icon: 'sync',
  ),
  SearchItem(
    title: 'Pulley / RPM Calculator',
    description: 'Calculate speeds and pulley sizes',
    route: '/calculators/pulley-rpm',
    category: 'Calculators',
    keywords: ['pulley', 'rpm', 'speed', 'ratio', 'driven', 'driver', 'sheave'],
    icon: 'speed',
  ),
  SearchItem(
    title: 'Hydraulic Force',
    description: 'Cylinder force and pressure calculations',
    route: '/calculators/hydraulic',
    category: 'Calculators',
    keywords: ['hydraulic', 'cylinder', 'force', 'pressure', 'psi', 'bore', 'rod', 'tonnage'],
    icon: 'compress',
  ),
  SearchItem(
    title: 'Saw Blade TPI',
    description: 'Calculate teeth per inch for material',
    route: '/calculators/saw-blade',
    category: 'Calculators',
    keywords: ['saw', 'blade', 'tpi', 'teeth', 'bandsaw', 'cutting', 'metal'],
    icon: 'content_cut',
  ),
  SearchItem(
    title: 'Rise & Run Calculator',
    description: 'Stair and ramp slope calculations',
    route: '/calculators/rise-run',
    category: 'Calculators',
    keywords: ['rise', 'run', 'slope', 'angle', 'grade', 'stair', 'ramp', 'incline', 'pitch'],
    icon: 'stairs',
  ),
  SearchItem(
    title: 'Belt Tension',
    description: 'Proper deflection for drives',
    route: '/calculators/belt-tension',
    category: 'Calculators',
    keywords: ['belt', 'tension', 'deflection', 'chain', 'drive', 'span', 'force'],
    icon: 'linear_scale',
  ),
  SearchItem(
    title: 'Bearing Fit Calculator',
    description: 'Shaft/housing tolerances for fits',
    route: '/calculators/bearing-fit',
    category: 'Calculators',
    keywords: ['bearing', 'fit', 'tolerance', 'shaft', 'housing', 'interference', 'clearance', 'press'],
    icon: 'circle_outlined',
  ),
  SearchItem(
    title: 'Gear Ratio Calculator',
    description: 'Speed and torque through gear trains',
    route: '/calculators/gear-ratio',
    category: 'Calculators',
    keywords: ['gear', 'ratio', 'torque', 'speed', 'teeth', 'pinion', 'reducer', 'gearbox'],
    icon: 'settings',
  ),
  SearchItem(
    title: 'Motor / HP Calculator',
    description: 'Horsepower, amps, torque calculations',
    route: '/calculators/motor-hp',
    category: 'Calculators',
    keywords: ['motor', 'horsepower', 'hp', 'amps', 'torque', 'rpm', 'power', 'electrical', 'kw'],
    icon: 'electrical_services',
  ),
  SearchItem(
    title: 'Thermal Expansion',
    description: 'Calculate growth for shafts, pipes, rails',
    route: '/calculators/thermal-expansion',
    category: 'Calculators',
    keywords: ['thermal', 'expansion', 'growth', 'temperature', 'coefficient', 'steel', 'aluminum', 'hot'],
    icon: 'thermostat',
  ),
  SearchItem(
    title: 'Conveyor Calculator',
    description: 'Belt speed, capacity, and power',
    route: '/calculators/conveyor',
    category: 'Calculators',
    keywords: ['conveyor', 'belt', 'speed', 'fpm', 'capacity', 'tph', 'power', 'motor'],
    icon: 'conveyor_belt',
  ),
  SearchItem(
    title: 'Pump Flow Calculator',
    description: 'Flow rate, head, power, NPSH',
    route: '/calculators/pump',
    category: 'Calculators',
    keywords: ['pump', 'flow', 'gpm', 'head', 'pressure', 'npsh', 'cavitation', 'suction'],
    icon: 'water_drop',
  ),
  SearchItem(
    title: 'Surface Area Calculator',
    description: 'Cube, cylinder, sphere, cone, pipe surface area',
    route: '/calculators/surface-area',
    category: 'Calculators',
    keywords: ['surface', 'area', 'cube', 'cylinder', 'sphere', 'cone', 'pipe', 'square', 'rectangle', 'prism', 'paint', 'coating'],
    icon: 'square_foot',
  ),
  SearchItem(
    title: 'Electrical / Ohm\'s Law',
    description: 'Voltage, current, resistance, motor amps',
    route: '/calculators/electrical',
    category: 'Calculators',
    keywords: ['electrical', 'ohm', 'voltage', 'current', 'amps', 'resistance', 'watts', 'power', 'motor', 'fla'],
    icon: 'electric_bolt',
  ),
  SearchItem(
    title: 'Wire Sizing Calculator',
    description: 'AWG selection, ampacity, voltage drop',
    route: '/calculators/wire-sizing',
    category: 'Calculators',
    keywords: ['wire', 'awg', 'gauge', 'ampacity', 'voltage', 'drop', 'copper', 'aluminum', 'nec'],
    icon: 'cable',
  ),
  SearchItem(
    title: 'Pneumatic Calculator',
    description: 'CFM, pipe sizing, cylinder force',
    route: '/calculators/pneumatic',
    category: 'Calculators',
    keywords: ['pneumatic', 'air', 'cfm', 'cylinder', 'force', 'pressure', 'psi', 'pipe', 'compressor'],
    icon: 'air',
  ),

  // Reference
  SearchItem(
    title: 'Fraction Reference',
    description: 'Fraction to decimal to metric conversion',
    route: '/reference/fractions',
    category: 'Reference',
    keywords: ['fraction', 'decimal', 'metric', 'inch', 'conversion', '1/16', '1/8', '1/4'],
    icon: 'pie_chart_outline',
  ),
  SearchItem(
    title: 'Torque Specifications',
    description: 'Bolt torque values by grade and size',
    route: '/reference/torque',
    category: 'Reference',
    keywords: ['torque', 'bolt', 'grade', 'ft-lb', 'nm', 'tension', 'clamp', 'tighten'],
    icon: 'build_circle_outlined',
  ),
  SearchItem(
    title: 'Pipe Thread Reference',
    description: 'NPT/BSPT sizes, tap drills, sealants',
    route: '/reference/pipe-thread',
    category: 'Reference',
    keywords: ['pipe', 'thread', 'npt', 'bspt', 'tapered', 'sealant', 'teflon', 'fitting'],
    icon: 'plumbing',
  ),
  SearchItem(
    title: 'Pipe Schedule Chart',
    description: 'Wall thickness for Schedule 40/80/160',
    route: '/reference/pipe-schedule',
    category: 'Reference',
    keywords: ['pipe', 'schedule', 'wall', 'thickness', 'sch40', 'sch80', 'nominal', 'od', 'id'],
    icon: 'view_column',
  ),
  SearchItem(
    title: 'O-Ring Reference',
    description: 'AS568 sizes and material selection',
    route: '/reference/o-ring',
    category: 'Reference',
    keywords: ['oring', 'o-ring', 'seal', 'as568', 'viton', 'buna', 'rubber', 'gasket'],
    icon: 'panorama_fish_eye',
  ),
  SearchItem(
    title: 'Lubricant Guide',
    description: 'Grease/oil selection and compatibility',
    route: '/reference/lubricant',
    category: 'Reference',
    keywords: ['lubricant', 'grease', 'oil', 'nlgi', 'viscosity', 'bearing', 'gear', 'synthetic'],
    icon: 'water_drop',
  ),
  SearchItem(
    title: 'Material Hardness',
    description: 'Rockwell/Brinell/Vickers conversion',
    route: '/reference/hardness',
    category: 'Reference',
    keywords: ['hardness', 'rockwell', 'brinell', 'vickers', 'hrc', 'hrb', 'steel', 'heat treat'],
    icon: 'diamond',
  ),
  SearchItem(
    title: 'Wire & Cable Reference',
    description: 'AWG sizes, ampacity, voltage drop',
    route: '/reference/wire',
    category: 'Reference',
    keywords: ['wire', 'cable', 'awg', 'gauge', 'ampacity', 'voltage', 'drop', 'electrical'],
    icon: 'cable',
  ),
  SearchItem(
    title: 'Drill & Tap Chart',
    description: 'Number/letter drills, UNC, UNF, metric taps',
    route: '/reference/drill-tap',
    category: 'Reference',
    keywords: ['drill', 'tap', 'thread', 'unc', 'unf', 'metric', 'clearance', 'hole'],
    icon: 'construction',
  ),
  SearchItem(
    title: 'Weld Symbol Decoder',
    description: 'Decode welding symbols from blueprints',
    route: '/reference/weld-symbols',
    category: 'Reference',
    keywords: ['weld', 'symbol', 'blueprint', 'fillet', 'groove', 'bevel', 'butt', 'joint', 'aws'],
    icon: 'architecture',
  ),
  SearchItem(
    title: 'Motor Nameplate Decoder',
    description: 'Decode motor nameplate information',
    route: '/reference/motor-nameplate',
    category: 'Reference',
    keywords: ['motor', 'nameplate', 'nema', 'frame', 'enclosure', 'tefc', 'odp', 'voltage', 'amps', 'hp'],
    icon: 'electric_bolt',
  ),
  SearchItem(
    title: 'Bearing Number Decoder',
    description: 'Decode bearing part numbers and suffixes',
    route: '/reference/bearing-decoder',
    category: 'Reference',
    keywords: ['bearing', 'number', 'decoder', 'skf', '6205', 'seal', 'shield', 'clearance', 'suffix'],
    icon: 'circle_outlined',
  ),
  SearchItem(
    title: 'Coupling Tolerances',
    description: 'Alignment tolerances by coupling type',
    route: '/reference/coupling-tolerances',
    category: 'Reference',
    keywords: ['coupling', 'alignment', 'tolerance', 'parallel', 'angular', 'offset', 'misalignment'],
    icon: 'sync',
  ),
  SearchItem(
    title: 'Crane Hand Signals',
    description: 'Standard OSHA crane signals',
    route: '/reference/crane-signals',
    category: 'Reference',
    keywords: ['crane', 'signal', 'hand', 'hoist', 'boom', 'swing', 'osha', 'rigging'],
    icon: 'pan_tool',
  ),

  // Welding
  SearchItem(
    title: 'Welding Rod Guide',
    description: 'SMAW electrode selection and usage',
    route: '/welding/rods',
    category: 'Welding',
    keywords: ['welding', 'rod', 'electrode', 'smaw', 'stick', '6010', '6011', '7018', '7014'],
    icon: 'electric_bolt',
  ),
  SearchItem(
    title: 'Torch & Flame Guide',
    description: 'Oxy-acetylene flame types and brazing',
    route: '/welding/torch',
    category: 'Welding',
    keywords: ['torch', 'flame', 'oxy', 'acetylene', 'brazing', 'cutting', 'neutral', 'carburizing'],
    icon: 'local_fire_department',
  ),
  SearchItem(
    title: 'Metal Gauges',
    description: 'Sheet metal gauge to thickness conversion',
    route: '/welding/gauges',
    category: 'Welding',
    keywords: ['gauge', 'sheet', 'metal', 'thickness', 'steel', 'aluminum', 'stainless'],
    icon: 'straighten',
  ),
  SearchItem(
    title: 'Anti-Seize Guide',
    description: 'Thread compound selection by material',
    route: '/welding/anti-seize',
    category: 'Welding',
    keywords: ['anti-seize', 'thread', 'compound', 'lubricant', 'copper', 'nickel', 'stainless', 'galling'],
    icon: 'opacity',
  ),
  SearchItem(
    title: 'Weld Joint Types',
    description: 'Joint prep, design, and strength',
    route: '/welding/joints',
    category: 'Welding',
    keywords: ['weld', 'joint', 'butt', 'fillet', 'lap', 'corner', 'tee', 'groove', 'bevel'],
    icon: 'architecture',
  ),
  SearchItem(
    title: 'Welding Processes',
    description: 'SMAW, MIG, TIG, FCAW comparison',
    route: '/welding/processes',
    category: 'Welding',
    keywords: ['welding', 'process', 'smaw', 'gmaw', 'mig', 'tig', 'gtaw', 'fcaw', 'flux'],
    icon: 'compare_arrows',
  ),
  SearchItem(
    title: 'Amperage & Settings',
    description: 'Rod amps, MIG wire, electrode decoder',
    route: '/welding/amperage',
    category: 'Welding',
    keywords: ['amperage', 'amps', 'settings', 'voltage', 'wire', 'speed', 'electrode', 'decoder'],
    icon: 'speed',
  ),
  SearchItem(
    title: 'Preheat Calculator',
    description: 'Carbon equivalent & preheat temps',
    route: '/welding/preheat',
    category: 'Welding',
    keywords: ['preheat', 'carbon', 'equivalent', 'temperature', 'cracking', 'weldability', 'steel'],
    icon: 'thermostat',
  ),

  // Rigging
  SearchItem(
    title: 'Knots Reference',
    description: 'Common rigging and utility knots',
    route: '/rigging/knots',
    category: 'Rigging',
    keywords: ['knot', 'rope', 'bowline', 'hitch', 'bend', 'tie', 'rigging'],
    icon: 'link',
  ),
  SearchItem(
    title: 'Sling Working Load Limits',
    description: 'WLL for chains, wire rope, synthetics',
    route: '/rigging/sling-wll',
    category: 'Rigging',
    keywords: ['sling', 'wll', 'capacity', 'chain', 'wire', 'rope', 'synthetic', 'load', 'lift'],
    icon: 'fitness_center',
  ),
  SearchItem(
    title: 'Load Calculator',
    description: 'Calculate rigging loads and angles',
    route: '/rigging/load-calc',
    category: 'Rigging',
    keywords: ['load', 'rigging', 'angle', 'tension', 'lift', 'crane', 'hoist', 'sling'],
    icon: 'calculate',
  ),

  // Safety
  SearchItem(
    title: 'Safety Checklists',
    description: 'LOTO, Hot Work, Confined Space procedures',
    route: '/safety',
    category: 'Safety',
    keywords: ['safety', 'checklist', 'loto', 'lockout', 'tagout', 'hot work', 'confined space', 'permit'],
    icon: 'health_and_safety',
  ),
  SearchItem(
    title: 'LOTO Checklist',
    description: 'Lockout/Tagout procedure checklist',
    route: '/safety/loto',
    category: 'Safety',
    keywords: ['loto', 'lockout', 'tagout', 'energy', 'isolation', 'hazardous', 'control', 'osha'],
    icon: 'lock',
  ),
  SearchItem(
    title: 'Hot Work Permit',
    description: 'Welding and cutting safety checklist',
    route: '/safety/hot-work',
    category: 'Safety',
    keywords: ['hot work', 'permit', 'welding', 'cutting', 'fire', 'watch', 'combustible', 'spark'],
    icon: 'local_fire_department',
  ),
  SearchItem(
    title: 'Confined Space Entry',
    description: 'Confined space entry safety checklist',
    route: '/safety/confined-space',
    category: 'Safety',
    keywords: ['confined space', 'entry', 'permit', 'atmospheric', 'oxygen', 'ventilation', 'rescue', 'attendant'],
    icon: 'warning',
  ),
];

List<SearchItem> searchFeatures(String query) {
  if (query.isEmpty) return [];
  return searchIndex.where((item) => item.matches(query)).toList();
}

Map<String, List<SearchItem>> groupByCategory(List<SearchItem> items) {
  final Map<String, List<SearchItem>> grouped = {};
  for (final item in items) {
    grouped.putIfAbsent(item.category, () => []).add(item);
  }
  return grouped;
}
