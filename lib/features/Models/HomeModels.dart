class HomeHistoryData {
  final String tanggal;
  final String latihan;
  final double akurasi;
  final int benar;
  final int salah;
  final String nilai;

  HomeHistoryData({
    required this.tanggal,
    required this.latihan,
    required this.akurasi,
    required this.benar,
    required this.salah,
    required this.nilai,
  });

  factory HomeHistoryData.fromJson(Map<String, dynamic> json) {
    return HomeHistoryData(
      tanggal: json['tanggal'] ?? '',
      latihan: json['latihan'] ?? '',
      akurasi: (json['akurasi'] as num?)?.toDouble() ?? 0.0,
      benar: (json['benar'] as num?)?.toInt() ?? 0,
      salah: (json['salah'] as num?)?.toInt() ?? 0,
      nilai: json['nilai'] ?? '',
    );
  }
}

class HomeHistoryResponse {
  final bool success;
  final List<HomeHistoryData> data;

  HomeHistoryResponse({required this.success, required this.data});

  factory HomeHistoryResponse.fromJson(Map<String, dynamic> json) {
    return HomeHistoryResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
              ?.map((e) => HomeHistoryData.fromJson(e))
              .toList() ??
          [],
    );
  }
}
