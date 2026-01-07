// models/workout_model.dart
import 'package:frontend_fisio/features/Models/gerakan.dart';

class WorkoutModel {
  final String title;
  final int totalMinutes;
  final String date;
  final List<GerakanModel> exercises;

  WorkoutModel({
    required this.title,
    required this.totalMinutes,
    required this.date,
    required this.exercises,
  });
}
