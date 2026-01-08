class FastenerData {
  final String boltDiameter;
  final String finishedHexHead;
  final String heavyHexHead;
  final double decimalEquivalent;
  final double metricEquivalent;
  final String tapDrillSize;
  final int threadsPerInchCoarse;
  final int threadsPerInchFine;

  const FastenerData({
    required this.boltDiameter,
    required this.finishedHexHead,
    required this.heavyHexHead,
    required this.decimalEquivalent,
    required this.metricEquivalent,
    required this.tapDrillSize,
    required this.threadsPerInchCoarse,
    required this.threadsPerInchFine,
  });

  String getWrenchSize(bool isHeavyHex) {
    return isHeavyHex ? heavyHexHead : finishedHexHead;
  }
}

const List<FastenerData> boltData = [
  FastenerData(
    boltDiameter: '1/4"',
    finishedHexHead: '7/16"',
    heavyHexHead: '1/2"',
    decimalEquivalent: 0.250,
    metricEquivalent: 6.35,
    tapDrillSize: '#7 (0.201")',
    threadsPerInchCoarse: 20,
    threadsPerInchFine: 28,
  ),
  FastenerData(
    boltDiameter: '5/16"',
    finishedHexHead: '1/2"',
    heavyHexHead: '9/16"',
    decimalEquivalent: 0.3125,
    metricEquivalent: 7.94,
    tapDrillSize: 'F (0.257")',
    threadsPerInchCoarse: 18,
    threadsPerInchFine: 24,
  ),
  FastenerData(
    boltDiameter: '3/8"',
    finishedHexHead: '9/16"',
    heavyHexHead: '5/8"',
    decimalEquivalent: 0.375,
    metricEquivalent: 9.53,
    tapDrillSize: '5/16" (0.3125")',
    threadsPerInchCoarse: 16,
    threadsPerInchFine: 24,
  ),
  FastenerData(
    boltDiameter: '7/16"',
    finishedHexHead: '5/8"',
    heavyHexHead: '11/16"',
    decimalEquivalent: 0.4375,
    metricEquivalent: 11.11,
    tapDrillSize: 'U (0.368")',
    threadsPerInchCoarse: 14,
    threadsPerInchFine: 20,
  ),
  FastenerData(
    boltDiameter: '1/2"',
    finishedHexHead: '3/4"',
    heavyHexHead: '7/8"',
    decimalEquivalent: 0.500,
    metricEquivalent: 12.70,
    tapDrillSize: '27/64" (0.4219")',
    threadsPerInchCoarse: 13,
    threadsPerInchFine: 20,
  ),
  FastenerData(
    boltDiameter: '9/16"',
    finishedHexHead: '13/16"',
    heavyHexHead: '15/16"',
    decimalEquivalent: 0.5625,
    metricEquivalent: 14.29,
    tapDrillSize: '31/64" (0.4844")',
    threadsPerInchCoarse: 12,
    threadsPerInchFine: 18,
  ),
  FastenerData(
    boltDiameter: '5/8"',
    finishedHexHead: '15/16"',
    heavyHexHead: '1-1/16"',
    decimalEquivalent: 0.625,
    metricEquivalent: 15.88,
    tapDrillSize: '17/32" (0.5313")',
    threadsPerInchCoarse: 11,
    threadsPerInchFine: 18,
  ),
  FastenerData(
    boltDiameter: '3/4"',
    finishedHexHead: '1-1/8"',
    heavyHexHead: '1-1/4"',
    decimalEquivalent: 0.750,
    metricEquivalent: 19.05,
    tapDrillSize: '21/32" (0.6563")',
    threadsPerInchCoarse: 10,
    threadsPerInchFine: 16,
  ),
  FastenerData(
    boltDiameter: '7/8"',
    finishedHexHead: '1-5/16"',
    heavyHexHead: '1-7/16"',
    decimalEquivalent: 0.875,
    metricEquivalent: 22.23,
    tapDrillSize: '49/64" (0.7656")',
    threadsPerInchCoarse: 9,
    threadsPerInchFine: 14,
  ),
  FastenerData(
    boltDiameter: '1"',
    finishedHexHead: '1-1/2"',
    heavyHexHead: '1-5/8"',
    decimalEquivalent: 1.000,
    metricEquivalent: 25.40,
    tapDrillSize: '7/8" (0.875")',
    threadsPerInchCoarse: 8,
    threadsPerInchFine: 12,
  ),
  FastenerData(
    boltDiameter: '1-1/8"',
    finishedHexHead: '1-11/16"',
    heavyHexHead: '1-13/16"',
    decimalEquivalent: 1.125,
    metricEquivalent: 28.58,
    tapDrillSize: '63/64" (0.9844")',
    threadsPerInchCoarse: 7,
    threadsPerInchFine: 12,
  ),
  FastenerData(
    boltDiameter: '1-1/4"',
    finishedHexHead: '1-7/8"',
    heavyHexHead: '2"',
    decimalEquivalent: 1.250,
    metricEquivalent: 31.75,
    tapDrillSize: '1-7/64" (1.1094")',
    threadsPerInchCoarse: 7,
    threadsPerInchFine: 12,
  ),
  FastenerData(
    boltDiameter: '1-3/8"',
    finishedHexHead: '2-1/16"',
    heavyHexHead: '2-3/16"',
    decimalEquivalent: 1.375,
    metricEquivalent: 34.93,
    tapDrillSize: '1-7/32" (1.2188")',
    threadsPerInchCoarse: 6,
    threadsPerInchFine: 12,
  ),
  FastenerData(
    boltDiameter: '1-1/2"',
    finishedHexHead: '2-1/4"',
    heavyHexHead: '2-3/8"',
    decimalEquivalent: 1.500,
    metricEquivalent: 38.10,
    tapDrillSize: '1-11/32" (1.3438")',
    threadsPerInchCoarse: 6,
    threadsPerInchFine: 12,
  ),
  FastenerData(
    boltDiameter: '1-5/8"',
    finishedHexHead: '2-7/16"',
    heavyHexHead: '2-9/16"',
    decimalEquivalent: 1.625,
    metricEquivalent: 41.28,
    tapDrillSize: '1-29/64" (1.4531")',
    threadsPerInchCoarse: 5,
    threadsPerInchFine: 0,
  ),
  FastenerData(
    boltDiameter: '1-3/4"',
    finishedHexHead: '2-5/8"',
    heavyHexHead: '2-3/4"',
    decimalEquivalent: 1.750,
    metricEquivalent: 44.45,
    tapDrillSize: '1-9/16" (1.5625")',
    threadsPerInchCoarse: 5,
    threadsPerInchFine: 0,
  ),
  FastenerData(
    boltDiameter: '1-7/8"',
    finishedHexHead: '2-13/16"',
    heavyHexHead: '2-15/16"',
    decimalEquivalent: 1.875,
    metricEquivalent: 47.63,
    tapDrillSize: '1-11/16" (1.6875")',
    threadsPerInchCoarse: 5,
    threadsPerInchFine: 0,
  ),
  FastenerData(
    boltDiameter: '2"',
    finishedHexHead: '3"',
    heavyHexHead: '3-1/8"',
    decimalEquivalent: 2.000,
    metricEquivalent: 50.80,
    tapDrillSize: '1-25/32" (1.7813")',
    threadsPerInchCoarse: 4,
    threadsPerInchFine: 0,
  ),
];

FastenerData? findFastenerByDiameter(String diameter) {
  try {
    return boltData.firstWhere(
      (f) => f.boltDiameter == diameter,
    );
  } catch (e) {
    return null;
  }
}

List<String> getAllBoltDiameters() {
  return boltData.map((f) => f.boltDiameter).toList();
}
