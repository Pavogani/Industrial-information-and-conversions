import 'package:flutter/material.dart';
import '../../core/models/metal_gauge_data.dart';

class MetalGaugeScreen extends StatefulWidget {
  const MetalGaugeScreen({super.key});

  @override
  State<MetalGaugeScreen> createState() => _MetalGaugeScreenState();
}

class _MetalGaugeScreenState extends State<MetalGaugeScreen> {
  String _materialFilter = 'All';
  bool _showMetric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metal Gauge Chart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showMetric ? Icons.straighten : Icons.square_foot),
            tooltip: _showMetric ? 'Show Imperial' : 'Show Metric',
            onPressed: () => setState(() => _showMetric = !_showMetric),
          ),
        ],
      ),
      body: Column(
        children: [
          // Material Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Material: ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'All', label: Text('All')),
                      ButtonSegment(value: 'Steel', label: Text('Steel')),
                      ButtonSegment(value: 'Aluminum', label: Text('Alum')),
                      ButtonSegment(value: 'Stainless', label: Text('SS')),
                    ],
                    selected: {_materialFilter},
                    onSelectionChanged: (selection) {
                      setState(() => _materialFilter = selection.first);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Units indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Text(
                  _showMetric
                      ? 'Showing thickness in millimeters (mm)'
                      : 'Showing thickness in inches (")',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    'Gauge',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                if (_materialFilter == 'All' || _materialFilter == 'Steel')
                  Expanded(
                    child: Text(
                      'Steel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                if (_materialFilter == 'All' || _materialFilter == 'Aluminum')
                  Expanded(
                    child: Text(
                      'Aluminum',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                if (_materialFilter == 'All' || _materialFilter == 'Stainless')
                  Expanded(
                    child: Text(
                      'Stainless',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'Approx',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Gauge List
          Expanded(
            child: ListView.builder(
              itemCount: metalGauges.length,
              itemBuilder: (context, index) {
                final gauge = metalGauges[index];
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: isEven
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.surfaceContainerLowest,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${gauge.gauge}ga',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_materialFilter == 'All' || _materialFilter == 'Steel')
                        Expanded(
                          child: Text(
                            _formatThickness(
                              _showMetric ? gauge.steelMm : gauge.steelThickness,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_materialFilter == 'All' || _materialFilter == 'Aluminum')
                        Expanded(
                          child: Text(
                            _formatThickness(
                              _showMetric ? gauge.aluminumMm : gauge.aluminumThickness,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_materialFilter == 'All' || _materialFilter == 'Stainless')
                        Expanded(
                          child: Text(
                            _formatThickness(
                              _showMetric ? gauge.stainlessMm : gauge.stainlessThickness,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          gauge.nearestFraction,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatThickness(double value) {
    if (_showMetric) {
      return '${value.toStringAsFixed(2)}mm';
    } else {
      return '.${value.toStringAsFixed(4).substring(2)}';
    }
  }
}
