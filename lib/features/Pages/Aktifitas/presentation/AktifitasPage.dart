import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/core/Widget/AktifitasPage/CardAktifitas.dart';
import 'package:frontend_fisio/features/Pages/Aktifitas/bloc/aktifitas_bloc.dart';
import 'package:frontend_fisio/features/Pages/Aktifitas/bloc/aktifitas_event.dart';
import 'package:frontend_fisio/features/Pages/Aktifitas/bloc/aktifitas_state.dart';

class Aktifitaspage extends StatelessWidget {
  const Aktifitaspage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget Header() {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<ActivityBloc, AktifitasState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aktifitas Kamu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text('Juli, 2025',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final day = DateTime(2025, 7, 12 + i);
                    final isSelected = day.day == state.selectedDate.day;
                    return GestureDetector(
                      onTap: () {
                        context.read<ActivityBloc>().add(SelectDate(day));
                      },
                      child: Column(
                        children: [
                          Text(
                            [
                              'Sen',
                              'Sel',
                              'Rab',
                              'Kam',
                              'Jum',
                              'Sab',
                              'Min'
                            ][i],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          CircleAvatar(
                            radius: isSelected ? 18 : 14,
                            backgroundColor: isSelected
                                ? unguTerang
                                : unguTerang.withOpacity(0.5),
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      );
    }

    Widget body() {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: BlocBuilder<ActivityBloc, AktifitasState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hasil Mingguan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: state.weeklyResult.map((value) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: value.toDouble() * 1.2,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Latihan kamu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ExerciseCard(),
              ],
            );
          },
        ),
      );
    }

    return BlocProvider(
      create: (context) => ActivityBloc(),
      child: Scaffold(
        backgroundColor: unguTerang,
        body: Container(
          child: ListView(
            children: [
              Header(),
              const SizedBox(height: 16),
              Expanded(child: body()),
            ],
          ),
        ),
      ),
    );
  }
}
