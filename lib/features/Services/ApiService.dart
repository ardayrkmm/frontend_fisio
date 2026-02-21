import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart';

import 'package:shared_preferences/shared_preferences.dart'; // Add import

class ApiService {
  late final Dio _dio;
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl, 
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Add interceptor to add token and handle errors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token'); // Use 'token' from SharedPreferences
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
           // Handle 401 Unauthorized globally if needed
           if (e.response?.statusCode == 401) {
             // Navigate to login or clear token
           }
           return handler.next(e);
        },
      ),
    );
  }

  // --- JADWAL ENDPOINTS ---

  Future<JadwalHariIniResponse> getJadwalHariIni() async {
    try {
      final response = await _dio.get('latihanuser/jadwal/hari-ini');
      return JadwalHariIniResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<JadwalFaseResponse> getJadwalFase() async {
    try {
      final response = await _dio.get('latihanuser/jadwal/fase');
      return JadwalFaseResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      // Server error
      return e.response?.data['message'] ?? 'Terjadi kesalahan pada server';
    } else {
      // Connection error
      return 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
    }
  }
}
