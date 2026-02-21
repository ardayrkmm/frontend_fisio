import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Model untuk hasil deteksi dan klasifikasi pose
class PoseResult {
  final String poseName;
  final double confidence;
  final Pose? pose;
  final List<double> landmarks;
  final bool isCorrect;
  final DateTime timestamp;

  PoseResult({
    required this.poseName,
    required this.confidence,
    this.pose,
    required this.landmarks,
    required this.isCorrect,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Check if pose is detected with good confidence
  bool get isGoodDetection => confidence >= 0.7;

  /// Get confidence as percentage string
  String get confidencePercent => '${(confidence * 100).toStringAsFixed(1)}%';

  /// Copy with new values
  PoseResult copyWith({
    String? poseName,
    double? confidence,
    Pose? pose,
    List<double>? landmarks,
    bool? isCorrect,
    DateTime? timestamp,
  }) {
    return PoseResult(
      poseName: poseName ?? this.poseName,
      confidence: confidence ?? this.confidence,
      pose: pose ?? this.pose,
      landmarks: landmarks ?? this.landmarks,
      isCorrect: isCorrect ?? this.isCorrect,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'PoseResult(pose: $poseName, confidence: $confidencePercent, isCorrect: $isCorrect)';
  }
}
