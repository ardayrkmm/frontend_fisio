import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart'; //
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/LatihanModel.dart';
import 'package:frontend_fisio/features/Models/Response/LatihanResponse.dart';

class LatihanRepository {
  final Dio _dio = Dio();

  // Mengambil token menggunakan SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance(); //
    return prefs.getString('token'); //
  }

  Future<Options> _authOptions() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("UNAUTHORIZED");
    }

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<List<LatihanModel>> getLatihan(int week) async {
    try {
      final res = await _dio.get(
        '${ApiConfig.baseUrl}latihanuser/jadwal',
        queryParameters: {'week': week},
        options: await _authOptions(),
      );

      final List listJadwal = res.data['jadwal'];

      return listJadwal.map((e) => LatihanModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil daftar latihan");
    }
  }

  Future<LatihanGenerateResponse> generateJadwalOtomatis() async {
    try {
      String? token = await _getToken(); //

      final response = await _dio.post(
        '${ApiConfig.baseUrl}latihanuser/generate-jadwal', //
        options: Options(
          headers: {'Authorization': 'Bearer $token'}, //
        ),
      );

      return LatihanGenerateResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Menangani error 404 dari Go: "Silahkan isi form kondisi terlebih dahulu"
      if (e.response?.statusCode == 404) {
        throw Exception("BELUM_ISI_KONDISI");
      }

      // Menangani error 401 Unauthorized
      if (e.response?.statusCode == 401) {
        throw Exception("UNAUTHORIZED");
      }

      throw Exception("Gagal memuat data: ${e.message}");
    }
  }
}
