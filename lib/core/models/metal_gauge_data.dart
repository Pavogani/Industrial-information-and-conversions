class MetalGauge {
  final int gauge;
  final double steelThickness; // inches
  final double aluminumThickness; // inches
  final double stainlessThickness; // inches
  final String nearestFraction;

  const MetalGauge({
    required this.gauge,
    required this.steelThickness,
    required this.aluminumThickness,
    required this.stainlessThickness,
    required this.nearestFraction,
  });

  double get steelMm => steelThickness * 25.4;
  double get aluminumMm => aluminumThickness * 25.4;
  double get stainlessMm => stainlessThickness * 25.4;
}

const List<MetalGauge> metalGauges = [
  MetalGauge(gauge: 3, steelThickness: 0.2391, aluminumThickness: 0.2294, stainlessThickness: 0.2391, nearestFraction: '1/4"'),
  MetalGauge(gauge: 4, steelThickness: 0.2242, aluminumThickness: 0.2043, stainlessThickness: 0.2242, nearestFraction: '7/32"'),
  MetalGauge(gauge: 5, steelThickness: 0.2092, aluminumThickness: 0.1819, stainlessThickness: 0.2092, nearestFraction: '13/64"'),
  MetalGauge(gauge: 6, steelThickness: 0.1943, aluminumThickness: 0.1620, stainlessThickness: 0.1943, nearestFraction: '3/16"'),
  MetalGauge(gauge: 7, steelThickness: 0.1793, aluminumThickness: 0.1443, stainlessThickness: 0.1875, nearestFraction: '11/64"'),
  MetalGauge(gauge: 8, steelThickness: 0.1644, aluminumThickness: 0.1285, stainlessThickness: 0.1719, nearestFraction: '5/32"'),
  MetalGauge(gauge: 9, steelThickness: 0.1495, aluminumThickness: 0.1144, stainlessThickness: 0.1563, nearestFraction: '9/64"'),
  MetalGauge(gauge: 10, steelThickness: 0.1345, aluminumThickness: 0.1019, stainlessThickness: 0.1406, nearestFraction: '1/8"'),
  MetalGauge(gauge: 11, steelThickness: 0.1196, aluminumThickness: 0.0907, stainlessThickness: 0.1250, nearestFraction: '7/64"'),
  MetalGauge(gauge: 12, steelThickness: 0.1046, aluminumThickness: 0.0808, stainlessThickness: 0.1094, nearestFraction: '3/32"'),
  MetalGauge(gauge: 13, steelThickness: 0.0897, aluminumThickness: 0.0720, stainlessThickness: 0.0938, nearestFraction: "5/64\""),
  MetalGauge(gauge: 14, steelThickness: 0.0747, aluminumThickness: 0.0641, stainlessThickness: 0.0781, nearestFraction: '1/16"'),
  MetalGauge(gauge: 15, steelThickness: 0.0673, aluminumThickness: 0.0571, stainlessThickness: 0.0703, nearestFraction: '1/16"'),
  MetalGauge(gauge: 16, steelThickness: 0.0598, aluminumThickness: 0.0508, stainlessThickness: 0.0625, nearestFraction: '1/16"'),
  MetalGauge(gauge: 17, steelThickness: 0.0538, aluminumThickness: 0.0453, stainlessThickness: 0.0563, nearestFraction: '3/64"'),
  MetalGauge(gauge: 18, steelThickness: 0.0478, aluminumThickness: 0.0403, stainlessThickness: 0.0500, nearestFraction: '3/64"'),
  MetalGauge(gauge: 19, steelThickness: 0.0418, aluminumThickness: 0.0359, stainlessThickness: 0.0438, nearestFraction: '3/64"'),
  MetalGauge(gauge: 20, steelThickness: 0.0359, aluminumThickness: 0.0320, stainlessThickness: 0.0375, nearestFraction: '1/32"'),
  MetalGauge(gauge: 21, steelThickness: 0.0329, aluminumThickness: 0.0285, stainlessThickness: 0.0344, nearestFraction: '1/32"'),
  MetalGauge(gauge: 22, steelThickness: 0.0299, aluminumThickness: 0.0253, stainlessThickness: 0.0313, nearestFraction: '1/32"'),
  MetalGauge(gauge: 23, steelThickness: 0.0269, aluminumThickness: 0.0226, stainlessThickness: 0.0281, nearestFraction: '1/32"'),
  MetalGauge(gauge: 24, steelThickness: 0.0239, aluminumThickness: 0.0201, stainlessThickness: 0.0250, nearestFraction: '1/64"'),
  MetalGauge(gauge: 25, steelThickness: 0.0209, aluminumThickness: 0.0179, stainlessThickness: 0.0219, nearestFraction: '1/64"'),
  MetalGauge(gauge: 26, steelThickness: 0.0179, aluminumThickness: 0.0159, stainlessThickness: 0.0188, nearestFraction: '1/64"'),
  MetalGauge(gauge: 27, steelThickness: 0.0164, aluminumThickness: 0.0142, stainlessThickness: 0.0172, nearestFraction: '1/64"'),
  MetalGauge(gauge: 28, steelThickness: 0.0149, aluminumThickness: 0.0126, stainlessThickness: 0.0156, nearestFraction: '1/64"'),
];

