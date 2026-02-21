import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

/// Custom painter untuk menggambar pose landmarks dan skeleton
/// Kombinasi Google ML Kit pose detection + TFLITE LSTM classification
class PosePainter extends CustomPainter {
  final Pose? pose;
  final Size imageSize;
  final bool isCorrectPose;
  final double confidence;
  final String? poseLabel; // LSTM classification result
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  PosePainter({
    required this.pose,
    required this.imageSize,
    this.isCorrectPose = false,
    this.confidence = 0.0,
    this.poseLabel,
    this.rotation = InputImageRotation.rotation270deg,
    this.cameraLensDirection = CameraLensDirection.front,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (pose == null) return;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = _getSkeletonColor();

    // Draw skeleton connections
    _drawSkeleton(canvas, size, linePaint);

    // Draw landmarks with labels and confidence
    _drawLandmarksWithInfo(canvas, size);

    // Draw LSTM classification result at top
    if (poseLabel != null) {
      _drawClassificationOverlay(canvas, size);
    }
  }

  /// Get skeleton color based on pose correctness
  Color _getSkeletonColor() {
    if (isCorrectPose && confidence > 0.8) {
      return Colors.green;
    } else if (isCorrectPose && confidence > 0.6) {
      return Colors.lightGreen;
    } else if (confidence > 0.6) {
      return Colors.yellow;
    } else {
      return Colors.orange;
    }
  }

  /// Get landmark color based on confidence threshold
  Color _getLandmarkColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.green; // High confidence
    } else if (confidence >= 0.6) {
      return Colors.lightGreen; // Medium confidence
    } else if (confidence >= 0.4) {
      return Colors.yellow; // Low confidence
    } else {
      return Colors.orange; // Very low confidence
    }
  }

  void _drawLandmarksWithInfo(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white;

    // Landmark names mapping
    final landmarkNames = {
      PoseLandmarkType.nose: '👃 Nose',
      PoseLandmarkType.leftEye: '👁️ L.Eye',
      PoseLandmarkType.rightEye: '👁️ R.Eye',
      PoseLandmarkType.leftEar: '👂 L.Ear',
      PoseLandmarkType.rightEar: '👂 R.Ear',
      PoseLandmarkType.leftShoulder: '💪 L.Shoulder',
      PoseLandmarkType.rightShoulder: '💪 R.Shoulder',
      PoseLandmarkType.leftElbow: '🔗 L.Elbow',
      PoseLandmarkType.rightElbow: '🔗 R.Elbow',
      PoseLandmarkType.leftWrist: '✋ L.Wrist',
      PoseLandmarkType.rightWrist: '✋ R.Wrist',
      PoseLandmarkType.leftHip: '🏃 L.Hip',
      PoseLandmarkType.rightHip: '🏃 R.Hip',
      PoseLandmarkType.leftKnee: '🦵 L.Knee',
      PoseLandmarkType.rightKnee: '🦵 R.Knee',
      PoseLandmarkType.leftAnkle: '👞 L.Ankle',
      PoseLandmarkType.rightAnkle: '👞 R.Ankle',
    };

    pose!.landmarks.forEach((type, landmark) {
      final point = _translatePoint(
        landmark.x,
        landmark.y,
        size,
        imageSize,
        rotation: InputImageRotation.rotation270deg,
        cameraLensDirection: CameraLensDirection.front,
      );

      // Get color based on confidence
      final color = _getLandmarkColor(landmark.likelihood);
      paint.color = color.withOpacity(0.7);

      // Draw landmark circle
      canvas.drawCircle(point, 7.0, paint);

      // Draw white border
      borderPaint.color = Colors.white;
      canvas.drawCircle(point, 5.0, borderPaint);

      // Draw landmark name and confidence (only for high confidence landmarks)
      if (landmark.likelihood >= 0.6) {
        final label = landmarkNames[type] ?? 'Unknown';
        final confText = '${(landmark.likelihood * 100).toStringAsFixed(0)}%';

        _drawText(canvas, '$label\n$confText', point.translate(10, -15));
      }
    });
  }

  void _drawSkeleton(Canvas canvas, Size size, Paint paint) {
    // Define skeleton connections
    final connections = [
      // Face
      [PoseLandmarkType.leftEar, PoseLandmarkType.leftEye],
      [PoseLandmarkType.leftEye, PoseLandmarkType.nose],
      [PoseLandmarkType.nose, PoseLandmarkType.rightEye],
      [PoseLandmarkType.rightEye, PoseLandmarkType.rightEar],

      // Shoulders
      [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],

      // Left arm
      [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow],
      [PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist],

      // Right arm
      [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
      [PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist],

      // Torso
      [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
      [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
      [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],

      // Left leg
      [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
      [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],

      // Right leg
      [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
      [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
    ];

    for (final connection in connections) {
      final landmark1 = pose!.landmarks[connection[0]];
      final landmark2 = pose!.landmarks[connection[1]];

      if (landmark1 != null &&
          landmark2 != null &&
          landmark1.likelihood >= 0.5 &&
          landmark2.likelihood >= 0.5) {
        final point1 = _translatePoint(
          landmark1.x,
          landmark1.y,
          size,
          imageSize,
          rotation: InputImageRotation.rotation270deg,
          cameraLensDirection: CameraLensDirection.front,
        );
        final point2 = _translatePoint(
          landmark2.x,
          landmark2.y,
          size,
          imageSize,
          rotation: InputImageRotation.rotation270deg,
          cameraLensDirection: CameraLensDirection.front,
        );

        canvas.drawLine(point1, point2, paint);
      }
    }
  }

  /// Draw LSTM classification result as overlay at top
  void _drawClassificationOverlay(Canvas canvas, Size size) {
    // Background box
    final boxPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final boxRect = Rect.fromLTWH(0, 0, size.width, 80);
    canvas.drawRect(boxRect, boxPaint);

    // Border
    final borderPaint = Paint()
      ..color = _getSkeletonColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRect(boxRect, borderPaint);

    // Text
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '🤖 Pose: ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '$poseLabel\n',
            style: TextStyle(
              color: _getSkeletonColor(),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text:
                'Confidence: ${(confidence * 100).toStringAsFixed(1)}% | Status: ${isCorrectPose ? "✅ CORRECT" : "⚠️ CHECK"}',
            style: TextStyle(
              color: isCorrectPose ? Colors.greenAccent : Colors.yellow,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width - 20);
    textPainter.paint(canvas, const Offset(10, 10));
  }

  /// Helper to draw text on canvas (simple version)
  void _drawText(Canvas canvas, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(200, 0, 0, 0),
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  Offset _translatePoint(
    double x,
    double y,
    Size canvasSize,
    Size imageSize, {
    required InputImageRotation rotation,
    required CameraLensDirection cameraLensDirection,
  }) {
    double scaleX = canvasSize.width / imageSize.width;
    double scaleY = canvasSize.height / imageSize.height;

    double finalX = x * scaleX;
    double finalY = y * scaleY;

    if (Platform.isAndroid) {
      // Mirroring for front camera on Android
      if (cameraLensDirection == CameraLensDirection.front) {
        finalX = canvasSize.width - finalX;
      }
    } else if (Platform.isIOS) {
      // iOS front camera mirroring
      if (cameraLensDirection == CameraLensDirection.front) {
        finalX = canvasSize.width - finalX;
      }
    }

    return Offset(finalX, finalY);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.isCorrectPose != isCorrectPose ||
        oldDelegate.confidence != confidence ||
        oldDelegate.poseLabel != poseLabel;
  }
}
