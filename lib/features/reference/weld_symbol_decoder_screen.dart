import 'package:flutter/material.dart';

class WeldSymbolDecoderScreen extends StatefulWidget {
  const WeldSymbolDecoderScreen({super.key});

  @override
  State<WeldSymbolDecoderScreen> createState() => _WeldSymbolDecoderScreenState();
}

class _WeldSymbolDecoderScreenState extends State<WeldSymbolDecoderScreen> {
  String _selectedSymbol = 'fillet';

  static const Map<String, WeldSymbolData> weldSymbols = {
    'fillet': WeldSymbolData(
      name: 'Fillet Weld',
      symbol: '△',
      description: 'Triangular weld joining two surfaces at right angles',
      arrowSide: 'Weld on arrow side of joint',
      otherSide: 'Weld on other side of joint',
      bothSides: 'Weld both sides',
      dimensions: 'Size × Length (pitch)',
      applications: ['T-joints', 'Lap joints', 'Corner joints'],
      notes: 'Most common weld type. Size is leg length.',
    ),
    'groove_v': WeldSymbolData(
      name: 'V-Groove Weld',
      symbol: 'V',
      description: 'Single V preparation for full penetration',
      arrowSide: 'Groove on arrow side',
      otherSide: 'Groove on other side',
      bothSides: 'Double-V groove',
      dimensions: 'Depth × Root opening (angle)',
      applications: ['Butt joints', 'Thick plate welding'],
      notes: 'Angle typically 60°. Use backing for full penetration.',
    ),
    'groove_bevel': WeldSymbolData(
      name: 'Bevel Groove Weld',
      symbol: '⌐',
      description: 'Single bevel on one plate only',
      arrowSide: 'Bevel on arrow side plate',
      otherSide: 'Bevel on other side plate',
      bothSides: 'Double-bevel groove',
      dimensions: 'Depth × Root opening (angle)',
      applications: ['T-joints', 'Corner joints'],
      notes: 'Arrow points to plate with bevel preparation.',
    ),
    'groove_u': WeldSymbolData(
      name: 'U-Groove Weld',
      symbol: 'U',
      description: 'U-shaped preparation for full penetration',
      arrowSide: 'U-groove on arrow side',
      otherSide: 'U-groove on other side',
      bothSides: 'Double-U groove',
      dimensions: 'Depth × Root radius',
      applications: ['Thick plate', 'Pipe welding'],
      notes: 'Reduces weld metal volume vs V-groove.',
    ),
    'groove_j': WeldSymbolData(
      name: 'J-Groove Weld',
      symbol: 'J',
      description: 'J-shaped preparation on one plate',
      arrowSide: 'J-groove on arrow side plate',
      otherSide: 'J-groove on other side plate',
      bothSides: 'Double-J groove',
      dimensions: 'Depth × Root radius',
      applications: ['T-joints', 'Thick plate'],
      notes: 'Combines benefits of bevel and U-groove.',
    ),
    'square': WeldSymbolData(
      name: 'Square Groove Weld',
      symbol: '||',
      description: 'No preparation, square edges',
      arrowSide: 'Weld from arrow side',
      otherSide: 'Weld from other side',
      bothSides: 'Weld both sides',
      dimensions: 'Root opening only',
      applications: ['Thin material', 'Sheet metal'],
      notes: 'Limited to thin material (<3/16"). May need backing.',
    ),
    'plug': WeldSymbolData(
      name: 'Plug/Slot Weld',
      symbol: '▭',
      description: 'Weld through hole in one member',
      arrowSide: 'Hole in arrow side member',
      otherSide: 'Hole in other side member',
      bothSides: 'N/A',
      dimensions: 'Diameter (or width × length)',
      applications: ['Lap joints', 'Attaching plates'],
      notes: 'Hole may be round (plug) or elongated (slot).',
    ),
    'spot': WeldSymbolData(
      name: 'Spot/Projection Weld',
      symbol: '○',
      description: 'Resistance spot or arc spot weld',
      arrowSide: 'Spot on arrow side',
      otherSide: 'Spot on other side',
      bothSides: 'N/A',
      dimensions: 'Diameter × Pitch (spacing)',
      applications: ['Sheet metal', 'Automotive'],
      notes: 'Number of spots shown above/below symbol.',
    ),
    'seam': WeldSymbolData(
      name: 'Seam Weld',
      symbol: '○─',
      description: 'Continuous resistance or arc seam weld',
      arrowSide: 'Seam on arrow side',
      otherSide: 'Seam on other side',
      bothSides: 'N/A',
      dimensions: 'Width × Length (pitch)',
      applications: ['Tanks', 'Containers', 'Ducts'],
      notes: 'Creates leak-proof continuous joint.',
    ),
    'surfacing': WeldSymbolData(
      name: 'Surfacing Weld',
      symbol: '◠',
      description: 'Build-up weld on surface',
      arrowSide: 'Surface indicated by arrow',
      otherSide: 'N/A',
      bothSides: 'N/A',
      dimensions: 'Height × Width × Length',
      applications: ['Wear surfaces', 'Repair', 'Hardfacing'],
      notes: 'Used for build-up, not joining.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final selectedData = weldSymbols[_selectedSymbol]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weld Symbol Decoder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Symbol selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Weld Type',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: weldSymbols.entries.map((entry) {
                      final isSelected = entry.key == _selectedSymbol;
                      return ChoiceChip(
                        label: Text(entry.value.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedSymbol = entry.key);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Symbol details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            selectedData.symbol,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedData.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              selectedData.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(Icons.arrow_forward, 'Arrow Side', selectedData.arrowSide),
                  _buildDetailRow(Icons.arrow_back, 'Other Side', selectedData.otherSide),
                  _buildDetailRow(Icons.compare_arrows, 'Both Sides', selectedData.bothSides),
                  _buildDetailRow(Icons.straighten, 'Dimensions', selectedData.dimensions),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Applications
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.build),
                      SizedBox(width: 8),
                      Text(
                        'Common Applications',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedData.applications.map((app) {
                      return Chip(
                        label: Text(app),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.tertiary),
                        const SizedBox(width: 12),
                        Expanded(child: Text(selectedData.notes)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Welding symbol anatomy
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: ExpansionTile(
              leading: const Icon(Icons.schema),
              title: const Text('Welding Symbol Anatomy'),
              initiallyExpanded: false,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnatomyItem('Reference Line', 'Horizontal line - symbol foundation'),
                      _buildAnatomyItem('Arrow', 'Points to joint location'),
                      _buildAnatomyItem('Basic Symbol', 'Below line = arrow side, Above = other side'),
                      _buildAnatomyItem('Dimensions', 'Left of symbol: size, Right: length'),
                      _buildAnatomyItem('Tail', 'Contains specifications, process, notes'),
                      _buildAnatomyItem('Contour Symbol', 'Flush (—), Convex (⌒), Concave (⌣)'),
                      _buildAnatomyItem('Finish Symbol', 'C=chip, G=grind, M=machine, R=roll'),
                      _buildAnatomyItem('Field Weld Flag', 'Filled flag = weld in field'),
                      _buildAnatomyItem('All Around', 'Circle at arrow/line junction'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Supplementary symbols
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Supplementary Symbols'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSupplementaryRow('○', 'Weld All Around', 'Complete weld around joint'),
                      _buildSupplementaryRow('▶', 'Field Weld', 'Weld at installation site'),
                      _buildSupplementaryRow('—', 'Flush Contour', 'Weld face is flat'),
                      _buildSupplementaryRow('⌒', 'Convex Contour', 'Weld face is crowned'),
                      _buildSupplementaryRow('⌣', 'Concave Contour', 'Weld face is dished'),
                      _buildSupplementaryRow('M', 'Melt-Through', 'Full penetration visible'),
                      _buildSupplementaryRow('[ ]', 'Backing/Spacer', 'Material behind joint'),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildAnatomyItem(String part, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Text(part, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }

  Widget _buildSupplementaryRow(String symbol, String name, String meaning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(meaning)),
        ],
      ),
    );
  }
}

class WeldSymbolData {
  final String name;
  final String symbol;
  final String description;
  final String arrowSide;
  final String otherSide;
  final String bothSides;
  final String dimensions;
  final List<String> applications;
  final String notes;

  const WeldSymbolData({
    required this.name,
    required this.symbol,
    required this.description,
    required this.arrowSide,
    required this.otherSide,
    required this.bothSides,
    required this.dimensions,
    required this.applications,
    required this.notes,
  });
}
