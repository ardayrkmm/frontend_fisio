class LatihanVideoModel {
  final String id;
  final String namaGerakan;
  final String videoUrl;
  final int targetSet;
  final int targetRepetisi;
  final double targetWaktu;
  final String? idJadwal;
  final String? sisi; // New field for Side (Kanan/Kiri)

  LatihanVideoModel({
    required this.id,
    required this.namaGerakan,
    required this.videoUrl,
    required this.targetSet,
    required this.targetRepetisi,
    required this.targetWaktu,
    this.idJadwal,
    this.sisi,
  });

  factory LatihanVideoModel.fromJson(Map<String, dynamic> json) {
    try {
      // Check for nested target object (new API structure)
      final target = json['target']; 
      int tSet = 1;
      int tRep = 1;
      double tTime = 0.0;

      if (target is Map) {
        tSet = (target['set'] as num?)?.toInt() ?? 1;
        tRep = (target['repetisi'] as num?)?.toInt() ?? 1;
        tTime = (target['waktu'] as num?)?.toDouble() ?? 0.0;
      } else {
        // Fallbact to flat structure (old API or internally flattened)
        tSet = (json['target_set'] as num?)?.toInt() ?? 1;
        tRep = (json['target_repetisi'] as num?)?.toInt() ?? 1;
        tTime = (json['target_waktu'] as num?)?.toDouble() ?? 0.0;
      }

      return LatihanVideoModel(
        id: json['id_latihan']?.toString() ?? json['id_list_video']?.toString() ?? '',
        namaGerakan: json['nama_latihan']?.toString() ?? json['nama_gerakan']?.toString() ?? '',
        videoUrl: json['video_url']?.toString() ?? '',
        targetSet: tSet,
        targetRepetisi: tRep,
        targetWaktu: tTime,
        idJadwal: json['id_jadwal']?.toString(),
        sisi: json['sisi']?.toString(),
      );
    } catch (e) {
      print('❌ [VIDEO_MODEL] Error parsing video: $e, json: $json');
      return LatihanVideoModel(
        id: '',
        namaGerakan: 'Unknown Exercise',
        videoUrl: '',
        targetSet: 1,
        targetRepetisi: 1,
        targetWaktu: 0.0,
      );
    }
  }

  @override
  String toString() =>
      'LatihanVideoModel(id: $id, nama: $namaGerakan, videoUrl: $videoUrl, sisi: $sisi)';

  // Compatibility getter
  String get id_latihan => id;
}
