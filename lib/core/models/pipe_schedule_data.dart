// Pipe Schedule Data - Wall thickness and dimensions
class PipeSchedule {
  final String nominalSize;
  final double od; // inches
  final Map<String, PipeWall> schedules; // schedule name -> wall data

  const PipeSchedule({
    required this.nominalSize,
    required this.od,
    required this.schedules,
  });

  double getID(String schedule) {
    final wall = schedules[schedule];
    if (wall == null) return 0;
    return od - (2 * wall.wallThickness);
  }
}

class PipeWall {
  final double wallThickness; // inches
  final double weightPerFoot; // lbs/ft for steel

  const PipeWall({
    required this.wallThickness,
    required this.weightPerFoot,
  });
}

const List<PipeSchedule> pipeSchedules = [
  PipeSchedule(
    nominalSize: '1/8',
    od: 0.405,
    schedules: {
      '40': PipeWall(wallThickness: 0.068, weightPerFoot: 0.24),
      '80': PipeWall(wallThickness: 0.095, weightPerFoot: 0.31),
    },
  ),
  PipeSchedule(
    nominalSize: '1/4',
    od: 0.540,
    schedules: {
      '40': PipeWall(wallThickness: 0.088, weightPerFoot: 0.42),
      '80': PipeWall(wallThickness: 0.119, weightPerFoot: 0.54),
    },
  ),
  PipeSchedule(
    nominalSize: '3/8',
    od: 0.675,
    schedules: {
      '40': PipeWall(wallThickness: 0.091, weightPerFoot: 0.57),
      '80': PipeWall(wallThickness: 0.126, weightPerFoot: 0.74),
    },
  ),
  PipeSchedule(
    nominalSize: '1/2',
    od: 0.840,
    schedules: {
      '40': PipeWall(wallThickness: 0.109, weightPerFoot: 0.85),
      '80': PipeWall(wallThickness: 0.147, weightPerFoot: 1.09),
      '160': PipeWall(wallThickness: 0.188, weightPerFoot: 1.31),
    },
  ),
  PipeSchedule(
    nominalSize: '3/4',
    od: 1.050,
    schedules: {
      '40': PipeWall(wallThickness: 0.113, weightPerFoot: 1.13),
      '80': PipeWall(wallThickness: 0.154, weightPerFoot: 1.47),
      '160': PipeWall(wallThickness: 0.219, weightPerFoot: 1.94),
    },
  ),
  PipeSchedule(
    nominalSize: '1',
    od: 1.315,
    schedules: {
      '40': PipeWall(wallThickness: 0.133, weightPerFoot: 1.68),
      '80': PipeWall(wallThickness: 0.179, weightPerFoot: 2.17),
      '160': PipeWall(wallThickness: 0.250, weightPerFoot: 2.84),
    },
  ),
  PipeSchedule(
    nominalSize: '1-1/4',
    od: 1.660,
    schedules: {
      '40': PipeWall(wallThickness: 0.140, weightPerFoot: 2.27),
      '80': PipeWall(wallThickness: 0.191, weightPerFoot: 3.00),
      '160': PipeWall(wallThickness: 0.250, weightPerFoot: 3.76),
    },
  ),
  PipeSchedule(
    nominalSize: '1-1/2',
    od: 1.900,
    schedules: {
      '40': PipeWall(wallThickness: 0.145, weightPerFoot: 2.72),
      '80': PipeWall(wallThickness: 0.200, weightPerFoot: 3.63),
      '160': PipeWall(wallThickness: 0.281, weightPerFoot: 4.86),
    },
  ),
  PipeSchedule(
    nominalSize: '2',
    od: 2.375,
    schedules: {
      '40': PipeWall(wallThickness: 0.154, weightPerFoot: 3.65),
      '80': PipeWall(wallThickness: 0.218, weightPerFoot: 5.02),
      '160': PipeWall(wallThickness: 0.344, weightPerFoot: 7.46),
    },
  ),
  PipeSchedule(
    nominalSize: '2-1/2',
    od: 2.875,
    schedules: {
      '40': PipeWall(wallThickness: 0.203, weightPerFoot: 5.79),
      '80': PipeWall(wallThickness: 0.276, weightPerFoot: 7.66),
      '160': PipeWall(wallThickness: 0.375, weightPerFoot: 10.01),
    },
  ),
  PipeSchedule(
    nominalSize: '3',
    od: 3.500,
    schedules: {
      '40': PipeWall(wallThickness: 0.216, weightPerFoot: 7.58),
      '80': PipeWall(wallThickness: 0.300, weightPerFoot: 10.25),
      '160': PipeWall(wallThickness: 0.438, weightPerFoot: 14.32),
    },
  ),
  PipeSchedule(
    nominalSize: '4',
    od: 4.500,
    schedules: {
      '40': PipeWall(wallThickness: 0.237, weightPerFoot: 10.79),
      '80': PipeWall(wallThickness: 0.337, weightPerFoot: 14.98),
      '160': PipeWall(wallThickness: 0.531, weightPerFoot: 22.51),
    },
  ),
  PipeSchedule(
    nominalSize: '5',
    od: 5.563,
    schedules: {
      '40': PipeWall(wallThickness: 0.258, weightPerFoot: 14.62),
      '80': PipeWall(wallThickness: 0.375, weightPerFoot: 20.78),
      '160': PipeWall(wallThickness: 0.625, weightPerFoot: 32.96),
    },
  ),
  PipeSchedule(
    nominalSize: '6',
    od: 6.625,
    schedules: {
      '40': PipeWall(wallThickness: 0.280, weightPerFoot: 18.97),
      '80': PipeWall(wallThickness: 0.432, weightPerFoot: 28.57),
      '160': PipeWall(wallThickness: 0.719, weightPerFoot: 45.35),
    },
  ),
  PipeSchedule(
    nominalSize: '8',
    od: 8.625,
    schedules: {
      '40': PipeWall(wallThickness: 0.322, weightPerFoot: 28.55),
      '80': PipeWall(wallThickness: 0.500, weightPerFoot: 43.39),
      '160': PipeWall(wallThickness: 0.906, weightPerFoot: 74.69),
    },
  ),
  PipeSchedule(
    nominalSize: '10',
    od: 10.750,
    schedules: {
      '40': PipeWall(wallThickness: 0.365, weightPerFoot: 40.48),
      '80': PipeWall(wallThickness: 0.594, weightPerFoot: 64.43),
      '160': PipeWall(wallThickness: 1.125, weightPerFoot: 115.65),
    },
  ),
  PipeSchedule(
    nominalSize: '12',
    od: 12.750,
    schedules: {
      '40': PipeWall(wallThickness: 0.406, weightPerFoot: 53.52),
      '80': PipeWall(wallThickness: 0.688, weightPerFoot: 88.63),
      '160': PipeWall(wallThickness: 1.312, weightPerFoot: 160.27),
    },
  ),
];

// Calculate flow area in square inches
double calculateFlowArea(double id) {
  return 3.14159 * (id / 2) * (id / 2);
}

// Calculate pipe volume per foot in gallons
double calculateVolumePerFoot(double id) {
  // Area in sq inches × 12 inches / 231 cubic inches per gallon
  return calculateFlowArea(id) * 12 / 231;
}
