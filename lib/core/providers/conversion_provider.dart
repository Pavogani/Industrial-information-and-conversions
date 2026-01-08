import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/conversion_service.dart';

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
  LengthConversionNotifier() : super(LengthConversionState());

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
  return LengthConversionNotifier();
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
  TorqueConversionNotifier() : super(TorqueConversionState());

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
  return TorqueConversionNotifier();
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
  TemperatureConversionNotifier() : super(TemperatureConversionState());

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
  return TemperatureConversionNotifier();
});
