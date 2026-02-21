import 'package:frontend_fisio/features/Models/LatihanModel.dart';

class ProgramMingguan {
  final int minggu;
  final String fase;
  final List<LatihanModel> daftarHari;

  ProgramMingguan({
    required this.minggu,
    required this.fase,
    required this.daftarHari,
  });

  factory ProgramMingguan.fromJson(Map<String, dynamic> json) {
    try {
      final mingguValue = (json['minggu'] as num?)?.toInt() ?? 1;
      final faseValue = json['fase']?.toString() ?? 'Unknown';
      final daftarHariList = (json['daftar_hari'] as List<dynamic>? ?? [])
          .map<LatihanModel?>((e) {
            try {
              return LatihanModel.fromJson(e as Map<String, dynamic>);
            } catch (e) {
              print('❌ [PROGRAM] Error parsing daftar_hari: $e');
              return null;
            }
          })
          .whereType<LatihanModel>()
          .toList();

      return ProgramMingguan(
        minggu: mingguValue,
        fase: faseValue,
        daftarHari: daftarHariList,
      );
    } catch (e) {
      print('❌ [PROGRAM] Error parsing program: $e, json: $json');
      // Return safe default
      return ProgramMingguan(
        minggu: 1,
        fase: 'Unknown',
        daftarHari: [],
      );
    }
  }

  @override
  String toString() =>
      'ProgramMingguan(minggu: $minggu, fase: $fase, days: ${daftarHari.length})';
}
