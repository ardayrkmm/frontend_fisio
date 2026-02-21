import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/presentation/MulaiLatihan.dart';
import 'package:frontend_fisio/features/Repository/LatihanRepository.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart';
import 'package:frontend_fisio/features/Config.dart';
import '../bloc/latihan_bloc.dart';
import '../bloc/latihan_event.dart';
import '../bloc/latihan_state.dart';

class LatihanPage extends StatelessWidget {
  const LatihanPage({super.key});

  String _buildImageUrl(String imageUrl) {
    return ApiConfig.buildMediaUrl(imageUrl);
  }

  void _showKondisiDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                Navigator.pop(context);
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
    return BlocProvider(
      create: (_) => LatihanBloc(context.read<LatihanRepository>())..add(LoadLatihan()),
      child: BlocListener<LatihanBloc, LatihanState>(
        listener: (context, state) {
          if (state.isKondisiEmpty) {
            _showKondisiDialog(context);
          }
        },
        child: BlocBuilder<LatihanBloc, LatihanState>(
          builder: (context, state) {
            return Scaffold(
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
                      // TABS FASE
                      Row(
                        children: [
                          _buildTabButton(context, "Fase 1", "F1", state.selectedFase),
                          const SizedBox(width: 8),
                          _buildTabButton(context, "Fase 2", "F2", state.selectedFase),
                          const SizedBox(width: 8),
                          _buildTabButton(context, "Fase 3", "F3", state.selectedFase),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _buildLatihanContent(context, state),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String title, String faseValue, String selectedFase) {
    final bool isSelected = faseValue == selectedFase;
    return GestureDetector(
      onTap: () {
        context.read<LatihanBloc>().add(ChangeFase(faseValue));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? biruTerang : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: biruTerang),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : biruTerang,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLatihanContent(BuildContext context, LatihanState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredPrograms = state.allPrograms
        .where((p) => p.fase == state.selectedFase)
        .toList();

    if (filteredPrograms.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada fase disini",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredPrograms.length,
      itemBuilder: (context, index) {
        final program = filteredPrograms[index];
        final firstImageUrl = program.jadwal.isNotEmpty && program.jadwal.first.latihan.imageUrl != null 
                              ? program.jadwal.first.latihan.imageUrl! 
                              : "";

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LatihanDetailPage(
                  latihan: program.jadwal,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.blueGrey[900],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Opacity(
                    opacity: 0.4,
                    child: Image.network(
                      _buildImageUrl(firstImageUrl),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        program.namaProgram,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        program.fase,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.list_alt, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${program.totalLatihan} Gerakan Latihan",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
