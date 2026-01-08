import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/conversion_service.dart';
import 'settings_provider.dart';

// Length conversion state
class LengthConversionState {
  final double inputValue;
  final LengthUnit fromUnit;
  final LengthUnit toUnit;

  LengthConversionState({
    this.inputValue = 0,
    this.fromUnit = LengthUnit.inches,
    this.toUnit = LengthUnit.millimeters,
  });

  // Factory constructor for imperial defaults
  factory LengthConversionState.imperial() {
    return LengthConversionState(
      fromUnit: LengthUnit.inches,
      toUnit: LengthUnit.millimeters,
    );
  }

  // Factory constructor for metric defaults
  factory LengthConversionState.metric() {
    return LengthConversionState(
      fromUnit: LengthUnit.millimeters,
      toUnit: LengthUnit.inches,
    );
  }

  double get result =>
      ConversionService.convertLength(inputValue, fromUnit, toUnit);

  LengthConversionState copyWith({
    double? inputValue,
    LengthUnit? fromUnit,
    LengthUnit? toUnit,
  }) {
    return LengthConversionState(
      inputValue: inputValue ?? this.inputValue,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
    );
  }
}

class LengthConversionNotifier extends StateNotifier<LengthConversionState> {
  LengthConversionNotifier(String defaultUnit)
      : super(defaultUnit == 'metric'
            ? LengthConversionState.metric()
            : LengthConversionState.imperial());

  void setInputValue(double value) {
    state = state.copyWith(inputValue: value);
  }

  void setFromUnit(LengthUnit unit) {
    state = state.copyWith(fromUnit: unit);
  }

  void setToUnit(LengthUnit unit) {
    state = state.copyWith(toUnit: unit);
  }

  void swapUnits() {
    state = state.copyWith(
      fromUnit: state.toUnit,
      toUnit: state.fromUnit,
    );
  }
}

final lengthConversionProvider =
    StateNotifierProvider<LengthConversionNotifier, LengthConversionState>(
        (ref) {
  final settings = ref.watch(settingsProvider);
  return LengthConversionNotifier(settings.defaultUnit);
});

// Torque conversion state
class TorqueConversionState {
  final double inputValue;
  final TorqueUnit fromUnit;
  final TorqueUnit toUnit;

  TorqueConversionState({
    this.inputValue = 0,
    this.fromUnit = TorqueUnit.footPounds,
    this.toUnit = TorqueUnit.newtonMeters,
  });

  // Factory constructor for imperial defaults
  factory TorqueConversionState.imperial() {
    return TorqueConversionState(
      fromUnit: TorqueUnit.footPounds,
      toUnit: TorqueUnit.newtonMeters,
    );
  }

  // Factory constructor for metric defaults
  factory TorqueConversionState.metric() {
    return TorqueConversionState(
      fromUnit: TorqueUnit.newtonMeters,
      toUnit: TorqueUnit.footPounds,
    );
  }

  double get result =>
      ConversionService.convertTorque(inputValue, fromUnit, toUnit);

  TorqueConversionState copyWith({
    double? inputValue,
    TorqueUnit? fromUnit,
    TorqueUnit? toUnit,
  }) {
    return TorqueConversionState(
      inputValue: inputValue ?? this.inputValue,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
    );
  }
}

class TorqueConversionNotifier extends StateNotifier<TorqueConversionState> {
  TorqueConversionNotifier(String defaultUnit)
      : super(defaultUnit == 'metric'
            ? TorqueConversionState.metric()
            : TorqueConversionState.imperial());

  void setInputValue(double value) {
    state = state.copyWith(inputValue: value);
  }

  void setFromUnit(TorqueUnit unit) {
    state = state.copyWith(fromUnit: unit);
  }

  void setToUnit(TorqueUnit unit) {
    state = state.copyWith(toUnit: unit);
  }

  void swapUnits() {
    state = state.copyWith(
      fromUnit: state.toUnit,
      toUnit: state.fromUnit,
    );
  }
}

final torqueConversionProvider =
    StateNotifierProvider<TorqueConversionNotifier, TorqueConversionState>(
        (ref) {
  final settings = ref.watch(settingsProvider);
  return TorqueConversionNotifier(settings.defaultUnit);
});

// Temperature conversion state
class TemperatureConversionState {
  final double inputValue;
  final TemperatureUnit fromUnit;
  final TemperatureUnit toUnit;

  TemperatureConversionState({
    this.inputValue = 0,
    this.fromUnit = TemperatureUnit.fahrenheit,
    this.toUnit = TemperatureUnit.celsius,
  });

  // Factory constructor for imperial defaults (Fahrenheit first)
  factory TemperatureConversionState.imperial() {
    return TemperatureConversionState(
      fromUnit: TemperatureUnit.fahrenheit,
      toUnit: TemperatureUnit.celsius,
    );
  }

  // Factory constructor for metric defaults (Celsius first)
  factory TemperatureConversionState.metric() {
    return TemperatureConversionState(
      fromUnit: TemperatureUnit.celsius,
      toUnit: TemperatureUnit.fahrenheit,
    );
  }

  double get result =>
      ConversionService.convertTemperature(inputValue, fromUnit, toUnit);

  TemperatureConversionState copyWith({
    double? inputValue,
    TemperatureUnit? fromUnit,
    TemperatureUnit? toUnit,
  }) {
    return TemperatureConversionState(
      inputValue: inputValue ?? this.inputValue,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
    );
  }
}

class TemperatureConversionNotifier
    extends StateNotifier<TemperatureConversionState> {
  TemperatureConversionNotifier(String defaultUnit)
      : super(defaultUnit == 'metric'
            ? TemperatureConversionState.metric()
            : TemperatureConversionState.imperial());

  void setInputValue(double value) {
    state = state.copyWith(inputValue: value);
  }

  void setFromUnit(TemperatureUnit unit) {
    state = state.copyWith(fromUnit: unit);
  }

  void setToUnit(TemperatureUnit unit) {
    state = state.copyWith(toUnit: unit);
  }

  void swapUnits() {
    state = state.copyWith(
      fromUnit: state.toUnit,
      toUnit: state.fromUnit,
    );
  }
}

final temperatureConversionProvider = StateNotifierProvider<
    TemperatureConversionNotifier, TemperatureConversionState>((ref) {
  final settings = ref.watch(settingsProvider);
  return TemperatureConversionNotifier(settings.defaultUnit);
});
