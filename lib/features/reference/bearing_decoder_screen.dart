import 'package:flutter/material.dart';

class BearingDecoderScreen extends StatefulWidget {
  const BearingDecoderScreen({super.key});

  @override
  State<BearingDecoderScreen> createState() => _BearingDecoderScreenState();
}

class _BearingDecoderScreenState extends State<BearingDecoderScreen> {
  final _bearingController = TextEditingController();
  Map<String, String>? _decodedResult;

  void _decodeBearing() {
    final input = _bearingController.text.trim().toUpperCase();
    if (input.isEmpty) {
      setState(() => _decodedResult = null);
      return;
    }

    final result = <String, String>{};
    String remaining = input;

    // Check for prefix (bearing type)
    String prefix = '';
    if (remaining.startsWith('NU') || remaining.startsWith('NJ') ||
        remaining.startsWith('NF') || remaining.startsWith('N ') ||
        remaining.startsWith('NN')) {
      prefix = remaining.substring(0, 2);
      remaining = remaining.substring(2).trim();
      result['Type'] = _getBearingType(prefix);
    } else if (remaining.startsWith('N')) {
      prefix = 'N';
      remaining = remaining.substring(1).trim();
      result['Type'] = _getBearingType(prefix);
    } else if (remaining.startsWith('QJ')) {
      prefix = 'QJ';
      remaining = remaining.substring(2).trim();
      result['Type'] = 'Four-point contact ball bearing';
    } else if (remaining.startsWith('T')) {
      prefix = 'T';
      remaining = remaining.substring(1).trim();
      result['Type'] = 'Tapered roller bearing';
    }

    // Try to extract the basic number
    final numberMatch = RegExp(r'^(\d+)').firstMatch(remaining);
    if (numberMatch != null) {
      final basicNumber = numberMatch.group(1)!;
      remaining = remaining.substring(basicNumber.length);

      // Decode basic number
      if (basicNumber.length >= 2) {
        final seriesDigit = basicNumber[0];
        result['Series'] = _getSeries(seriesDigit);

        if (basicNumber.length >= 3) {
          final sizeCode = basicNumber.substring(1);
          final boreInfo = _decodeBore(sizeCode);
          result['Bore'] = boreInfo;
        }
      }
    }

    // Decode suffixes
    remaining = remaining.trim();
    if (remaining.isNotEmpty) {
      final suffixes = _decodeSuffixes(remaining);
      result.addAll(suffixes);
    }

    setState(() => _decodedResult = result.isNotEmpty ? result : null);
  }

  String _getBearingType(String prefix) {
    switch (prefix) {
      case 'N':
        return 'Cylindrical roller (single row, no flanges on outer)';
      case 'NU':
        return 'Cylindrical roller (two flanges on outer ring)';
      case 'NJ':
        return 'Cylindrical roller (one flange on inner ring)';
      case 'NF':
        return 'Cylindrical roller (one flange on outer ring)';
      case 'NN':
        return 'Cylindrical roller (double row)';
      default:
        return 'Unknown type';
    }
  }

  String _getSeries(String digit) {
    switch (digit) {
      case '0':
        return '10 series (Extra light)';
      case '1':
        return '100 series (Extra light)';
      case '2':
        return '200 series (Light)';
      case '3':
        return '300 series (Medium)';
      case '4':
        return '400 series (Heavy)';
      case '5':
        return '500 series (Extra heavy)';
      case '6':
        return '600 series (Light, wide)';
      case '7':
        return '700 series (Angular contact)';
      default:
        return 'Series $digit';
    }
  }

  String _decodeBore(String sizeCode) {
    final size = int.tryParse(sizeCode);
    if (size == null) return 'Unknown';

    // Standard bore code (multiply by 5 for bore >= 04)
    if (size >= 4) {
      final bore = size * 5;
      return '$bore mm (code $sizeCode)';
    } else {
      // Special small bore codes
      switch (size) {
        case 0:
          return '10 mm (code 00)';
        case 1:
          return '12 mm (code 01)';
        case 2:
          return '15 mm (code 02)';
        case 3:
          return '17 mm (code 03)';
        default:
          return '${size * 5} mm';
      }
    }
  }

  Map<String, String> _decodeSuffixes(String suffixes) {
    final result = <String, String>{};
    final remaining = suffixes.toUpperCase();

    // Common suffix patterns
    if (remaining.contains('2RS') || remaining.contains('2RSR')) {
      result['Seals'] = 'Double rubber seals (both sides)';
    } else if (remaining.contains('RS') || remaining.contains('RSR')) {
      result['Seals'] = 'Single rubber seal (one side)';
    }

    if (remaining.contains('2Z') || remaining.contains('ZZ')) {
      result['Shields'] = 'Double metal shields (both sides)';
    } else if (remaining.contains('Z')) {
      result['Shields'] = 'Single metal shield (one side)';
    }

    if (remaining.contains('C3')) {
      result['Clearance'] = 'C3 - Greater than normal clearance';
    } else if (remaining.contains('C4')) {
      result['Clearance'] = 'C4 - Greater than C3 clearance';
    } else if (remaining.contains('C2')) {
      result['Clearance'] = 'C2 - Less than normal clearance';
    } else if (remaining.contains('CN')) {
      result['Clearance'] = 'CN - Normal clearance';
    }

    if (remaining.contains('P6')) {
      result['Precision'] = 'P6 - ISO Class 6 (ABEC 3)';
    } else if (remaining.contains('P5')) {
      result['Precision'] = 'P5 - ISO Class 5 (ABEC 5)';
    } else if (remaining.contains('P4')) {
      result['Precision'] = 'P4 - ISO Class 4 (ABEC 7)';
    } else if (remaining.contains('P2')) {
      result['Precision'] = 'P2 - ISO Class 2 (ABEC 9)';
    }

    if (remaining.contains('NR')) {
      result['Snap Ring'] = 'External snap ring groove';
    }

    if (remaining.contains('M')) {
      result['Cage'] = 'Brass/bronze cage';
    } else if (remaining.contains('TN')) {
      result['Cage'] = 'Polyamide (nylon) cage';
    } else if (remaining.contains('J')) {
      result['Cage'] = 'Steel pressed cage';
    }

    return result;
  }

