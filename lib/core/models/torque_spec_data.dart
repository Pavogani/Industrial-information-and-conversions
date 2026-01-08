enum BoltGrade {
  grade2,
  grade5,
  grade8,
  a325,
  a490,
  stainless304,
  stainless316,
}

extension BoltGradeExtension on BoltGrade {
  String get displayName {
    switch (this) {
      case BoltGrade.grade2:
        return 'SAE Grade 2';
      case BoltGrade.grade5:
        return 'SAE Grade 5';
      case BoltGrade.grade8:
        return 'SAE Grade 8';
      case BoltGrade.a325:
        return 'ASTM A325';
      case BoltGrade.a490:
        return 'ASTM A490';
      case BoltGrade.stainless304:
        return '304 Stainless';
      case BoltGrade.stainless316:
        return '316 Stainless';
    }
  }

  String get description {
    switch (this) {
      case BoltGrade.grade2:
        return 'Low carbon steel, general purpose';
      case BoltGrade.grade5:
        return 'Medium carbon steel, automotive/industrial';
      case BoltGrade.grade8:
        return 'Alloy steel, high strength applications';
      case BoltGrade.a325:
        return 'Structural steel, building construction';
      case BoltGrade.a490:
        return 'High strength structural, critical joints';
      case BoltGrade.stainless304:
        return 'Corrosion resistant, food/marine';
      case BoltGrade.stainless316:
        return 'Marine grade, chemical resistant';
    }
  }

  int get tensileStrengthPsi {
    switch (this) {
      case BoltGrade.grade2:
        return 74000;
      case BoltGrade.grade5:
        return 120000;
      case BoltGrade.grade8:
        return 150000;
      case BoltGrade.a325:
        return 120000;
      case BoltGrade.a490:
        return 150000;
      case BoltGrade.stainless304:
        return 70000;
      case BoltGrade.stainless316:
        return 75000;
    }
  }
}

class TorqueSpec {
  final String boltSize;
  final double coarseTPI;
  final double fineTPI;
  final Map<BoltGrade, TorqueValue> torqueValues;

  const TorqueSpec({
    required this.boltSize,
    required this.coarseTPI,
    required this.fineTPI,
    required this.torqueValues,
  });
}

class TorqueValue {
  final double dryFtLbs; // Dry/plain torque
  final double lubedFtLbs; // Lubricated torque (typically 75% of dry)

  const TorqueValue({
    required this.dryFtLbs,
    required this.lubedFtLbs,
  });
}

