class ApiConfig {
  static const String baseUrl = "http://192.168.1.5:5000/api/";

  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  static const String profile = "$baseUrl/auth/profile";
  static const String updateProfile = "$baseUrl/user/update";

  // Waktu timeout (opsional)
  static const int connectionTimeout = 5000; // 5 detik
  static const int receiveTimeout = 3000; // 3 detik

  /// Helper untuk membangun URL Media (Gambar/Video) secara aman
  static String buildMediaUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/400x300?text=No+Media';
    }

    // Jika sudah full URL, kembalikan langsung
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Bersihkan path dari leading slash
    String cleanPath = path;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    // Ambil Base URL tanpa /api/
    // Contoh: http://192.168.1.5:5000/api/ -> http://192.168.1.5:5000/
    String baseObj = baseUrl.replaceAll('/api/', '/');
    if (!baseObj.endsWith('/')) {
      baseObj = '$baseObj/';
    }

    // Return gabungan (misal: http://192.168.1.5:5000/uploads/lutut/x.png)
    return '$baseObj$cleanPath';
  }
}
