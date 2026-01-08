class FractionData {
  final String fraction;
  final double decimal;
  final double millimeters;

  const FractionData({
    required this.fraction,
    required this.decimal,
    required this.millimeters,
  });
}

// Common fractional inch sizes (up to 64ths for precision work)
const List<FractionData> fractionTable = [
  FractionData(fraction: '1/64"', decimal: 0.0156, millimeters: 0.397),
  FractionData(fraction: '1/32"', decimal: 0.0313, millimeters: 0.794),
  FractionData(fraction: '3/64"', decimal: 0.0469, millimeters: 1.191),
  FractionData(fraction: '1/16"', decimal: 0.0625, millimeters: 1.588),
  FractionData(fraction: '5/64"', decimal: 0.0781, millimeters: 1.984),
  FractionData(fraction: '3/32"', decimal: 0.0938, millimeters: 2.381),
  FractionData(fraction: '7/64"', decimal: 0.1094, millimeters: 2.778),
  FractionData(fraction: '1/8"', decimal: 0.1250, millimeters: 3.175),
  FractionData(fraction: '9/64"', decimal: 0.1406, millimeters: 3.572),
  FractionData(fraction: '5/32"', decimal: 0.1563, millimeters: 3.969),
  FractionData(fraction: '11/64"', decimal: 0.1719, millimeters: 4.366),
  FractionData(fraction: '3/16"', decimal: 0.1875, millimeters: 4.763),
  FractionData(fraction: '13/64"', decimal: 0.2031, millimeters: 5.159),
  FractionData(fraction: '7/32"', decimal: 0.2188, millimeters: 5.556),
  FractionData(fraction: '15/64"', decimal: 0.2344, millimeters: 5.953),
  FractionData(fraction: '1/4"', decimal: 0.2500, millimeters: 6.350),
  FractionData(fraction: '17/64"', decimal: 0.2656, millimeters: 6.747),
  FractionData(fraction: '9/32"', decimal: 0.2813, millimeters: 7.144),
  FractionData(fraction: '19/64"', decimal: 0.2969, millimeters: 7.541),
  FractionData(fraction: '5/16"', decimal: 0.3125, millimeters: 7.938),
  FractionData(fraction: '21/64"', decimal: 0.3281, millimeters: 8.334),
  FractionData(fraction: '11/32"', decimal: 0.3438, millimeters: 8.731),
  FractionData(fraction: '23/64"', decimal: 0.3594, millimeters: 9.128),
  FractionData(fraction: '3/8"', decimal: 0.3750, millimeters: 9.525),
  FractionData(fraction: '25/64"', decimal: 0.3906, millimeters: 9.922),
  FractionData(fraction: '13/32"', decimal: 0.4063, millimeters: 10.319),
  FractionData(fraction: '27/64"', decimal: 0.4219, millimeters: 10.716),
  FractionData(fraction: '7/16"', decimal: 0.4375, millimeters: 11.113),
  FractionData(fraction: '29/64"', decimal: 0.4531, millimeters: 11.509),
  FractionData(fraction: '15/32"', decimal: 0.4688, millimeters: 11.906),
  FractionData(fraction: '31/64"', decimal: 0.4844, millimeters: 12.303),
  FractionData(fraction: '1/2"', decimal: 0.5000, millimeters: 12.700),
  FractionData(fraction: '33/64"', decimal: 0.5156, millimeters: 13.097),
  FractionData(fraction: '17/32"', decimal: 0.5313, millimeters: 13.494),
  FractionData(fraction: '35/64"', decimal: 0.5469, millimeters: 13.891),
  FractionData(fraction: '9/16"', decimal: 0.5625, millimeters: 14.288),
  FractionData(fraction: '37/64"', decimal: 0.5781, millimeters: 14.684),
  FractionData(fraction: '19/32"', decimal: 0.5938, millimeters: 15.081),
  FractionData(fraction: '39/64"', decimal: 0.6094, millimeters: 15.478),
  FractionData(fraction: '5/8"', decimal: 0.6250, millimeters: 15.875),
  FractionData(fraction: '41/64"', decimal: 0.6406, millimeters: 16.272),
  FractionData(fraction: '21/32"', decimal: 0.6563, millimeters: 16.669),
  FractionData(fraction: '43/64"', decimal: 0.6719, millimeters: 17.066),
  FractionData(fraction: '11/16"', decimal: 0.6875, millimeters: 17.463),
  FractionData(fraction: '45/64"', decimal: 0.7031, millimeters: 17.859),
  FractionData(fraction: '23/32"', decimal: 0.7188, millimeters: 18.256),
  FractionData(fraction: '47/64"', decimal: 0.7344, millimeters: 18.653),
  FractionData(fraction: '3/4"', decimal: 0.7500, millimeters: 19.050),
  FractionData(fraction: '49/64"', decimal: 0.7656, millimeters: 19.447),
  FractionData(fraction: '25/32"', decimal: 0.7813, millimeters: 19.844),
  FractionData(fraction: '51/64"', decimal: 0.7969, millimeters: 20.241),
  FractionData(fraction: '13/16"', decimal: 0.8125, millimeters: 20.638),
  FractionData(fraction: '53/64"', decimal: 0.8281, millimeters: 21.034),
  FractionData(fraction: '27/32"', decimal: 0.8438, millimeters: 21.431),
  FractionData(fraction: '55/64"', decimal: 0.8594, millimeters: 21.828),
  FractionData(fraction: '7/8"', decimal: 0.8750, millimeters: 22.225),
  FractionData(fraction: '57/64"', decimal: 0.8906, millimeters: 22.622),
  FractionData(fraction: '29/32"', decimal: 0.9063, millimeters: 23.019),
  FractionData(fraction: '59/64"', decimal: 0.9219, millimeters: 23.416),
  FractionData(fraction: '15/16"', decimal: 0.9375, millimeters: 23.813),
  FractionData(fraction: '61/64"', decimal: 0.9531, millimeters: 24.209),
  FractionData(fraction: '31/32"', decimal: 0.9688, millimeters: 24.606),
  FractionData(fraction: '63/64"', decimal: 0.9844, millimeters: 25.003),
  FractionData(fraction: '1"', decimal: 1.0000, millimeters: 25.400),
  // Continue with larger sizes
  FractionData(fraction: '1-1/8"', decimal: 1.1250, millimeters: 28.575),
  FractionData(fraction: '1-1/4"', decimal: 1.2500, millimeters: 31.750),
  FractionData(fraction: '1-3/8"', decimal: 1.3750, millimeters: 34.925),
  FractionData(fraction: '1-1/2"', decimal: 1.5000, millimeters: 38.100),
  FractionData(fraction: '1-5/8"', decimal: 1.6250, millimeters: 41.275),
  FractionData(fraction: '1-3/4"', decimal: 1.7500, millimeters: 44.450),
  FractionData(fraction: '1-7/8"', decimal: 1.8750, millimeters: 47.625),
  FractionData(fraction: '2"', decimal: 2.0000, millimeters: 50.800),
];

List<FractionData> searchFractions(String query) {
  if (query.isEmpty) return fractionTable;

  final lowercaseQuery = query.toLowerCase();
  return fractionTable.where((f) {
    return f.fraction.toLowerCase().contains(lowercaseQuery) ||
        f.decimal.toString().contains(lowercaseQuery) ||
        f.millimeters.toString().contains(lowercaseQuery);
  }).toList();
}
