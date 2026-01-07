import 'package:equatable/equatable.dart';

abstract class ExerciseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartExercise extends ExerciseEvent {}

class PauseExercise extends ExerciseEvent {}

class NextRepetition extends ExerciseEvent {}
