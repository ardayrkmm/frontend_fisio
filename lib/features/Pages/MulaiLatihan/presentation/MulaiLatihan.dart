import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Widget/GerakanTile.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_bloc.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_event.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_state.dart';

class LatihanDetailPage extends StatelessWidget {
  const LatihanDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MLatihanBloc()..add(LoadMulLatihan()),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                // Header Video Image
                Stack(
                  children: [
                    Image.asset(
                      'assets/header_latihan.png',
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const Positioned.fill(
                      child: Center(
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.play_arrow, size: 36),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
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
                            builder: (context, state) {
                              if (state is MLatihanLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is MLatihanLoaded) {
                                return ListView.builder(
                                  itemCount: state.gerakan.length,
                                  itemBuilder: (context, index) {
                                    return GerakanTile(
                                      gerakan: state.gerakan[index],
                                    );
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Mulai',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
