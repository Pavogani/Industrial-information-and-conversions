// NPT (National Pipe Thread) data
class NptThread {
  final String nominalSize;
  final double actualOd; // inches
  final double threadsPerInch;
  final double tapDrill; // inches
  final String tapDrillFraction;
  final double minEngagement; // inches - minimum for pressure-tight joint
  final double effectiveLength; // inches

  const NptThread({
    required this.nominalSize,
    required this.actualOd,
    required this.threadsPerInch,
    required this.tapDrill,
    required this.tapDrillFraction,
    required this.minEngagement,
    required this.effectiveLength,
  });
}

const List<NptThread> nptThreads = [
  NptThread(nominalSize: '1/16', actualOd: 0.3125, threadsPerInch: 27, tapDrill: 0.2570, tapDrillFraction: 'C (0.242)', minEngagement: 0.160, effectiveLength: 0.2611),
  NptThread(nominalSize: '1/8', actualOd: 0.405, threadsPerInch: 27, tapDrill: 0.3320, tapDrillFraction: 'R (21/64)', minEngagement: 0.180, effectiveLength: 0.2639),
  NptThread(nominalSize: '1/4', actualOd: 0.540, threadsPerInch: 18, tapDrill: 0.4375, tapDrillFraction: '7/16', minEngagement: 0.200, effectiveLength: 0.4018),
  NptThread(nominalSize: '3/8', actualOd: 0.675, threadsPerInch: 18, tapDrill: 0.5781, tapDrillFraction: '37/64', minEngagement: 0.240, effectiveLength: 0.4078),
  NptThread(nominalSize: '1/2', actualOd: 0.840, threadsPerInch: 14, tapDrill: 0.7188, tapDrillFraction: '23/32', minEngagement: 0.320, effectiveLength: 0.5337),
  NptThread(nominalSize: '3/4', actualOd: 1.050, threadsPerInch: 14, tapDrill: 0.9219, tapDrillFraction: '59/64', minEngagement: 0.340, effectiveLength: 0.5457),
  NptThread(nominalSize: '1', actualOd: 1.315, threadsPerInch: 11.5, tapDrill: 1.1563, tapDrillFraction: '1-5/32', minEngagement: 0.400, effectiveLength: 0.6828),
  NptThread(nominalSize: '1-1/4', actualOd: 1.660, threadsPerInch: 11.5, tapDrill: 1.5000, tapDrillFraction: '1-1/2', minEngagement: 0.420, effectiveLength: 0.7068),
  NptThread(nominalSize: '1-1/2', actualOd: 1.900, threadsPerInch: 11.5, tapDrill: 1.7344, tapDrillFraction: '1-47/64', minEngagement: 0.420, effectiveLength: 0.7235),
  NptThread(nominalSize: '2', actualOd: 2.375, threadsPerInch: 11.5, tapDrill: 2.1875, tapDrillFraction: '2-3/16', minEngagement: 0.436, effectiveLength: 0.7565),
  NptThread(nominalSize: '2-1/2', actualOd: 2.875, threadsPerInch: 8, tapDrill: 2.6250, tapDrillFraction: '2-5/8', minEngagement: 0.682, effectiveLength: 1.1375),
  NptThread(nominalSize: '3', actualOd: 3.500, threadsPerInch: 8, tapDrill: 3.2500, tapDrillFraction: '3-1/4', minEngagement: 0.766, effectiveLength: 1.2000),
  NptThread(nominalSize: '4', actualOd: 4.500, threadsPerInch: 8, tapDrill: 4.2500, tapDrillFraction: '4-1/4', minEngagement: 0.844, effectiveLength: 1.3000),
];

// BSPT (British Standard Pipe Taper) data
class BsptThread {
  final String nominalSize;
  final double actualOd; // inches
  final double threadsPerInch;
  final double tapDrill; // mm
  final double minEngagement; // mm

  const BsptThread({
    required this.nominalSize,
    required this.actualOd,
    required this.threadsPerInch,
    required this.tapDrill,
    required this.minEngagement,
  });
}

