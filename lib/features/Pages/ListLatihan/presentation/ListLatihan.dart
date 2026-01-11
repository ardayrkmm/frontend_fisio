import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Repository/LatihanRepository.dart';
import '../bloc/latihan_bloc.dart';
import '../bloc/latihan_event.dart';
import '../bloc/latihan_state.dart';

class LatihanPage extends StatelessWidget {
  const LatihanPage({super.key});
  void _showKondisiDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User wajib klik tombol
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Data Belum Lengkap"),
          content: const Text(
              "Anda belum mengisi kondisi kesehatan terbaru. Silahkan isi form terlebih dahulu."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                // Ganti dengan route halaman validasi kamu
                Navigator.pushNamed(context, '/validasi');
              },
              child: const Text("Ayo Isi"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget LatihanList() {
      return BlocBuilder<LatihanBloc, LatihanState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.latihanList.isEmpty) {
            return const Center(child: Text("Tidak ada latihan tersedia"));
          }
          return ListView.builder(
            itemCount: state.latihanList.length,
            itemBuilder: (context, index) {
              final item = state.latihanList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: item.image.startsWith('http')
                        ? NetworkImage(item.image)
                        : AssetImage(item.image) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.date,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${item.totalExercise} Latihan',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Text(
                        '${item.duration} menit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    Widget weekSelector() {
      return BlocBuilder<LatihanBloc, LatihanState>(
        builder: (context, state) {
          return Row(
            children: List.generate(4, (index) {
              final week = index + 1;
              final isSelected = state.selectedWeek == week;

              return GestureDetector(
                onTap: () {
                  context.read<LatihanBloc>().add(ChangeWeek(week));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Week',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$week',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      );
    }

    return BlocProvider(
      create: (_) =>
          LatihanBloc(context.read<LatihanRepository>())..add(LoadLatihan()),
      child: BlocListener<LatihanBloc, LatihanState>(
        listener: (context, state) {
          if (state.isKondisiEmpty) {
            _showKondisiDialog(context);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Latihan',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  weekSelector(),
                  const SizedBox(height: 20),
                  Expanded(child: LatihanList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
