// bloc/workout_state.dart
import 'package:frontend_fisio/features/Models/WorkoutModel.dart';

abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final WorkoutModel workout;

  WorkoutLoaded(this.workout);
}
