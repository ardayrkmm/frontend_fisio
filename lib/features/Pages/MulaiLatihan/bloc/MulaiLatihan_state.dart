import 'package:frontend_fisio/features/Models/gerakan.dart';

abstract class MLatihanState {}

class MLatihanLoading extends MLatihanState {}

class MLatihanLoaded extends MLatihanState {
  final List<GerakanModel> gerakan;

  MLatihanLoaded(this.gerakan);
}