const List<BsptThread> bsptThreads = [
  BsptThread(nominalSize: '1/8', actualOd: 0.383, threadsPerInch: 28, tapDrill: 8.6, minEngagement: 4.0),
  BsptThread(nominalSize: '1/4', actualOd: 0.518, threadsPerInch: 19, tapDrill: 11.5, minEngagement: 6.0),
  BsptThread(nominalSize: '3/8', actualOd: 0.656, threadsPerInch: 19, tapDrill: 15.0, minEngagement: 6.4),
  BsptThread(nominalSize: '1/2', actualOd: 0.825, threadsPerInch: 14, tapDrill: 19.0, minEngagement: 8.2),
  BsptThread(nominalSize: '3/4', actualOd: 1.041, threadsPerInch: 14, tapDrill: 24.5, minEngagement: 9.5),
  BsptThread(nominalSize: '1', actualOd: 1.309, threadsPerInch: 11, tapDrill: 30.5, minEngagement: 10.4),
  BsptThread(nominalSize: '1-1/4', actualOd: 1.650, threadsPerInch: 11, tapDrill: 39.0, minEngagement: 12.7),
  BsptThread(nominalSize: '1-1/2', actualOd: 1.882, threadsPerInch: 11, tapDrill: 45.0, minEngagement: 12.7),
  BsptThread(nominalSize: '2', actualOd: 2.347, threadsPerInch: 11, tapDrill: 57.0, minEngagement: 15.9),
];

// Thread sealant recommendations
class ThreadSealant {
  final String type;
  final int maxPressure; // PSI
  final int maxTemp; // °F
  final List<String> compatible;
  final List<String> notFor;
  final String notes;

  const ThreadSealant({
    required this.type,
    required this.maxPressure,
    required this.maxTemp,
    required this.compatible,
    required this.notFor,
    required this.notes,
  });
}

const List<ThreadSealant> threadSealants = [
  ThreadSealant(
    type: 'PTFE Tape (White)',
    maxPressure: 10000,
    maxTemp: 500,
    compatible: ['Water', 'Air', 'Oil', 'Natural Gas', 'Most chemicals'],
    notFor: ['Oxygen systems', 'Some solvents'],
    notes: 'Most common. Wrap 3-5 turns clockwise (looking at thread end).',
  ),
  ThreadSealant(
    type: 'PTFE Tape (Yellow/Gas)',
    maxPressure: 10000,
    maxTemp: 500,
    compatible: ['Natural Gas', 'Propane', 'Fuel lines'],
    notFor: ['Oxygen systems'],
    notes: 'Heavier duty than white. Required for gas by most codes.',
  ),
  ThreadSealant(
    type: 'PTFE Tape (Pink/Water)',
    maxPressure: 10000,
    maxTemp: 400,
    compatible: ['Potable water', 'Food processing'],
    notFor: ['Gas lines', 'High temp'],
    notes: 'NSF certified for drinking water systems.',
  ),
  ThreadSealant(
    type: 'Pipe Dope (TFE Paste)',
    maxPressure: 10000,
    maxTemp: 500,
    compatible: ['All pipe materials', 'Steam', 'Most chemicals'],
    notFor: ['Oxygen systems', 'Some plastics'],
    notes: 'Better for large threads. Allows adjustment after assembly.',
  ),
  ThreadSealant(
    type: 'Anaerobic Sealant',
    maxPressure: 10000,
    maxTemp: 400,
    compatible: ['Metal-to-metal', 'Hydraulics', 'Pneumatics'],
    notFor: ['Plastic threads', 'Stainless steel (use primer)'],
    notes: 'Cures in absence of air. Permanent seal. Various strengths available.',
  ),
  ThreadSealant(
    type: 'Oxygen-Safe (Green)',
    maxPressure: 6000,
    maxTemp: 400,
    compatible: ['Oxygen systems', 'Medical gas', 'Clean rooms'],
    notFor: [],
    notes: 'Required for O2 service. Non-combustible formulation.',
  ),
];

// Calculate thread engagement
double calculateEngagement(double tpi, int numberOfThreads) {
  return numberOfThreads / tpi;
}

// Minimum threads for strength
int minimumThreadsForStrength(String material) {
  switch (material.toLowerCase()) {
    case 'steel':
    case 'iron':
      return 6;
    case 'brass':
    case 'bronze':
      return 8;
    case 'aluminum':
      return 10;
    case 'plastic':
    case 'pvc':
      return 12;
    default:
      return 8;
  }
}
