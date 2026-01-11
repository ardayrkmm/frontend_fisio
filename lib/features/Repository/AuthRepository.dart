import 'package:dio/dio.dart';
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/Auth/LoginResponse.dart';
import 'package:frontend_fisio/features/Models/Auth/RegisterResponse.dart';
import 'package:frontend_fisio/features/Models/Auth/VerifikasiResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authrepository {
  final Dio _dio = Dio();
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}auth/login',
        data: {'email': email, 'password': password},
      );

      final loginData = LoginResponse.fromJson(response.data);

      // --- BAGIAN UPDATE: SIMPAN KE SHARED PREFERENCES ---
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginData.token);
      // --------------------------------------------------

      return loginData;
    } on DioException catch (e) {
      // Lebih baik tangkap pesan error dari backend jika ada
      String message = e.response?.data['message'] ?? "Login Gagal";
      throw Exception(message);
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem");
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
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Mengambil string dengan key 'token'
  }

// Fungsi Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Menghapus data berdasarkan key 'token'
  }
}
