import 'package:dio/dio.dart';
import 'package:frontend_fisio/features/Models/LatihanModel.dart';

class LatihanRepository {
  final Dio dio;
  LatihanRepository(this.dio);

  Future<List<LatihanModel>> getLatihan(int week) async {
    final res = await dio.get(
      '/latihan/jadwal',
      queryParameters: {'week': week},
    );

    return (res.data as List).map((e) => LatihanModel.fromJson(e)).toList();
  }
}
