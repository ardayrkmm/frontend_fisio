import 'package:flutter/material.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart';
import 'package:frontend_fisio/features/Services/ApiService.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/presentation/MulaiLatihan.dart';

class JadwalLatihanScreen extends StatefulWidget {
  const JadwalLatihanScreen({Key? key}) : super(key: key);

  @override
  State<JadwalLatihanScreen> createState() => _JadwalLatihanScreenState();
}

class _JadwalLatihanScreenState extends State<JadwalLatihanScreen> {
  final ApiService _apiService = ApiService();
  late Future<JadwalHariIniResponse> _jadwalHariIniFuture;
  late Future<JadwalFaseResponse> _jadwalFaseFuture;

  @override
  void initState() {
    super.initState();
    _jadwalHariIniFuture = _apiService.getJadwalHariIni();
    _loadFase();
  }

  void _loadFase() {
    _jadwalFaseFuture = _apiService.getJadwalFase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Latihan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER (HARI INI)
              const Text(
                "Jadwal Hari Ini",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildHariIniSection(),

              const SizedBox(height: 20),

              // LIST FASE AKTIF
              const Text(
                "Jadwal Program Aktif",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildFaseList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHariIniSection() {
    return FutureBuilder<JadwalHariIniResponse>(
      future: _jadwalHariIniFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          if (data.program.isEmpty) {
            return _buildIstirahatCard(data.message);
          }
          final program = data.program.first;
          
          // Safe Image URL Check
          final imageUrl = program.latihan.imageUrl;
          final hasImage = imageUrl != null && imageUrl.isNotEmpty;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(height: 150, color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.latihan.namaLatihan,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(program.latihan.deskripsi.isNotEmpty ? program.latihan.deskripsi : "Tidak ada deskripsi"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 16),
                          const SizedBox(width: 5),
                          Text("${_calculateDuration(program)} menit"),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                              // Convert/Pass JadwalDetailModel directly
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LatihanDetailPage(latihan: [program]),
                                ),
                              );
                          },
                          child: const Text("Mulai Latihan"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );

        }
        return const SizedBox();
      },
    );
  }

  Widget _buildIstirahatCard(String? message) {
    return Card(
      color: Colors.blue[50],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.weekend, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              message ?? "Hari ini jadwal istirahat",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text("Gunakan waktu ini untuk recovery tubuh."),
          ],
        ),
      ),
    );
  }

  Widget _buildFaseList() {
    return FutureBuilder<JadwalFaseResponse>(
      future: _jadwalFaseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final list = snapshot.data?.data?.jadwal ?? [];
          if (list.isEmpty) {
             return const Center(child: Text("Belum ada program aktif."));
          }
          
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = list[index];
              final isLocked = item.status == 'locked';
              final isDone = item.status == 'done';
              
              return Card(
                color: isDone ? Colors.green[50] : (isLocked ? Colors.grey[200] : Colors.white),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isDone ? Colors.green : (isLocked ? Colors.grey : Colors.blue),
                    child: Icon(
                      isDone ? Icons.check : (isLocked ? Icons.lock : Icons.play_arrow),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    item.latihan.namaLatihan, // Use nested name
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "Target: ${item.latihan.target.repetisi} Reps × ${item.latihan.target.set} Set",
                    style: TextStyle(color: isLocked ? Colors.grey : Colors.black54),
                  ),
                  trailing: isLocked 
                      ? const Icon(Icons.lock_outline, color: Colors.grey) 
                      : const Icon(Icons.chevron_right),
                  onTap: isLocked ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LatihanDetailPage(latihan: [item]),
                        ),
                      );
                  },
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  int _calculateDuration(JadwalDetailModel program) {
    // Updated Logic: Use nested target info
    final target = program.latihan.target;
    // Calculate total seconds: set * waktu (assuming waktu is per set? or total?)
    // If waktu is total duration in seconds:
    int totalDetik = target.waktu; 
    
    // If logic was previously (waktu * set), stick to that if strict match needed.
    // Assuming 'waktu' in TargetModel is duration per set or total duration.
    // Let's use logic: if totalDetik is small (< 60), maybe it's per rep? 
    // Usually 'waktu' is 'duration' in seconds.
    
    if (totalDetik == 0) {
        // Fallback estimate: 30s per set?
        totalDetik = target.set * 30;
    }
    
    // If target.waktu is per set:
    // totalDetik = target.waktu * target.set;

    return (totalDetik / 60).ceil();
  }
}
