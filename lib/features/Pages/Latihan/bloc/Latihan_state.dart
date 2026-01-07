import 'package:equatable/equatable.dart';

class ExerciseState extends Equatable {
  final int repetition;
  final int totalRepetition;
  final int set;
  final int totalSet;
  final double timer;
  final bool isPaused;

  const ExerciseState({
    required this.repetition,
    required this.totalRepetition,
    required this.set,
    required this.totalSet,
    required this.timer,
    required this.isPaused,
  });

  factory ExerciseState.initial() {
    return const ExerciseState(
      repetition: 1,
      totalRepetition: 8,
      set: 2,
      totalSet: 3,
      timer: 5.00,
      isPaused: false,
    );
  }

  ExerciseState copyWith({
    int? repetition,
    int? set,
    double? timer,
    bool? isPaused,
  }) {
    return ExerciseState(
      repetition: repetition ?? this.repetition,
      totalRepetition: totalRepetition,
      set: set ?? this.set,
      totalSet: totalSet,
      timer: timer ?? this.timer,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object?> get props => [repetition, set, timer, isPaused];
}
