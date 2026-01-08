import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

// Fastener favorites provider
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = await DatabaseService.getFastenerFavorites();
  }

  Future<void> toggleFavorite(String boltDiameter) async {
    if (state.contains(boltDiameter)) {
      await DatabaseService.removeFastenerFavorite(boltDiameter);
      state = state.where((d) => d != boltDiameter).toList();
    } else {
      await DatabaseService.addFastenerFavorite(boltDiameter);
      state = [boltDiameter, ...state];
    }
  }

  bool isFavorite(String boltDiameter) {
    return state.contains(boltDiameter);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

// Recent conversions provider
class RecentConversionsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  RecentConversionsNotifier() : super([]) {
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    state = await DatabaseService.getRecentConversions(limit: 20);
  }

  Future<void> addConversion({
    required String conversionType,
    required double inputValue,
    required String fromUnit,
    required String toUnit,
    required double resultValue,
  }) async {
    await DatabaseService.addRecentConversion(
      conversionType: conversionType,
      inputValue: inputValue,
      fromUnit: fromUnit,
      toUnit: toUnit,
      resultValue: resultValue,
    );
    await _loadRecent();
  }

  Future<void> clearHistory() async {
    await DatabaseService.clearRecentConversions();
    state = [];
  }
}

final recentConversionsProvider =
    StateNotifierProvider<RecentConversionsNotifier, List<Map<String, dynamic>>>((ref) {
  return RecentConversionsNotifier();
});
