// Rigging knots and hitches
class RiggingKnot {
  final String name;
  final String category; // 'loop', 'hitch', 'bend', 'stopper'
  final String description;
  final List<String> uses;
  final int strengthRetention; // percentage of rope strength retained
  final String difficulty; // 'easy', 'moderate', 'advanced'
  final List<String> steps;

  const RiggingKnot({
    required this.name,
    required this.category,
    required this.description,
    required this.uses,
    required this.strengthRetention,
    required this.difficulty,
    required this.steps,
  });
}

const List<RiggingKnot> riggingKnots = [
  RiggingKnot(
    name: 'Bowline',
    category: 'loop',
    description: 'Creates a fixed loop that won\'t slip or bind under load',
    uses: ['Lifting loops', 'Safety lines', 'Rescue operations', 'Mooring'],
    strengthRetention: 60,
    difficulty: 'moderate',
    steps: [
      'Form a small loop (rabbit hole) in the standing part',
      'Pass working end up through the loop',
      'Go around behind the standing part',
      'Pass back down through the loop',
      'Tighten by pulling standing part while holding loop',
    ],
  ),
  RiggingKnot(
    name: 'Figure 8 Loop',
    category: 'loop',
    description: 'Strong, secure loop that\'s easy to inspect and untie',
    uses: ['Climbing anchors', 'Tie-in points', 'Critical connections'],
    strengthRetention: 75,
    difficulty: 'easy',
    steps: [
      'Double the rope to form a bight',
      'Make a loop with the doubled rope',
      'Pass the bight around and through the loop',
      'Pull tight to form figure 8 shape',
    ],
  ),
  RiggingKnot(
    name: 'Clove Hitch',
    category: 'hitch',
    description: 'Quick adjustable hitch for temporary attachment',
    uses: ['Securing to posts/poles', 'Adjustable tie-offs', 'Starting lashings'],
    strengthRetention: 60,
    difficulty: 'easy',
    steps: [
      'Make a turn around the object',
      'Cross over the standing part and make another turn',
      'Tuck working end under the cross',
      'Pull both ends tight',
    ],
  ),
  RiggingKnot(
    name: 'Half Hitch (Two)',
    category: 'hitch',
    description: 'Simple securing knot, use two for better hold',
    uses: ['Quick tie-offs', 'Securing loads', 'Finishing lashings'],
    strengthRetention: 65,
    difficulty: 'easy',
    steps: [
      'Pass rope around object',
      'Make first half hitch around standing part',
      'Make second half hitch in same direction',
      'Pull snug against object',
    ],
  ),
  RiggingKnot(
    name: 'Timber Hitch',
    category: 'hitch',
    description: 'Self-tightening hitch for pulling logs/pipes',
    uses: ['Dragging cylindrical objects', 'Hoisting pipes', 'Towing'],
    strengthRetention: 65,
    difficulty: 'easy',
    steps: [
      'Pass rope around the object',
      'Wrap working end around itself 3+ times',
      'Pull standing part - hitch tightens under load',
    ],
  ),
  RiggingKnot(
    name: 'Rolling Hitch',
    category: 'hitch',
    description: 'Grips another rope or pole, resists lengthwise pull',
    uses: ['Gripping poles', 'Adding to loaded line', 'Adjustable attachment'],
    strengthRetention: 55,
    difficulty: 'moderate',
    steps: [
      'Make two turns around object in direction of pull',
      'Cross over and make one turn on opposite side',
      'Tuck under the cross and pull tight',
    ],
  ),
  RiggingKnot(
    name: 'Sheet Bend',
    category: 'bend',
    description: 'Joins two ropes of different diameters',
    uses: ['Joining ropes', 'Extending lines', 'Connecting different materials'],
    strengthRetention: 55,
    difficulty: 'easy',
    steps: [
      'Form bight in thicker rope',
      'Pass thinner rope through bight from below',
      'Wrap around both parts of bight',
      'Tuck under itself (same side as standing part)',
    ],
  ),
  RiggingKnot(
    name: 'Double Fisherman\'s',
    category: 'bend',
    description: 'Very secure bend for joining similar ropes',
    uses: ['Permanent rope joins', 'Safety lines', 'Prusik loops'],
    strengthRetention: 65,
    difficulty: 'moderate',
    steps: [
      'Overlap rope ends',
      'Wrap one end twice around both ropes, tuck through',
      'Repeat with other end in opposite direction',
      'Pull standing parts to slide knots together',
    ],
  ),
  RiggingKnot(
    name: 'Prusik',
    category: 'hitch',
    description: 'Friction hitch that grips when loaded, slides when not',
    uses: ['Ascending ropes', 'Load hoisting', 'Safety backup'],
    strengthRetention: 50,
    difficulty: 'moderate',
    steps: [
      'Use a loop of smaller diameter cord',
      'Wrap around main rope 3 times',
      'Pass loop through itself',
      'Dress neatly and test before loading',
    ],
  ),
  RiggingKnot(
    name: 'Trucker\'s Hitch',
    category: 'hitch',
    description: 'Creates 3:1 mechanical advantage for tensioning',
    uses: ['Securing loads', 'Tensioning lines', 'Creating tie-downs'],
    strengthRetention: 50,
    difficulty: 'advanced',
    steps: [
      'Anchor one end to fixed point',
      'Create a slip loop (or figure 8 on a bight) mid-line',
      'Pass working end around anchor point',
      'Thread back through loop to create pulley effect',
      'Pull to tension, secure with half hitches',
    ],
  ),
];

