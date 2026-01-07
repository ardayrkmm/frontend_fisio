class ApiConfig {
  static const String baseUrl = "https://api.kamu.com/api/";

  // Daftar Endpoints
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  static const String profile = "$baseUrl/user/profile";
  static const String updateProfile = "$baseUrl/user/update";

  // Waktu timeout (opsional)
  static const int connectionTimeout = 5000; // 5 detik
  static const int receiveTimeout = 3000; // 3 detik
}
