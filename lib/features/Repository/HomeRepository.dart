import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/HomeModels.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart'; // Reuse JadwalFaseData

class HomeRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Options> _authOptions() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("UNAUTHORIZED - No token found");
    }

    return Options(
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// =========================
  /// FETCH LATIHAN TERAKHIR
  /// =========================
  Future<HomeHistoryData?> getLastWorkout() async {
    try {
      final res = await _dio.get(
        'history/me',
        options: await _authOptions(),
      );

      final body = res.data;
      if (body is! Map<String, dynamic>) {
        throw Exception("INVALID_RESPONSE");
      }

      final response = HomeHistoryResponse.fromJson(body);
      if (response.success && response.data.isNotEmpty) {
        return response.data.first;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw Exception("UNAUTHORIZED");
      return null; // Return null if error or simply no history
    }
  }

  /// =========================
  /// CHECK ACTIVE PROGRAM
  /// =========================
  Future<JadwalFaseData?> getActiveProgram() async {
    try {
      final res = await _dio.get(
        'latihanuser/jadwal/fase',
        options: await _authOptions(),
      );

      final body = res.data;
      if (body is! Map<String, dynamic>) {
        throw Exception("INVALID_RESPONSE");
      }

      final response = JadwalFaseResponse.fromJson(body);

      if (!response.success) {
        if (response.code == "ACTIVE_PROGRAM_NOT_FOUND") return null;
        throw Exception("API Error: ${response.code}");
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw Exception("UNAUTHORIZED");
      if (e.response?.statusCode == 404) {
        return null; // As in LatihanRepository
      }
      rethrow;
    }
  }

  /// =========================
  /// GENERATE JADWAL (To Check Kondisi Status)
  /// =========================
  Future<Map<String, dynamic>> generateJadwalOtomatis() async {
    try {
      final res = await _dio.post(
        'latihanuser/generate-jadwal',
        options: await _authOptions(),
      );

      final body = res.data;
      String message = "";
      if (body is Map && body.containsKey('message')) {
        message = body['message'].toString();
      }

      return {
        'statusCode': res.statusCode ?? 500,
        'message': message,
      };

    } on DioException catch (e) {
      if (e.response != null) {
        final body = e.response!.data;
        String msg = "";
        if (body is Map && body.containsKey('message')) {
          msg = body['message'].toString();
        }
        return {
          'statusCode': e.response!.statusCode ?? 500,
          'message': msg,
        };
      }
      rethrow;
    }
  }
}
