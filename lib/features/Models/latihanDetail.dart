import 'package:frontend_fisio/features/Models/ListVideo.dart';

class LatihanDetailModel {
  final String idLatihan;
  final String namaLatihan;
  final String imageUrl;
  final String deskripsi;
  final int level;
  final List<LatihanVideoModel> videos;

  LatihanDetailModel({
    required this.idLatihan,
    required this.namaLatihan,
    required this.imageUrl,
    this.deskripsi = '',
    this.level = 1,
    required this.videos,
  });

  factory LatihanDetailModel.fromJson(Map<String, dynamic> json) {
    // New Logic: The backend returns a single exercise in 'latihan', 
    // effectively making this a list of 1 video for the UI.
    final video = LatihanVideoModel.fromJson(json); // Parse self as video info

    return LatihanDetailModel(
      idLatihan: json['id_latihan'] ?? '',
      namaLatihan: json['nama_latihan'] ?? '',
      imageUrl: json['image_url'] ?? json['url_gambar'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      videos: [video], // Wrap single video in list
    );
  }
}
