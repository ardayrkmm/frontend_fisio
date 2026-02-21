import 'package:dio/dio.dart';
import 'package:frontend_fisio/features/Models/program.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/LatihanModel.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart';

class LatihanRepository {
  final Dio _dio = Dio(
  BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),

    // 🔥 INI FIX PALING PENTING
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
  /// GET JADWAL AKTIF BERDASARKAN FASE
  /// =========================
  Future<JadwalFaseData?> getJadwalFase() async {
    try {
      print("📡 [REPO] Fetching Jadwal Fase Aktif...");
      final res = await _dio.get(
        'latihanuser/jadwal/fase',
        options: await _authOptions(),
      );

      final body = res.data;

      if (body is! Map<String, dynamic>) {
        throw Exception("INVALID_RESPONSE: Body is not a Map");
      }

      final response = JadwalFaseResponse.fromJson(body);

      if (!response.success) {
        if (response.code == "ACTIVE_PROGRAM_NOT_FOUND") return null;
        throw Exception("API Error: ${response.code} - ${response.message}");
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw Exception("UNAUTHORIZED");
      if (e.response?.statusCode == 404) {
        final body = e.response?.data;
        if (body is Map && body['code'] == 'ACTIVE_PROGRAM_NOT_FOUND') {
          return null;
        }
      }
      rethrow;
    }
  }

  /// =========================
  /// GET SEMUA JADWAL
  /// =========================
  Future<List<JadwalFaseData>> getSemuaJadwal() async {
    try {
      print("📡 [REPO] Fetching Semua Jadwal...");
      final res = await _dio.get(
        'latihanuser/jadwal/semua',
        options: await _authOptions(),
      );

      final body = res.data;

      if (body is! Map<String, dynamic>) {
        throw Exception("INVALID_RESPONSE: Body is not a Map");
      }

      final response = JadwalSemuaResponse.fromJson(body);

      if (!response.success) {
        throw Exception("API Error: ${response.code} - ${response.message}");
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw Exception("UNAUTHORIZED");
      rethrow;
    }
  }

  /// =========================
  /// GENERATE JADWAL
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