  @override
  void dispose() {
    _bearingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bearing Number Decoder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Input card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Bearing Number',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _bearingController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'e.g., 6205-2RS C3',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _bearingController.clear();
                          setState(() => _decodedResult = null);
                        },
                      ),
                    ),
                    onChanged: (_) => _decodeBearing(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Result card
          if (_decodedResult != null && _decodedResult!.isNotEmpty)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle),
                        SizedBox(width: 8),
                        Text(
                          'Decoded Information',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(),
                    ..._decodedResult!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                entry.key,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Text(entry.value)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Series reference
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Bearing Series'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSeriesRow(context, '6000', 'Deep groove ball', 'Most common, versatile'),
                      _buildSeriesRow(context, '6200', 'Deep groove ball', 'Light series, higher capacity'),
                      _buildSeriesRow(context, '6300', 'Deep groove ball', 'Medium series, highest capacity'),
                      _buildSeriesRow(context, '7000', 'Angular contact', 'Combined radial/axial loads'),
                      _buildSeriesRow(context, 'N/NU/NJ', 'Cylindrical roller', 'High radial capacity'),
                      _buildSeriesRow(context, '22000', 'Spherical roller', 'Self-aligning, heavy loads'),
                      _buildSeriesRow(context, '30000', 'Tapered roller', 'Combined loads, separable'),
                      _buildSeriesRow(context, '51000', 'Thrust ball', 'Axial loads only'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Suffix reference
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.label),
              title: const Text('Common Suffixes'),
              initiallyExpanded: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Seals & Shields', style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildSuffixRow('2RS / 2RSR', 'Double rubber contact seals'),
                      _buildSuffixRow('RS / RSR', 'Single rubber contact seal'),
                      _buildSuffixRow('2Z / ZZ', 'Double metal shields (non-contact)'),
                      _buildSuffixRow('Z', 'Single metal shield'),
                      const Divider(),
                      const Text('Clearance', style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildSuffixRow('C2', 'Less than normal clearance'),
                      _buildSuffixRow('CN', 'Normal clearance (often omitted)'),
                      _buildSuffixRow('C3', 'Greater than normal clearance'),
                      _buildSuffixRow('C4', 'Greater than C3'),
                      _buildSuffixRow('C5', 'Greater than C4'),
                      const Divider(),
                      const Text('Precision (ISO/ABEC)', style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildSuffixRow('P0', 'Normal (ABEC 1) - often omitted'),
                      _buildSuffixRow('P6', 'ISO Class 6 (ABEC 3)'),
                      _buildSuffixRow('P5', 'ISO Class 5 (ABEC 5)'),
                      _buildSuffixRow('P4', 'ISO Class 4 (ABEC 7)'),
                      _buildSuffixRow('P2', 'ISO Class 2 (ABEC 9)'),
                      const Divider(),
                      const Text('Cage Material', style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildSuffixRow('J', 'Steel pressed cage'),
                      _buildSuffixRow('M', 'Brass/bronze machined cage'),
                      _buildSuffixRow('TN / TNH', 'Polyamide (nylon) cage'),
                      _buildSuffixRow('Y', 'Sheet brass cage'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bore code reference
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: ExpansionTile(
              leading: Icon(Icons.straighten, color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Bore Code Reference'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Standard bore codes (last 2 digits × 5 = bore mm)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Special small bore codes:'),
                      _buildBoreRow('00', '10 mm'),
                      _buildBoreRow('01', '12 mm'),
                      _buildBoreRow('02', '15 mm'),
                      _buildBoreRow('03', '17 mm'),
                      const Divider(),
                      const Text('Standard codes (×5):'),
                      _buildBoreRow('04', '20 mm (4×5)'),
                      _buildBoreRow('05', '25 mm (5×5)'),
                      _buildBoreRow('06', '30 mm (6×5)'),
                      _buildBoreRow('10', '50 mm (10×5)'),
                      _buildBoreRow('20', '100 mm (20×5)'),
                      const Divider(),
                      const Text(
                        'Example: 6205 = 6200 series, 05 bore = 25mm',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesRow(BuildContext context, String series, String type, String notes) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(series, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(notes, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuffixRow(String suffix, String meaning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(suffix, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
          Expanded(child: Text(meaning)),
        ],
      ),
    );
  }

  Widget _buildBoreRow(String code, String bore) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
          Text(bore),
        ],
      ),
    );
  }
}
