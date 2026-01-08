import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final double textScale;
  final bool largeButtons;
  final bool highContrast;
  final String defaultUnit; // 'imperial' or 'metric'

  const AppSettings({
    this.textScale = 1.0,
    this.largeButtons = false,
    this.highContrast = false,
    this.defaultUnit = 'imperial',
  });

  AppSettings copyWith({
    double? textScale,
    bool? largeButtons,
    bool? highContrast,
    String? defaultUnit,
  }) {
    return AppSettings(
      textScale: textScale ?? this.textScale,
      largeButtons: largeButtons ?? this.largeButtons,
      highContrast: highContrast ?? this.highContrast,
      defaultUnit: defaultUnit ?? this.defaultUnit,
    );
  }

  // Button height based on settings
  double get buttonHeight => largeButtons ? 64.0 : 48.0;

  // Input field height
  double get inputHeight => largeButtons ? 60.0 : 48.0;

  // List tile height
  double get tileHeight => largeButtons ? 80.0 : 56.0;

  // Icon size
  double get iconSize => largeButtons ? 28.0 : 24.0;
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      textScale: prefs.getDouble('text_scale') ?? 1.0,
      largeButtons: prefs.getBool('large_buttons') ?? false,
      highContrast: prefs.getBool('high_contrast') ?? false,
      defaultUnit: prefs.getString('default_unit') ?? 'imperial',
    );
  }

  Future<void> setTextScale(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('text_scale', scale);
    state = state.copyWith(textScale: scale);
  }

  Future<void> setLargeButtons(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('large_buttons', value);
    state = state.copyWith(largeButtons: value);
  }

  Future<void> setHighContrast(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('high_contrast', value);
    state = state.copyWith(highContrast: value);
  }

  Future<void> setDefaultUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('default_unit', unit);
    state = state.copyWith(defaultUnit: unit);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
