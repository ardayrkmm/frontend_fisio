import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/Auth/LoginResponse.dart';
import 'package:frontend_fisio/features/Models/Auth/RegisterResponse.dart';
import 'package:frontend_fisio/features/Models/Auth/VerifikasiResponse.dart';

class Authrepository {
  final Dio _dio = Dio();
  final _storage = FlutterSecureStorage();
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}auth/login',
        data: {'email': email, 'password': password},
      );

      final loginData = LoginResponse.fromJson(response.data);

      await _storage.write(key: 'token', value: loginData.token);

      return loginData;
    } catch (e) {
      throw Exception("Login Gagal");
    }
  }

  Future<RegisterResponse> register({
    required String email,
    required String nama,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}auth/register',
        data: {
          'email': email,
          'nama': nama,
          'no_telepon': phone,
          'password': password,
        },
      );

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal mendaftar";
    }
  }

  Future<VerifikasiResponse> Verifikasi({
    required String token,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}auth/verify-email',
        data: {
          "token": token,
          "otp": otp,
        },
      );

      return VerifikasiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal mendaftar";
    }
  }

  // Fungsi untuk mengecek apakah token masih ada (untuk Splash Screen)
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
