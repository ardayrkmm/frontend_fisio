import 'package:frontend_fisio/features/Models/ListVideo.dart';

class LatihanModel {
  final String idLatihan;
  final String title;
  final String image;
  final String description;
  final String date;

  final List<LatihanVideoModel> videos;

  LatihanModel({
    required this.idLatihan,
    required this.title,
    required this.image,
    required this.description,
    required this.date,
    required this.videos,
  });

  /// helper (dipakai UI Anda)
  int get totalExercise => videos.length;

  /// contoh durasi: total target waktu semua video
  int get duration => videos.fold(0, (sum, v) => sum + v.targetWaktu.toInt());

  factory LatihanModel.fromJson(Map<String, dynamic> json) {
    return LatihanModel(
      idLatihan: json['id_latihan'],
      title: json['nama_latihan'],
      image: json['url_gambar'] ?? 'assets/pl.jpg',
      description: json['deskripsi'] ?? '',
      date: json['created_at'],
      videos: (json['videos'] as List? ?? [])
          .map((e) => LatihanVideoModel.fromJson(e))
          .toList(),
    );
  }
}
