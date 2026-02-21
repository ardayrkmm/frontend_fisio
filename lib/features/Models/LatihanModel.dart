import 'package:frontend_fisio/features/Models/latihanDetail.dart';

class LatihanModel {
  final String idJadwal;
  final String date;
  final String status;
  final LatihanDetailModel? latihan; 
  
  // Metadata from API
  final int totalExercise;
  final int duration;

  LatihanModel({
    required this.idJadwal,
    required this.date,
    required this.status,
    this.latihan,
    this.totalExercise = 0,
    this.duration = 0,
  });

  /// Helper for safe integer parsing
  static int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Helper for safe string parsing
  static String _safeString(dynamic value) {
    return value?.toString() ?? '';
  }

  factory LatihanModel.fromJson(Map<String, dynamic> json) {
    // 1. Extract 'latihan' object from API
    final latData = json['latihan'];
    LatihanDetailModel? detailModel;
    int apiTotal = 1; // Default 1 exercise per card now
    int apiDuration = 0;

    if (latData != null && latData is Map<String, dynamic>) {
       // Pass 'latData' to detail model. It contains id_latihan, target, etc.
       // We also add back 'id_jadwal' if needed by video model
       latData['id_jadwal'] = json['id_jadwal'];
       
       detailModel = LatihanDetailModel.fromJson(latData);
       
       // Calc total duration from single exercise
       final target = latData['target'];
       if (target is Map) {
          apiDuration = (target['waktu'] as num?)?.toInt() ?? 0;
       } else {
          apiDuration = (latData['duration'] as num?)?.toInt() ?? 0;
       }
    }

    return LatihanModel(
      idJadwal: _safeString(json['id_jadwal']),
      date: _safeString(json['tanggal']),
      status: _safeString(json['status']),
      latihan: detailModel,
      totalExercise: apiTotal,
      duration: apiDuration,
    );
  }
}
