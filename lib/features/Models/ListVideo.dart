class LatihanVideoModel {
  final String id;
  final String namaGerakan;
  final String videoUrl;
  final int targetSet;
  final int targetRepetisi;
  final double targetWaktu;

  LatihanVideoModel({
    required this.id,
    required this.namaGerakan,
    required this.videoUrl,
    required this.targetSet,
    required this.targetRepetisi,
    required this.targetWaktu,
  });

  factory LatihanVideoModel.fromJson(Map<String, dynamic> json) {
    return LatihanVideoModel(
      id: json['id_list_video'],
      namaGerakan: json['nama_gerakan'],
      videoUrl: json['video_url'],
      targetSet: json['target_set'],
      targetRepetisi: json['target_repetisi'],
      targetWaktu: (json['target_waktu'] as num).toDouble(),
    );
  }
}
