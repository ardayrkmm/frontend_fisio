// pages/workout_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/DetailAktifitasLatihan/bloc/DetailAktifitas_bloc.dart';
import 'package:frontend_fisio/features/Pages/DetailAktifitasLatihan/bloc/DetailAktifitas_event.dart';
import 'package:frontend_fisio/features/Pages/DetailAktifitasLatihan/bloc/DetailAktifitas_state.dart';

class AktifitasDetailPage extends StatelessWidget {
  const AktifitasDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutBloc()..add(LoadWorkoutEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail Latihan')),
        body: BlocBuilder<WorkoutBloc, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutLoaded) {
              final workout = state.workout;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(label: Text('${workout.totalMinutes} Menit')),
                      Text(workout.date),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...workout.exercises.map(
                    (e) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Image.asset(
                          e.image,
                          width: 48,
                          fit: BoxFit.cover,
                        ),
                        title: Text(e.title),
                        subtitle: Text(e.duration),
                        trailing: Text(
                          '${e.repetisi} Repetisi\n${e.set} Set',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
