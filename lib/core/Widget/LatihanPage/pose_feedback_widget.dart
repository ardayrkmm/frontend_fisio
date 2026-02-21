import 'package:flutter/material.dart';
import 'package:frontend_fisio/features/Models/pose_result.dart';

/// Widget untuk menampilkan feedback hasil deteksi pose
class PoseFeedbackWidget extends StatelessWidget {
  final PoseResult? poseResult;
  final String targetPose;

  const PoseFeedbackWidget({
    super.key,
    required this.poseResult,
    required this.targetPose,
  });

  @override
  Widget build(BuildContext context) {
    if (poseResult == null) {
      return _buildNoDetection();
    }

    return _buildDetectionResult();
  }

  Widget _buildNoDetection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mencari Pose...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Posisikan tubuh di depan kamera',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionResult() {
    final isCorrect = poseResult!.isCorrect;
    final color = isCorrect ? Colors.green : Colors.orange;
    final icon = isCorrect ? Icons.check_circle : Icons.warning;
    final statusText = isCorrect ? 'Pose Benar!' : 'Perlu Perbaikan';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status row
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              // Confidence badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  poseResult!.confidencePercent,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Detected vs Target
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  'Terdeteksi',
                  _formatPoseName(poseResult!.poseName),
                  color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoChip(
                  'Target',
                  _formatPoseName(targetPose),
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatPoseName(String poseName) {
    // Convert snake_case to Title Case
    return poseName
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
