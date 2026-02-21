import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart'; // Changed import
import 'package:frontend_fisio/core/Widget/Buttons.dart';
import 'package:frontend_fisio/features/Pages/Latihan/presentation/LatihanPages.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_bloc.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_event.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_state.dart';

class LatihanDetailPage extends StatelessWidget {
  final List<JadwalDetailModel> latihan; // Changed to List<JadwalDetailModel>
  const LatihanDetailPage({
    super.key,
    required this.latihan,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MLatihanBloc()..add(InitializeLatihanEvent(latihan)), // Pass directly
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                // Header Video Image
                Stack(
                  children: [
                    // Bagian Header Video di LatihanDetailPage
                    BlocBuilder<MLatihanBloc, MLatihanState>(
                      buildWhen: (previous, current) =>
                          current is MLatihanLoading ||
                          current is MLatihanLoaded ||
                          current is MLatihanError,
                      builder: (context, state) {
                        // 1. Saat Video Sedang Loading/Berpindah
                        if (state is MLatihanLoading) {
                          return Container(
                            height: 250,
                            width: double.infinity,
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          );
                        }

                        // 2. Saat Video Siap Diputar
                        if (state is MLatihanLoaded &&
                            state.flickManager != null) {
                          return SizedBox(
                            height: 250, // Sesuaikan tinggi video
                            width: double.infinity,
                            child: FlickVideoPlayer(
                              // Key ini SANGAT PENTING agar video refresh saat ganti list
                              key: ValueKey(state.currentUrl),
                              flickManager: state.flickManager!,
                              // Pengaturan agar video pas di layar
                              flickVideoWithControls:
                                  const FlickVideoWithControls(
                                controls:
                                    FlickPortraitControls(), // Kontrol standar (play, volume, dll)
                                videoFit: BoxFit.cover,
                              ),
                            ),
                          );
                        }

                        // 3. Jika Terjadi Error
                        if (state is MLatihanError) {
                          return Container(
                            height: 250,
                            color: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error,
                                      color: Colors.white, size: 48),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      state.message,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Tampilan Default (Awal)
                        return Container(
                          height: 250,
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.play_circle_fill,
                                color: Colors.white, size: 64),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Latihan Pertama',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Di tonton dahulu, untuk gerakannya, baru melakukan latihan',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Chip(
                          avatar: const Icon(Icons.access_time, size: 18),
                          label: const Text('30 Menit'),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Gerakan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: BlocBuilder<MLatihanBloc, MLatihanState>(
                            // Point Penting: Jangan bangun ulang (rebuild) list jika state adalah Loading.
                            // List hanya diupdate jika state benar-benar Loaded atau Error.
                            buildWhen: (previous, current) =>
                                current is MLatihanLoaded ||
                                current is MLatihanError,
                            builder: (context, state) {
                                if (state is MLatihanLoaded) {
                                  // 1. Grouping Logic: Filter unik berdasarkan nama latihan
                                  final uniqueGerakan = <JadwalDetailModel>[];
                                  final seenNames = <String>{};

                                  for (var item in state.gerakan) {
                                    if (!seenNames.contains(item.latihan.namaLatihan)) {
                                      uniqueGerakan.add(item);
                                      seenNames.add(item.latihan.namaLatihan);
                                    }
                                  }

                                  return ListView.builder(
                                    itemCount: uniqueGerakan.length,
                                    itemBuilder: (context, index) {
                                      final item = uniqueGerakan[index];
                                      final currentVideoUrl = item.latihan.videoUrl;
                                      
                                      // Check if this item (or any item with same name) is currently playing
                                      // Simplification: just check current URL against this item's URL
                                      // Assumption: Exercises with same name share same video URL
                                      final bool isPlaying =
                                          state.currentUrl == currentVideoUrl;

                                      return GestureDetector(
                                        onTap: () {
                                          print(
                                              '🎬 [LIST] Clicked: ${item.latihan.namaLatihan}');
                                          context.read<MLatihanBloc>().add(
                                              SelectVideoEvent(currentVideoUrl ?? ""));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 0.0,
                                          ),
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: isPlaying
                                                ? const Color(0xFFE3F2FD)
                                                : Colors.transparent,
                                            border: Border(
                                              left: BorderSide(
                                                color: isPlaying
                                                    ? const Color(0xFF2196F3)
                                                    : Colors.transparent,
                                                width: 4.0,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              if (isPlaying)
                                                const Icon(
                                                  Icons.play_circle_filled,
                                                  color: Color(0xFF2196F3),
                                                  size: 24,
                                                ),
                                              if (!isPlaying)
                                                Icon(
                                                  Icons.circle_outlined,
                                                  color: Colors.grey[400],
                                                  size: 24,
                                                ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.latihan.namaLatihan, 
                                                      style: TextStyle(
                                                        fontWeight: isPlaying
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        color: isPlaying
                                                            ? const Color(
                                                                0xFF2196F3)
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${item.latihan.target.repetisi} repetisi × ${item.latihan.target.set} set', 
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Button
            Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: BlocBuilder<MLatihanBloc, MLatihanState>(
                  builder: (context, state) {
                    return Buttons(
                      nama: "Mulai Latihan",
                      lebar: double.infinity,
                      tinggi: 60,
                      onPressed: () {
                        // ✅ Pass selected latihan data to camera page
                        if (state is MLatihanLoaded) {
                          // Find the selected video from the list
                          final selectedVideo = state.gerakan.firstWhere(
                            (v) => v.latihan.videoUrl == state.currentUrl, // Updated
                            orElse: () => state.gerakan.first,
                          );
                          
                          // Find index
                          final index = state.gerakan.indexOf(selectedVideo);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExerciseCameraPage(
                                latihanData: selectedVideo, // Passing JadwalDetailModel
                                allExercises: state.gerakan,
                                currentIndex: index,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
