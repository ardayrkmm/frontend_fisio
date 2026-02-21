import 'package:dio/dio.dart';
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/QuestionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionRepository {
  final Dio _dio = Dio();
  Future<List<QuestionModel>> getQuestions() async {
    final response = await _dio.get("${ApiConfig.baseUrl}questions");

    return (response.data as List)
        .map((json) => QuestionModel.fromJson(json))
        .toList();
  }

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

  Future<void> submitKondisiUser(
    Map<String, List<String>> answers,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(
        'token'); // Pastikan key ini SAMA PERSIS dengan saat kamu nyimpen pas Login

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final List<Map<String, String>> formattedAnswers = [];
    String? idBagian;

    // Looping semua jawaban dari state
    answers.forEach((questionId, optionIds) {
      for (final optionId in optionIds) {
        // Kita masukkan semua jawaban ke list
        formattedAnswers.add({
          "question_id": questionId,
          "option_id": optionId,
        });
      }
    });

    final payload = {
      "id_bagian":
          "null", // Biarkan Flask yang memproses dari answers, atau hardcode ID-nya jika untuk testing
      "answers": formattedAnswers,
    };

    try {
      final response = await _dio.post(
        "${ApiConfig.baseUrl}kondisi-user", // Removed leading slash
        data: payload,
        options: await _authOptions(),
      );

      // --- PERBAIKAN LOGIKA BACA RESPONSE DI SINI ---
      if (response.statusCode == 401) {
        throw Exception("Sesi kadaluarsa (401). Silakan login ulang.");
      } else if (response.statusCode != 201 && response.statusCode != 200) {
        // Cek apakah response.data adalah JSON (Map)
        if (response.data is Map) {
          throw Exception(response.data['error'] ??
              response.data['message'] ??
              "Gagal dengan status ${response.statusCode}");
        } else {
          // Jika response.data adalah String/HTML (Flask Error)
          print(
              "FLASK HTML ERROR: ${response.data}"); // Print ke console agar kamu bisa baca error aslinya
          throw Exception(
              "Terjadi kesalahan di server (Status ${response.statusCode}). Cek console untuk detail.");
        }
      }
    } catch (e) {
      throw Exception("Gagal terhubung ke server: $e");
    }
  }

  String _extractBagian(List<Map<String, String>> answers) {
    final bagianAnswer = answers.firstWhere(
      (e) => e['question_id'] == 'QUESTION_ID_BAGIAN',
      orElse: () => <String, String>{},
    );

    return bagianAnswer['option_id'] ?? '';
  }
}
