import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/search/global_search_screen.dart';
import '../../features/converters/quick_conversion_screen.dart';
import '../../features/fasteners/fastener_lookup_screen.dart';
import '../../features/calculators/calculators_hub_screen.dart';
import '../../features/calculators/alignment_calculator_screen.dart';
import '../../features/calculators/belt_length_calculator.dart';
import '../../features/calculators/pulley_rpm_calculator.dart';
import '../../features/calculators/hydraulic_calculator.dart';
import '../../features/calculators/saw_blade_calculator.dart';
import '../../features/calculators/rise_run_calculator.dart';
import '../../features/calculators/belt_tension_calculator.dart';
import '../../features/calculators/bearing_fit_calculator.dart';
import '../../features/calculators/gear_ratio_calculator.dart';
import '../../features/calculators/motor_hp_calculator.dart';
import '../../features/calculators/thermal_expansion_calculator.dart';
import '../../features/calculators/conveyor_calculator.dart';
import '../../features/calculators/pump_flow_calculator.dart';
import '../../features/calculators/surface_area_calculator.dart';
import '../../features/reference/reference_hub_screen.dart';
import '../../features/reference/fraction_reference_screen.dart';
import '../../features/reference/torque_spec_screen.dart';
import '../../features/reference/pipe_thread_screen.dart';
import '../../features/reference/pipe_schedule_screen.dart';
import '../../features/reference/oring_screen.dart';
import '../../features/reference/lubricant_screen.dart';
import '../../features/reference/hardness_screen.dart';
import '../../features/reference/wire_screen.dart';
import '../../features/reference/drill_tap_screen.dart';
import '../../features/welding/welding_hub_screen.dart';
import '../../features/welding/welding_rod_screen.dart';
import '../../features/welding/torch_flame_screen.dart';
import '../../features/welding/metal_gauge_screen.dart';
import '../../features/welding/anti_seize_screen.dart';
import '../../features/welding/weld_joints_screen.dart';
import '../../features/welding/welding_process_screen.dart';
import '../../features/welding/amperage_screen.dart';
import '../../features/welding/preheat_calculator_screen.dart';
import '../../features/rigging/rigging_hub_screen.dart';
import '../../features/rigging/knots_screen.dart';
import '../../features/rigging/sling_wll_screen.dart';
import '../../features/rigging/load_calculator_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/conversion',
  routes: [
    GoRoute(
      path: '/search',
      builder: (context, state) => const GlobalSearchScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/conversion',
          builder: (context, state) => const QuickConversionScreen(),
        ),
        GoRoute(
          path: '/fasteners',
          builder: (context, state) => const FastenerLookupScreen(),
        ),
        GoRoute(
          path: '/calculators',
          builder: (context, state) => const CalculatorsHubScreen(),
          routes: [
            GoRoute(
              path: 'alignment',
              builder: (context, state) => const AlignmentCalculatorScreen(),
            ),
            GoRoute(
              path: 'belt-length',
              builder: (context, state) => const BeltLengthCalculator(),
            ),
            GoRoute(
              path: 'pulley-rpm',
              builder: (context, state) => const PulleyRpmCalculator(),
            ),
            GoRoute(
              path: 'hydraulic',
              builder: (context, state) => const HydraulicCalculator(),
            ),
            GoRoute(
              path: 'saw-blade',
              builder: (context, state) => const SawBladeCalculator(),
            ),
            GoRoute(
              path: 'rise-run',
              builder: (context, state) => const RiseRunCalculator(),
            ),
            GoRoute(
              path: 'belt-tension',
              builder: (context, state) => const BeltTensionCalculator(),
            ),
            GoRoute(
              path: 'bearing-fit',
              builder: (context, state) => const BearingFitCalculator(),
            ),
            GoRoute(
              path: 'gear-ratio',
              builder: (context, state) => const GearRatioCalculator(),
            ),
            GoRoute(
              path: 'motor-hp',
              builder: (context, state) => const MotorHpCalculator(),
            ),
            GoRoute(
              path: 'thermal-expansion',
              builder: (context, state) => const ThermalExpansionCalculator(),
            ),
            GoRoute(
              path: 'conveyor',
              builder: (context, state) => const ConveyorCalculator(),
            ),
            GoRoute(
              path: 'pump',
              builder: (context, state) => const PumpFlowCalculator(),
            ),
            GoRoute(
              path: 'surface-area',
              builder: (context, state) => const SurfaceAreaCalculator(),
            ),
          ],
        ),
        GoRoute(
          path: '/reference',
          builder: (context, state) => const ReferenceHubScreen(),
          routes: [
            GoRoute(
              path: 'fractions',
              builder: (context, state) => const FractionReferenceScreen(),
            ),
            GoRoute(
              path: 'torque',
              builder: (context, state) => const TorqueSpecScreen(),
            ),
            GoRoute(
              path: 'pipe-thread',
              builder: (context, state) => const PipeThreadScreen(),
            ),
            GoRoute(
              path: 'pipe-schedule',
              builder: (context, state) => const PipeScheduleScreen(),
            ),
            GoRoute(
              path: 'o-ring',
              builder: (context, state) => const ORingScreen(),
            ),
            GoRoute(
              path: 'lubricant',
              builder: (context, state) => const LubricantScreen(),
            ),
            GoRoute(
              path: 'hardness',
              builder: (context, state) => const HardnessScreen(),
            ),
            GoRoute(
              path: 'wire',
              builder: (context, state) => const WireScreen(),
            ),
            GoRoute(
              path: 'drill-tap',
              builder: (context, state) => const DrillTapScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/welding',
          builder: (context, state) => const WeldingHubScreen(),
          routes: [
            GoRoute(
              path: 'rods',
              builder: (context, state) => const WeldingRodScreen(),
            ),
            GoRoute(
              path: 'torch',
              builder: (context, state) => const TorchFlameScreen(),
            ),
            GoRoute(
              path: 'gauges',
              builder: (context, state) => const MetalGaugeScreen(),
            ),
            GoRoute(
              path: 'anti-seize',
              builder: (context, state) => const AntiSeizeScreen(),
            ),
            GoRoute(
              path: 'joints',
              builder: (context, state) => const WeldJointsScreen(),
            ),
            GoRoute(
              path: 'processes',
              builder: (context, state) => const WeldingProcessScreen(),
            ),
            GoRoute(
              path: 'amperage',
              builder: (context, state) => const AmperageScreen(),
            ),
            GoRoute(
              path: 'preheat',
              builder: (context, state) => const PreheatCalculatorScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/rigging',
          builder: (context, state) => const RiggingHubScreen(),
          routes: [
            GoRoute(
              path: 'knots',
              builder: (context, state) => const KnotsScreen(),
            ),
            GoRoute(
              path: 'sling-wll',
              builder: (context, state) => const SlingWllScreen(),
            ),
            GoRoute(
              path: 'load-calc',
              builder: (context, state) => const LoadCalculatorScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/search'),
        tooltip: 'Search',
        child: const Icon(Icons.search),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.swap_horiz),
            selectedIcon: Icon(Icons.swap_horiz_outlined),
            label: 'Convert',
          ),
          NavigationDestination(
            icon: Icon(Icons.hardware),
            selectedIcon: Icon(Icons.hardware_outlined),
            label: 'Fasteners',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            selectedIcon: Icon(Icons.calculate_outlined),
            label: 'Calc',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_fire_department),
            selectedIcon: Icon(Icons.local_fire_department_outlined),
            label: 'Welding',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            selectedIcon: Icon(Icons.fitness_center_outlined),
            label: 'Rigging',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            selectedIcon: Icon(Icons.menu_book_outlined),
            label: 'Ref',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/conversion')) return 0;
    if (location.startsWith('/fasteners')) return 1;
    if (location.startsWith('/calculators')) return 2;
    if (location.startsWith('/welding')) return 3;
    if (location.startsWith('/rigging')) return 4;
    if (location.startsWith('/reference')) return 5;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/conversion');
        break;
      case 1:
        context.go('/fasteners');
        break;
      case 2:
        context.go('/calculators');
        break;
      case 3:
        context.go('/welding');
        break;
      case 4:
        context.go('/rigging');
        break;
      case 5:
        context.go('/reference');
        break;
    }
  }
}
