import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class PoseDetectorService {
  PoseDetector? _poseDetector;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // ===== CONFIG (LOW-END FRIENDLY) =====
  static const double MIN_LANDMARK_CONF = 0.35;
  static const double VALID_LANDMARK_RATIO = 0.75;
  static const int REQUIRED_STABLE_FRAMES = 1;
  static const int FRAME_SKIP = 2;
  // ====================================

  int _stableFrameCount = 0;
  int _frameCounter = 0;

  /// Initialize pose detector
  Future<void> initialize() async {
    try {
      final options = PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
        model: PoseDetectionModel.base,
      );

      _poseDetector = PoseDetector(options: options);
      _isInitialized = true;

      print('✅ Pose Detector initialized');
    } catch (e) {
      print('❌ PoseDetector init error: $e');
      rethrow;
    }
  }

  /// Detect pose from camera frame
  Future<Map<String, dynamic>?> detectPose(
    CameraImage image,
    InputImageRotation rotation,
  ) async {
    if (!_isInitialized || _poseDetector == null) {
      return null;
    }

    // Validate image
    if (image.width <= 0 || image.height <= 0) {
      print(
          '⚠️ [POSE] Invalid image dimensions: ${image.width}x${image.height}');
      return null;
    }

    if (image.planes.isEmpty) {
      print('⚠️ [POSE] No planes in camera image');
      return null;
    }

    // ===== Frame skipping =====
    if (_frameCounter++ % FRAME_SKIP != 0) {
      return null;
    }

    try {
      final inputImage = _inputImageFromCameraImage(image, rotation);
      if (inputImage == null) {
        print('⚠️ [POSE] Failed to convert camera image to InputImage');
        return null;
      }

      final poses = await _poseDetector!.processImage(inputImage);
      if (poses.isEmpty) {
        _stableFrameCount = 0;
        return null;
      }

      final pose = poses.first;

      // ===== Stability check =====
      if (!_isPoseStable(pose)) {
        _stableFrameCount = 0;
        return null;
      }

      _stableFrameCount++;

      if (_stableFrameCount < REQUIRED_STABLE_FRAMES) {
        debugPrint(
            '⏳ Warming up pose ($_stableFrameCount/$REQUIRED_STABLE_FRAMES)');
        return null;
      }

      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final landmarks = _extractAndNormalizeLandmarks(pose, imageSize);

      return {
        'normalizedLandmarks': landmarks,
        'pose': pose,
      };
    } catch (e) {
      print('❌ Pose detect error: $e');
      return null;
    }
  }

  // ===== STABILITY CHECK =====
  bool _isPoseStable(Pose pose) {
    final valid = pose.landmarks.values
        .where((l) => l.likelihood > MIN_LANDMARK_CONF)
        .length;

    return (valid / pose.landmarks.length) >= VALID_LANDMARK_RATIO;
  }

  // ===== FEATURE EXTRACTION + NORMALIZATION =====
  List<double> _extractAndNormalizeLandmarks(
    Pose pose,
    Size imageSize,
  ) {
    // MediaPipe / MLKit logic:
    // x and y are in pixel coordinates [0, width] and [0, height].
    // z is in image coordinates scale, relative to hip center.

    // Training Data Logic:
    // The LSTM model was trained on data where:
    // x_norm = x / width
    // y_norm = y / height
    // z_norm = z / width (approx, maintaining aspect ratio logic)
    // visibility = likelihood

    // We must match this strictly. No centering, no "avgDim".

    final List<double> output = [];

    // Ensure we iterate through the 33 landmarks in correct Enum order (0-32)
    for (int i = 0; i < 33; i++) {
       final type = PoseLandmarkType.values[i];
       final landmark = pose.landmarks[type];

       if (landmark != null) {
          output.add(landmark.x / imageSize.width);
          output.add(landmark.y / imageSize.height);
          output.add(landmark.z / imageSize.width); // Z relative to width
          output.add(landmark.likelihood);
       } else {
          // If landmark missing (unlikely in MLKit unless blocked), pad with 0
          output.add(0.0);
          output.add(0.0);
          output.add(0.0);
          output.add(0.0);
       }
    }

    assert(
      output.length == 132,
      'Expected 132 features (33 landmarks × 4), got ${output.length}',
    );

    // Print values for debugging (first landmark - nose)
    if (output.isNotEmpty) {
      print(
        '✓ [POSE_NORM] Nose: x=${output[0].toStringAsFixed(3)}, y=${output[1].toStringAsFixed(3)}, z=${output[2].toStringAsFixed(3)}, conf=${(output[3] * 100).toStringAsFixed(0)}%',
      );
    }

    return output;
  }

  // ===== CAMERA IMAGE → INPUT IMAGE =====
  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    InputImageRotation rotation,
  ) {
    try {
      // For YUV420 images, combine all planes properly
      final WriteBuffer buffer = WriteBuffer();
      for (final plane in image.planes) {
        buffer.putUint8List(plane.bytes);
      }

      final bytes = buffer.done().buffer.asUint8List();
      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      // Force YUV_420_888 format for consistent input
      // This matches the ImageFormatGroup.yuv420 we set in camera
      InputImageFormat format;
      if (Platform.isAndroid) {
        format = InputImageFormat.yuv_420_888;
      } else {
        // iOS typically uses YUV or BGRA
        final imageFormat =
            InputImageFormatValue.fromRawValue(image.format.raw);
        format = imageFormat ?? InputImageFormat.nv21;
      }

      // Calculate bytesPerRow properly for the first (Y) plane
      // This is critical for correct image interpretation
      final bytesPerRow = image.planes.isNotEmpty
          ? image.planes.first.bytesPerRow
          : image.width; // Fallback to width if bytesPerRow is 0

      print(
        '📷 [INPUT_IMAGE] Format: $format, Size: ${image.width}x${image.height}, BytesPerRow: $bytesPerRow, TotalBytes: ${bytes.length}',
      );

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: imageSize,
          rotation: rotation,
          format: format,
          bytesPerRow: bytesPerRow,
        ),
      );
    } catch (e) {
      print('❌ InputImage error: $e');
      return null;
    }
  }

  void dispose() {
    _poseDetector?.close();
    _poseDetector = null;
    _isInitialized = false;
  }
}
