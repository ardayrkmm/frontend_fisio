class PemanasanModel {
  final String namaGerakan;
  final String videoUrl;
  final int durasiDetik;
  final int urutan;

  PemanasanModel({
    required this.namaGerakan,
    required this.videoUrl,
    required this.durasiDetik,
    required this.urutan,
  });

  factory PemanasanModel.fromJson(Map<String, dynamic> json) {
    return PemanasanModel(
      namaGerakan: json['nama_gerakan'] ?? '',
      videoUrl: json['video_url'] ?? '',
      durasiDetik: (json['durasi_detik'] as num?)?.toInt() ?? 0,
      urutan: (json['urutan'] as num?)?.toInt() ?? 0,
    );
  }
}
