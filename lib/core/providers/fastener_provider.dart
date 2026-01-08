import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fastener_data.dart';

// Provider for bolt data list
final boltDataProvider = Provider<List<FastenerData>>((ref) {
  return boltData;
});

// Provider for all bolt diameters
final boltDiametersProvider = Provider<List<String>>((ref) {
  return getAllBoltDiameters();
});

// State notifier for selected bolt diameter
class SelectedBoltNotifier extends StateNotifier<String?> {
  SelectedBoltNotifier() : super(null);

  void select(String? diameter) {
    state = diameter;
  }
}

final selectedBoltProvider =
    StateNotifierProvider<SelectedBoltNotifier, String?>((ref) {
  return SelectedBoltNotifier();
});

// State notifier for hex type toggle
class HexTypeNotifier extends StateNotifier<bool> {
  HexTypeNotifier() : super(false); // false = Finished Hex, true = Heavy Hex

  void toggle() {
    state = !state;
  }

  void setHeavyHex(bool isHeavy) {
    state = isHeavy;
  }
}

final hexTypeProvider = StateNotifierProvider<HexTypeNotifier, bool>((ref) {
  return HexTypeNotifier();
});

// Computed provider for selected fastener data
final selectedFastenerProvider = Provider<FastenerData?>((ref) {
  final selectedDiameter = ref.watch(selectedBoltProvider);
  if (selectedDiameter == null) return null;
  return findFastenerByDiameter(selectedDiameter);
});

// Computed provider for wrench size based on hex type
final wrenchSizeProvider = Provider<String?>((ref) {
  final fastener = ref.watch(selectedFastenerProvider);
  final isHeavyHex = ref.watch(hexTypeProvider);
  if (fastener == null) return null;
  return fastener.getWrenchSize(isHeavyHex);
});
