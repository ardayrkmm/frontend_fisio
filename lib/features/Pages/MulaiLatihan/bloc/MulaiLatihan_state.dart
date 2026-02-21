import 'package:flick_video_player/flick_video_player.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart';

abstract class MLatihanState {}

class MLatihanInitial extends MLatihanState {}

class MLatihanLoading extends MLatihanState {}

class MLatihanLoaded extends MLatihanState {
  final List<JadwalDetailModel> gerakan; // Updated type
  final FlickManager? flickManager;
  final String? currentUrl;
  final bool isNavigating;

  MLatihanLoaded({
    required this.gerakan,
    this.flickManager,
    this.currentUrl,
    this.isNavigating = false,
  });

  // CopyWith for easy state updates
  MLatihanLoaded copyWith({
    List<JadwalDetailModel>? gerakan,
    FlickManager? flickManager,
    String? currentUrl,
    bool? isNavigating,
  }) {
    return MLatihanLoaded(
      gerakan: gerakan ?? this.gerakan,
      flickManager: flickManager ?? this.flickManager,
      currentUrl: currentUrl ?? this.currentUrl,
      isNavigating: isNavigating ?? this.isNavigating,
    );
  }
}

class MLatihanError extends MLatihanState {
  final String message;
  MLatihanError(this.message);
}