MetalGauge? findByGauge(int gauge) {
  try {
    return metalGauges.firstWhere((g) => g.gauge == gauge);
  } catch (e) {
    return null;
  }
}

// Anti-seize compounds data
class AntiSeize {
  final String type;
  final String color;
  final int maxTemp; // °F
  final List<String> bestFor;
  final List<String> avoidWith;
  final List<String> notes;

  const AntiSeize({
    required this.type,
    required this.color,
    required this.maxTemp,
    required this.bestFor,
    required this.avoidWith,
    required this.notes,
  });
}

const List<AntiSeize> antiSeizeTypes = [
  AntiSeize(
    type: 'Copper-Based',
    color: 'Copper/Bronze',
    maxTemp: 1800,
    bestFor: [
      'Stainless steel fasteners',
      'Exhaust manifolds',
      'High-temperature applications',
      'Spark plugs',
      'Brake components',
    ],
    avoidWith: [
      'Oxygen service equipment',
      'Some aluminum (causes galvanic corrosion)',
    ],
    notes: [
      'Most common high-temp anti-seize',
      'Excellent for preventing galling',
      'Conducts electricity',
    ],
  ),
  AntiSeize(
    type: 'Nickel-Based',
    color: 'Silver/Gray',
    maxTemp: 2600,
    bestFor: [
      'Extreme high temperature',
      'Nuclear applications',
      'Stainless to stainless',
      'Titanium fasteners',
      'Chemical processing',
    ],
    avoidWith: [
      'Standard applications (expensive)',
    ],
    notes: [
      'Highest temperature rating',
      'Most expensive option',
      'Food-grade versions available',
    ],
  ),
  AntiSeize(
    type: 'Aluminum-Based',
    color: 'Silver',
    maxTemp: 1600,
    bestFor: [
      'General purpose',
      'Aluminum components',
      'Electrical connections',
      'Marine environments',
      'Cost-effective applications',
    ],
    avoidWith: [
      'Extreme temperatures over 1600°F',
      'Some stainless steels',
    ],
    notes: [
      'Good all-around choice',
      'Less expensive than copper',
      'Works well in salt environments',
    ],
  ),
  AntiSeize(
    type: 'Molybdenum Disulfide (Moly)',
    color: 'Black/Dark Gray',
    maxTemp: 750,
    bestFor: [
      'Press fits',
      'Splines and keyways',
      'Gears and bearings',
      'Assembly lubricant',
    ],
    avoidWith: [
      'High temperatures',
      'Oxygen-rich environments',
    ],
    notes: [
      'Excellent for assembly',
      'High pressure applications',
      'Not for high heat',
    ],
  ),
  AntiSeize(
    type: 'Food-Grade (PTFE)',
    color: 'White',
    maxTemp: 500,
    bestFor: [
      'Food processing equipment',
      'Pharmaceutical',
      'Potable water systems',
      'Medical equipment',
    ],
    avoidWith: [
      'High temperature applications',
      'Heavy load applications',
    ],
    notes: [
      'NSF/FDA approved',
      'Also called "Teflon-based"',
      'Lower temperature limit',
    ],
  ),
];