// Wire rope and sling data
class WireRopeSling {
  final String diameter; // inches
  final double verticalWll; // lbs, single leg vertical
  final double chokerWll; // lbs, choker hitch
  final double basket60Wll; // lbs, basket at 60°
  final double basket45Wll; // lbs, basket at 45°

  const WireRopeSling({
    required this.diameter,
    required this.verticalWll,
    required this.chokerWll,
    required this.basket60Wll,
    required this.basket45Wll,
  });
}

// 6x19 IWRC Wire Rope Sling Capacities (typical values)
const List<WireRopeSling> wireRopeSlings = [
  WireRopeSling(diameter: '1/4', verticalWll: 1120, chokerWll: 840, basket60Wll: 1940, basket45Wll: 1580),
  WireRopeSling(diameter: '5/16', verticalWll: 1740, chokerWll: 1300, basket60Wll: 3010, basket45Wll: 2460),
  WireRopeSling(diameter: '3/8', verticalWll: 2480, chokerWll: 1860, basket60Wll: 4290, basket45Wll: 3500),
  WireRopeSling(diameter: '7/16', verticalWll: 3360, chokerWll: 2520, basket60Wll: 5820, basket45Wll: 4750),
  WireRopeSling(diameter: '1/2', verticalWll: 4360, chokerWll: 3270, basket60Wll: 7550, basket45Wll: 6160),
  WireRopeSling(diameter: '9/16', verticalWll: 5480, chokerWll: 4110, basket60Wll: 9490, basket45Wll: 7740),
  WireRopeSling(diameter: '5/8', verticalWll: 6720, chokerWll: 5040, basket60Wll: 11640, basket45Wll: 9500),
  WireRopeSling(diameter: '3/4', verticalWll: 9520, chokerWll: 7140, basket60Wll: 16490, basket45Wll: 13450),
  WireRopeSling(diameter: '7/8', verticalWll: 12800, chokerWll: 9600, basket60Wll: 22170, basket45Wll: 18090),
  WireRopeSling(diameter: '1', verticalWll: 16640, chokerWll: 12480, basket60Wll: 28820, basket45Wll: 23520),
];

// Chain sling data
class ChainSling {
  final String size; // inches
  final double gradeWll80; // lbs, Grade 80
  final double gradeWll100; // lbs, Grade 100

  const ChainSling({
    required this.size,
    required this.gradeWll80,
    required this.gradeWll100,
  });
}

// Single leg vertical WLL for alloy chain slings
const List<ChainSling> chainSlings = [
  ChainSling(size: '1/4', gradeWll80: 3500, gradeWll100: 4300),
  ChainSling(size: '5/16', gradeWll80: 4500, gradeWll100: 5700),
  ChainSling(size: '3/8', gradeWll80: 7100, gradeWll100: 8800),
  ChainSling(size: '1/2', gradeWll80: 12000, gradeWll100: 15000),
  ChainSling(size: '5/8', gradeWll80: 18100, gradeWll100: 22600),
  ChainSling(size: '3/4', gradeWll80: 28300, gradeWll100: 35300),
  ChainSling(size: '7/8', gradeWll80: 34200, gradeWll100: 42700),
  ChainSling(size: '1', gradeWll80: 47700, gradeWll100: 59700),
  ChainSling(size: '1-1/4', gradeWll80: 72300, gradeWll100: 90400),
];

// Synthetic sling data
class SyntheticSling {
  final String width; // inches
  final int ply; // 1 or 2
  final double verticalWll; // lbs
  final double chokerWll; // lbs
  final double basketWll; // lbs

  const SyntheticSling({
    required this.width,
    required this.ply,
    required this.verticalWll,
    required this.chokerWll,
    required this.basketWll,
  });
}

// Nylon web sling capacities (Type 3, Eye & Eye)
const List<SyntheticSling> syntheticSlings = [
  SyntheticSling(width: '1', ply: 1, verticalWll: 1600, chokerWll: 1200, basketWll: 3200),
  SyntheticSling(width: '2', ply: 1, verticalWll: 3200, chokerWll: 2500, basketWll: 6400),
  SyntheticSling(width: '3', ply: 1, verticalWll: 4800, chokerWll: 3800, basketWll: 9600),
  SyntheticSling(width: '4', ply: 1, verticalWll: 6400, chokerWll: 5100, basketWll: 12800),
  SyntheticSling(width: '6', ply: 1, verticalWll: 9600, chokerWll: 7600, basketWll: 19200),
  SyntheticSling(width: '1', ply: 2, verticalWll: 3200, chokerWll: 2500, basketWll: 6400),
  SyntheticSling(width: '2', ply: 2, verticalWll: 6400, chokerWll: 5100, basketWll: 12800),
  SyntheticSling(width: '3', ply: 2, verticalWll: 9600, chokerWll: 7600, basketWll: 19200),
  SyntheticSling(width: '4', ply: 2, verticalWll: 12800, chokerWll: 10200, basketWll: 25600),
  SyntheticSling(width: '6', ply: 2, verticalWll: 19200, chokerWll: 15300, basketWll: 38400),
];

// Sling angle factors
const Map<int, double> slingAngleFactors = {
  90: 1.000, // Vertical
  60: 0.866,
  45: 0.707,
  30: 0.500,
};

// Calculate WLL with angle factor
double calculateAngledWll(double verticalWll, int angle) {
  return verticalWll * (slingAngleFactors[angle] ?? 0.707);
}

// Calculate required sling capacity
double calculateRequiredCapacity(double loadWeight, int numberOfLegs, int angle) {
  final angleFactor = slingAngleFactors[angle] ?? 0.707;
  return loadWeight / (numberOfLegs * angleFactor);
}
