class JadwalHariIniResponse {
  final String? idJadwal;
  final String? tanggal;
  final String? message;
  final List<JadwalDetailModel> program; // Updated to use JadwalDetailModel structure if backend reuses it

  JadwalHariIniResponse({
    this.idJadwal,
    this.tanggal,
    this.message,
    required this.program,
  });

  factory JadwalHariIniResponse.fromJson(Map<String, dynamic> json) {
    // If backend returns program list similar to jadwal/minggu structure
    return JadwalHariIniResponse(
      idJadwal: json['id_jadwal'],
      tanggal: json['tanggal'],
      message: json['message'],
      program: (json['program'] as List?)
              ?.map((e) => JadwalDetailModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}



class JadwalFaseResponse {
  final bool success;
  final JadwalFaseData? data;
  final String? code;
  final String? message;

  JadwalFaseResponse({required this.success, this.data, this.code, this.message});

  factory JadwalFaseResponse.fromJson(Map<String, dynamic> json) {
    return JadwalFaseResponse(
      success: json['success'] ?? false,
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? JadwalFaseData.fromJson(json['data']) : null,
    );
  }
}

class JadwalSemuaResponse {
  final bool success;
  final List<JadwalFaseData> data;
  final String? code;
  final String? message;

  JadwalSemuaResponse({required this.success, required this.data, this.code, this.message});

  factory JadwalSemuaResponse.fromJson(Map<String, dynamic> json) {
    return JadwalSemuaResponse(
      success: json['success'] ?? false,
      code: json['code'],
      message: json['message'],
      data: (json['data'] as List?)
              ?.map((e) => JadwalFaseData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class JadwalFaseData {
  final String programId;
  final String namaProgram;
  final String fase;
  final String tanggalMulai;
  final int totalLatihan;
  final List<JadwalDetailModel> jadwal;

  JadwalFaseData({
    required this.programId,
    required this.namaProgram,
    required this.fase,
    required this.tanggalMulai,
    required this.totalLatihan,
    required this.jadwal,
  });

  factory JadwalFaseData.fromJson(Map<String, dynamic> json) {
    return JadwalFaseData(
      programId: json['program_id'] ?? '',
      namaProgram: json['nama_program'] ?? '',
      fase: json['fase']?.toString().isNotEmpty == true ? json['fase'] : 'F1',
      tanggalMulai: json['tanggal_mulai'] ?? '',
      totalLatihan: json['total_latihan'] ?? 0,
      // Map array latihans array (JSON response calls it 'latihan') to list of JadwalDetailModel to reuse downstream components
      jadwal: (json['latihan'] as List?)?.map((e) {
        // e is a dict representing LatihanDetailModel, but JadwalDetailModel expects: idJadwal, namaJadwal, tanggal, status, latihan
        return JadwalDetailModel(
          idJadwal: json['program_id'] ?? '',
          namaJadwal: json['nama_program'] ?? '',
          tanggal: json['tanggal_mulai'] ?? '',
          status: 'Pending', // Default
          latihan: LatihanDetailModel.fromJson(e),
        );
      }).toList() ?? [],
    );
  }
}

class JadwalMingguanResponse {
  final bool success;
  final JadwalMingguanData? data;

  JadwalMingguanResponse({required this.success, this.data});

  factory JadwalMingguanResponse.fromJson(Map<String, dynamic> json) {
    return JadwalMingguanResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? JadwalMingguanData.fromJson(json['data']) : null,
    );
  }
}

class JadwalMingguanData {
  final int week;
  final int totalLatihan;
  final List<JadwalDetailModel> jadwal;

  JadwalMingguanData({
    required this.week, 
    required this.totalLatihan,
    required this.jadwal
  });

  factory JadwalMingguanData.fromJson(Map<String, dynamic> json) {
    return JadwalMingguanData(
      week: json['week'] ?? 1,
      totalLatihan: json['total_latihan'] ?? 0,
      jadwal: (json['jadwal'] as List?)
              ?.map((e) => JadwalDetailModel.fromJson(e)) // Maps directly from response['data']['jadwal']
              .toList() ??
          [],
    );
  }
}

// Root Object in List
class JadwalDetailModel {
  final String idJadwal;
  final String namaJadwal;
  final String tanggal;
  final String status;
  final LatihanDetailModel latihan;

  JadwalDetailModel({
    required this.idJadwal,
    required this.namaJadwal,
    required this.tanggal,
    required this.status,
    required this.latihan,
  });

  factory JadwalDetailModel.fromJson(Map<String, dynamic> json) {
    return JadwalDetailModel(
      idJadwal: json['id_jadwal'] ?? '',
      namaJadwal: json['nama_jadwal'] ?? '',
      tanggal: json['tanggal'] ?? '',
      status: json['status'] ?? '',
      latihan: LatihanDetailModel.fromJson(json['latihan'] ?? {}),
    );
  }
}

// Nested Object
class LatihanDetailModel {
  final String idLatihan;
  final String namaLatihan;
  final String deskripsi; // Added as it is in backend response
  final String? imageUrl;
  final String? videoUrl;
  final int level;
  final int duration; // Added duration from backend response
  final String? sisi; // Kanan/Kiri/Null
  final TargetModel target;

  LatihanDetailModel({
    required this.idLatihan,
    required this.namaLatihan,
    this.deskripsi = '',
    this.imageUrl,
    this.videoUrl,
    required this.level,
    required this.duration,
    this.sisi,
    required this.target,
  });

  factory LatihanDetailModel.fromJson(Map<String, dynamic> json) {
    String? parsedSisi;
    if (json['sisi'] is List) {
      parsedSisi = (json['sisi'] as List).map((e) => e.toString()).join(', ');
      if (parsedSisi.isEmpty) parsedSisi = null;
    } else {
      parsedSisi = json['sisi']?.toString();
    }

    return LatihanDetailModel(
      idLatihan: json['id_latihan'] ?? '',
      namaLatihan: json['nama_latihan'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      imageUrl: json['image_url'], 
      videoUrl: json['video_url'],
      level: (json['level'] as num?)?.toInt() ?? 1,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      sisi: parsedSisi,
      target: TargetModel.fromJson(json['target'] ?? {}),
    );
  }
}

// Target Object
class TargetModel {
  final int set;
  final int repetisi;
  final int waktu;

  TargetModel({
    required this.set, 
    required this.repetisi, 
    required this.waktu
  });

  factory TargetModel.fromJson(Map<String, dynamic> json) {
    return TargetModel(
      set: (json['set'] as num?)?.toInt() ?? 0,
      repetisi: (json['repetisi'] as num?)?.toInt() ?? 0,
      waktu: (json['waktu'] as num?)?.toInt() ?? 0,
    );
  }
}
