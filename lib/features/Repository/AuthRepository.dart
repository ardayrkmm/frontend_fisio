import 'package:dio/dio.dart';
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/Auth/LoginResponse.dart';
import 'package:frontend_fisio/features/Models/Auth/RegisterResponse.dart';
import 'package:frontend_fisio/features/Models/Auth/VerifikasiResponse.dart';
import 'package:frontend_fisio/features/Models/UsersModel.dart';
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
      if (loginData.user.nama != null) {
        await prefs.setString('nama_user', loginData.user.nama!);
      }
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

  // --- BAGIAN BARU: GET PROFILE ---
  Future<UserModel> getProfile() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '${ApiConfig.baseUrl}auth/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal mengambil profil";
    }
  }

  // --- BAGIAN BARU: UPDATE PROFILE ---
  Future<UserModel> updateProfile({
    String? nama,
    String? noTelepon,
  }) async {
    try {
      final token = await getToken();
      final response = await _dio.put(
        '${ApiConfig.baseUrl}auth/update-profile',
        data: {
          if (nama != null) 'nama': nama,
          if (noTelepon != null) 'no_telepon': noTelepon,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Update data di Shared Preferences jika perlu (opsional, tapi bagus untuk cache)
      final user = UserModel.fromJson(response.data['user']);
      final prefs = await SharedPreferences.getInstance();
      if (user.nama != null) await prefs.setString('nama_user', user.nama!);

      return user;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal memperbarui profil";
    }
  }

// Fungsi Logout
  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token') && prefs.getString('token') != null;
  }

  Future<void> persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<void> persistUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user.nama != null) await prefs.setString('nama_user', user.nama!);
    if (user.id != null) await prefs.setString('id_user', user.id!);
    if (user.email != null) await prefs.setString('email_user', user.email!);
    if (user.noTelepon != null) await prefs.setString('phone_user', user.noTelepon!);
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('nama_user')) return null;
    
    return UserModel(
      id: prefs.getString('id_user'),
      nama: prefs.getString('nama_user'),
      email: prefs.getString('email_user'),
      noTelepon: prefs.getString('phone_user'),
    );
  }

  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nama_user');
    await prefs.remove('id_user');
    await prefs.remove('email_user');
    await prefs.remove('phone_user');
  }

  Future<void> logout() async {
    await deleteToken();
    await deleteUser();
  }
}
