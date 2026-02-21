class PoseResult {
  final String poseName;
  final double confidence;
  final bool isCorrect;

  PoseResult({
    required this.poseName,
    required this.confidence,
    required this.isCorrect,
  });
}
