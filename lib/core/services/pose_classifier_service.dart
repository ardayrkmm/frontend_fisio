import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PoseClassifierService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  static const int _sequenceLength = 15;
  static const int _featureCount =
      132; // 33 landmarks × 4 (x, y, z, confidence)

  final List<List<double>> _buffer = [];
  final List<String> _predictionHistory = [];
  static const int _smoothWindow = 5;

  // Debounce: prevent rapid consecutive increments

  bool get isInitialized => _isInitialized;

  Future<void> loadModel() async {
    try {
      print('📦 [LSTM] Loading model...');

      // Load interpreter
      _interpreter =
          await Interpreter.fromAsset('assets/models/pose_model_lstm.tflite');
      print('✅ [LSTM] Interpreter loaded successfully');

      // Load labels
      final labelsData =
          await rootBundle.loadString('assets/models/labels_lstm.txt');
      _labels = labelsData
          .split(RegExp(r'\r?\n'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      print('✅ [LSTM] Loaded ${_labels.length} labels: $_labels');

      if (_labels.isEmpty) {
        throw Exception('No labels loaded from file');
      }

      _isInitialized = true;
      print('✅ [LSTM] Model fully initialized and ready');
    } catch (e) {
      print('❌ [LSTM] Load error: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> classify(List<double> landmarks) async {
    if (!_isInitialized) {
      print('⚠️ [LSTM] Model not initialized');
      return null;
    }

    // Validate landmarks count
    if (landmarks.length != _featureCount) {
      print(
          '⚠️ [LSTM] Invalid landmarks count: ${landmarks.length} (expected $_featureCount)');
      return {
        'label': 'Invalid Pose',
        'confidence': 0.0,
        'isBufferReady': false,
      };
    }

    // Add to buffer
    _buffer.add(landmarks);
    if (_buffer.length > _sequenceLength) {
      _buffer.removeAt(0);
    }

    // Check if buffer is ready
    if (_buffer.length < _sequenceLength) {
      return {
        'label': 'Analyzing (${_buffer.length}/$_sequenceLength)',
        'confidence': 0.0,
        'isBufferReady': false,
      };
    }

    try {
      // Prepare input: convert List<List<double>> to List<List<List<double>>>
      final input = [_buffer]; // Shape: [1, _sequenceLength, _featureCount]

      // Prepare output
      final output =
          List.generate(1, (_) => List<double>.filled(_labels.length, 0.0));

      // Run inference
      _interpreter!.run(input, output);

      final scores = output[0];

      // Find max score and corresponding label
      int maxIndex = 0;
      double maxScore = scores[0];

      for (int i = 1; i < scores.length; i++) {
        if (scores[i] > maxScore) {
          maxScore = scores[i];
          maxIndex = i;
        }
      }

      // Ensure maxIndex is within bounds
      if (maxIndex >= _labels.length) {
        print('❌ [LSTM] Index out of bounds: $maxIndex >= ${_labels.length}');
        maxIndex = 0;
      }

      final label = _labels[maxIndex];

      // Add to history for smoothing
      _predictionHistory.add(label);
      if (_predictionHistory.length > _smoothWindow) {
        _predictionHistory.removeAt(0);
      }

      // Apply majority voting for smoother predictions
      final smoothLabel = _majorityVote(_predictionHistory);

      print(
          '🎯 [LSTM] Raw: $label (${(maxScore * 100).toStringAsFixed(1)}%) → Smooth: $smoothLabel');

      return {
        'label': smoothLabel,
        'confidence': maxScore,
        'isBufferReady': true,
        'rawLabel': label,
        'allScores': scores, // For debugging
      };
    } catch (e) {
      print('❌ [LSTM] Classification error: $e');
      return {
        'label': 'Error',
        'confidence': 0.0,
        'isBufferReady': false,
      };
    }
  }

  String _majorityVote(List<String> history) {
    if (history.isEmpty) return 'Unknown';

    final Map<String, int> count = {};
    for (final h in history) {
      count[h] = (count[h] ?? 0) + 1;
    }

    return count.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  void reset() {
    _buffer.clear();
    _predictionHistory.clear();
    print('🔄 [LSTM] Buffer reset');
  }

  void dispose() {
    print('🔌 [LSTM] Disposing...');
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
    _buffer.clear();
    _predictionHistory.clear();
  }
}
