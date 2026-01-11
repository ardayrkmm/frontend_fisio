import 'package:frontend_fisio/features/Models/LatihanModel.dart';

class LatihanGenerateResponse {
  final String message;
  final String userId;
  final List<LatihanModel> latihan;

  LatihanGenerateResponse({
    required this.message,
    required this.userId,
    required this.latihan,
  });

  factory LatihanGenerateResponse.fromJson(Map<String, dynamic> json) {
    return LatihanGenerateResponse(
      message: json['message'] ?? '',
      userId: json['user_id'] ?? '',
      latihan: (json['latihan'] as List)
          .map((item) => LatihanModel.fromJson(item))
          .toList(),
    );
  }
}