// Torque specifications for common bolt sizes
// Values are for coarse thread, dry conditions
// Based on standard engineering references
const List<TorqueSpec> torqueSpecTable = [
  TorqueSpec(
    boltSize: '1/4"',
    coarseTPI: 20,
    fineTPI: 28,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 5, lubedFtLbs: 4),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 8, lubedFtLbs: 6),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 12, lubedFtLbs: 9),
      BoltGrade.a325: TorqueValue(dryFtLbs: 8, lubedFtLbs: 6),
      BoltGrade.a490: TorqueValue(dryFtLbs: 12, lubedFtLbs: 9),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 5, lubedFtLbs: 4),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 5, lubedFtLbs: 4),
    },
  ),
  TorqueSpec(
    boltSize: '5/16"',
    coarseTPI: 18,
    fineTPI: 24,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 11, lubedFtLbs: 8),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 17, lubedFtLbs: 13),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 24, lubedFtLbs: 18),
      BoltGrade.a325: TorqueValue(dryFtLbs: 17, lubedFtLbs: 13),
      BoltGrade.a490: TorqueValue(dryFtLbs: 24, lubedFtLbs: 18),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 10, lubedFtLbs: 8),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 11, lubedFtLbs: 8),
    },
  ),
  TorqueSpec(
    boltSize: '3/8"',
    coarseTPI: 16,
    fineTPI: 24,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 16, lubedFtLbs: 12),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 31, lubedFtLbs: 23),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 44, lubedFtLbs: 33),
      BoltGrade.a325: TorqueValue(dryFtLbs: 31, lubedFtLbs: 23),
      BoltGrade.a490: TorqueValue(dryFtLbs: 44, lubedFtLbs: 33),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 15, lubedFtLbs: 11),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 16, lubedFtLbs: 12),
    },
  ),
  TorqueSpec(
    boltSize: '7/16"',
    coarseTPI: 14,
    fineTPI: 20,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 24, lubedFtLbs: 18),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 49, lubedFtLbs: 37),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 70, lubedFtLbs: 53),
      BoltGrade.a325: TorqueValue(dryFtLbs: 49, lubedFtLbs: 37),
      BoltGrade.a490: TorqueValue(dryFtLbs: 70, lubedFtLbs: 53),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 22, lubedFtLbs: 17),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 24, lubedFtLbs: 18),
    },
  ),
  TorqueSpec(
    boltSize: '1/2"',
    coarseTPI: 13,
    fineTPI: 20,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 37, lubedFtLbs: 28),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 75, lubedFtLbs: 56),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 105, lubedFtLbs: 79),
      BoltGrade.a325: TorqueValue(dryFtLbs: 75, lubedFtLbs: 56),
      BoltGrade.a490: TorqueValue(dryFtLbs: 105, lubedFtLbs: 79),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 34, lubedFtLbs: 26),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 37, lubedFtLbs: 28),
    },
  ),
  TorqueSpec(
    boltSize: '9/16"',
    coarseTPI: 12,
    fineTPI: 18,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 53, lubedFtLbs: 40),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 110, lubedFtLbs: 83),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 155, lubedFtLbs: 116),
      BoltGrade.a325: TorqueValue(dryFtLbs: 110, lubedFtLbs: 83),
      BoltGrade.a490: TorqueValue(dryFtLbs: 155, lubedFtLbs: 116),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 49, lubedFtLbs: 37),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 53, lubedFtLbs: 40),
    },
  ),
  TorqueSpec(
    boltSize: '5/8"',
    coarseTPI: 11,
    fineTPI: 18,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 74, lubedFtLbs: 56),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 150, lubedFtLbs: 113),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 210, lubedFtLbs: 158),
      BoltGrade.a325: TorqueValue(dryFtLbs: 150, lubedFtLbs: 113),
      BoltGrade.a490: TorqueValue(dryFtLbs: 210, lubedFtLbs: 158),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 68, lubedFtLbs: 51),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 74, lubedFtLbs: 56),
    },
  ),
  TorqueSpec(
    boltSize: '3/4"',
    coarseTPI: 10,
    fineTPI: 16,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 120, lubedFtLbs: 90),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 265, lubedFtLbs: 199),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 375, lubedFtLbs: 281),
      BoltGrade.a325: TorqueValue(dryFtLbs: 265, lubedFtLbs: 199),
      BoltGrade.a490: TorqueValue(dryFtLbs: 375, lubedFtLbs: 281),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 110, lubedFtLbs: 83),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 120, lubedFtLbs: 90),
    },
  ),
  TorqueSpec(
    boltSize: '7/8"',
    coarseTPI: 9,
    fineTPI: 14,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 190, lubedFtLbs: 143),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 420, lubedFtLbs: 315),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 590, lubedFtLbs: 443),
      BoltGrade.a325: TorqueValue(dryFtLbs: 420, lubedFtLbs: 315),
      BoltGrade.a490: TorqueValue(dryFtLbs: 590, lubedFtLbs: 443),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 175, lubedFtLbs: 131),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 190, lubedFtLbs: 143),
    },
  ),
  TorqueSpec(
    boltSize: '1"',
    coarseTPI: 8,
    fineTPI: 12,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 290, lubedFtLbs: 218),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 640, lubedFtLbs: 480),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 900, lubedFtLbs: 675),
      BoltGrade.a325: TorqueValue(dryFtLbs: 640, lubedFtLbs: 480),
      BoltGrade.a490: TorqueValue(dryFtLbs: 900, lubedFtLbs: 675),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 265, lubedFtLbs: 199),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 290, lubedFtLbs: 218),
    },
  ),
  TorqueSpec(
    boltSize: '1-1/8"',
    coarseTPI: 7,
    fineTPI: 12,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 400, lubedFtLbs: 300),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 900, lubedFtLbs: 675),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 1280, lubedFtLbs: 960),
      BoltGrade.a325: TorqueValue(dryFtLbs: 900, lubedFtLbs: 675),
      BoltGrade.a490: TorqueValue(dryFtLbs: 1280, lubedFtLbs: 960),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 365, lubedFtLbs: 274),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 400, lubedFtLbs: 300),
    },
  ),
  TorqueSpec(
    boltSize: '1-1/4"',
    coarseTPI: 7,
    fineTPI: 12,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 580, lubedFtLbs: 435),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 1280, lubedFtLbs: 960),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 1820, lubedFtLbs: 1365),
      BoltGrade.a325: TorqueValue(dryFtLbs: 1280, lubedFtLbs: 960),
      BoltGrade.a490: TorqueValue(dryFtLbs: 1820, lubedFtLbs: 1365),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 530, lubedFtLbs: 398),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 580, lubedFtLbs: 435),
    },
  ),
  TorqueSpec(
    boltSize: '1-1/2"',
    coarseTPI: 6,
    fineTPI: 12,
    torqueValues: {
      BoltGrade.grade2: TorqueValue(dryFtLbs: 1000, lubedFtLbs: 750),
      BoltGrade.grade5: TorqueValue(dryFtLbs: 2200, lubedFtLbs: 1650),
      BoltGrade.grade8: TorqueValue(dryFtLbs: 3100, lubedFtLbs: 2325),
      BoltGrade.a325: TorqueValue(dryFtLbs: 2200, lubedFtLbs: 1650),
      BoltGrade.a490: TorqueValue(dryFtLbs: 3100, lubedFtLbs: 2325),
      BoltGrade.stainless304: TorqueValue(dryFtLbs: 910, lubedFtLbs: 683),
      BoltGrade.stainless316: TorqueValue(dryFtLbs: 1000, lubedFtLbs: 750),
    },
  ),
];

TorqueSpec? findTorqueSpec(String boltSize) {
  try {
    return torqueSpecTable.firstWhere((spec) => spec.boltSize == boltSize);
  } catch (e) {
    return null;
  }
}

List<String> getAllTorqueBoltSizes() {
  return torqueSpecTable.map((spec) => spec.boltSize).toList();
}
