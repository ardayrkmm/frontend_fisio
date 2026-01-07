import 'package:dio/dio.dart';
import 'package:frontend_fisio/features/Models/QuestionModel.dart';

class QuestionRepository {
  final Dio dio;

  QuestionRepository(this.dio);

  Future<List<QuestionModel>> getQuestions() async {
    final response = await dio.get("/questions");

    return (response.data as List)
        .map((json) => QuestionModel.fromJson(json))
        .toList();
  }

  Future<void> submitKondisiUser(
    Map<String, List<String>> answers,
  ) async {
    final payload = {
      "jawaban": answers.map(
        (key, value) => MapEntry(key, value), // value bisa []
      ),
    };

    await dio.post(
      "/kondisi-user",
      data: payload,
    );
  }
}
