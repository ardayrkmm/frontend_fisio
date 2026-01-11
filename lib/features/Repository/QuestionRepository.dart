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

  Future<void> submitKondisiUser(
    Map<String, List<String>> answers,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    /// FLATTEN ANSWERS
    final List<Map<String, String>> formattedAnswers = [];

    answers.forEach((questionId, optionIds) {
      for (final optionId in optionIds) {
        formattedAnswers.add({
          "question_id": questionId,
          "option_id": optionId,
        });
      }
    });

    final payload = {
      "id_bagian": _extractBagian(formattedAnswers),
      "answers": formattedAnswers,
    };

    await _dio.post(
      "${ApiConfig.baseUrl}latihanuser/kondisi",
      data: payload,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );
  }

  String _extractBagian(List<Map<String, String>> answers) {
    final bagianAnswer = answers.firstWhere(
      (e) => e['question_id'] == 'QUESTION_ID_BAGIAN',
      orElse: () => {},
    );

    return bagianAnswer['option_id'] ?? '';
  }
}
