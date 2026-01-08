import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alignment_data.dart';

class AlignmentState {
  final DialReading stationaryReading;
  final DialReading movableReading;
  final double dialSpacing;
  final double frontFootDistance;
  final double backFootDistance;
  final AlignmentResult? result;

  const AlignmentState({
    this.stationaryReading = const DialReading(),
    this.movableReading = const DialReading(),
    this.dialSpacing = 10.0,
    this.frontFootDistance = 6.0,
    this.backFootDistance = 18.0,
    this.result,
  });

  AlignmentState copyWith({
    DialReading? stationaryReading,
    DialReading? movableReading,
    double? dialSpacing,
    double? frontFootDistance,
    double? backFootDistance,
    AlignmentResult? result,
  }) {
    return AlignmentState(
      stationaryReading: stationaryReading ?? this.stationaryReading,
      movableReading: movableReading ?? this.movableReading,
      dialSpacing: dialSpacing ?? this.dialSpacing,
      frontFootDistance: frontFootDistance ?? this.frontFootDistance,
      backFootDistance: backFootDistance ?? this.backFootDistance,
      result: result ?? this.result,
    );
  }
}

class AlignmentNotifier extends StateNotifier<AlignmentState> {
  AlignmentNotifier() : super(const AlignmentState());

  void setStationaryTop(double value) {
    state = state.copyWith(
      stationaryReading: state.stationaryReading.copyWith(top: value),
    );
    _calculate();
  }

  void setStationaryBottom(double value) {
    state = state.copyWith(
      stationaryReading: state.stationaryReading.copyWith(bottom: value),
    );
    _calculate();
  }

  void setStationaryLeft(double value) {
    state = state.copyWith(
      stationaryReading: state.stationaryReading.copyWith(left: value),
    );
    _calculate();
  }

  void setStationaryRight(double value) {
    state = state.copyWith(
      stationaryReading: state.stationaryReading.copyWith(right: value),
    );
    _calculate();
  }

  void setMovableTop(double value) {
    state = state.copyWith(
      movableReading: state.movableReading.copyWith(top: value),
    );
    _calculate();
  }

  void setMovableBottom(double value) {
    state = state.copyWith(
      movableReading: state.movableReading.copyWith(bottom: value),
    );
    _calculate();
  }

  void setMovableLeft(double value) {
    state = state.copyWith(
      movableReading: state.movableReading.copyWith(left: value),
    );
    _calculate();
  }

  void setMovableRight(double value) {
    state = state.copyWith(
      movableReading: state.movableReading.copyWith(right: value),
    );
    _calculate();
  }

  void setDialSpacing(double value) {
    state = state.copyWith(dialSpacing: value);
    _calculate();
  }

  void setFrontFootDistance(double value) {
    state = state.copyWith(frontFootDistance: value);
    _calculate();
  }

  void setBackFootDistance(double value) {
    state = state.copyWith(backFootDistance: value);
    _calculate();
  }

  void _calculate() {
    if (state.dialSpacing > 0) {
      final result = AlignmentCalculator.calculate(
        stationaryReading: state.stationaryReading,
        movableReading: state.movableReading,
        dialSpacing: state.dialSpacing,
        frontFootDistance: state.frontFootDistance,
        backFootDistance: state.backFootDistance,
      );
      state = state.copyWith(result: result);
    }
  }

  void reset() {
    state = const AlignmentState();
  }
}

final alignmentProvider =
    StateNotifierProvider<AlignmentNotifier, AlignmentState>((ref) {
  return AlignmentNotifier();
});
