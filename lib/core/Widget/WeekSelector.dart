import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/ListLatihan/bloc/latihan_bloc.dart';
import 'package:frontend_fisio/features/Pages/ListLatihan/bloc/latihan_event.dart';
import 'package:frontend_fisio/features/Pages/ListLatihan/bloc/latihan_state.dart';
import 'package:frontend_fisio/features/Repository/LatihanRepository.dart';

class WeekSelector extends StatelessWidget {
  const WeekSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<LatihanRepository>();

    return FutureBuilder(
      future: repo.getProgram(), // API yg kembalikan program
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final program = snapshot.data as List; // program dari backend

        return Row(
          children: program.map<Widget>((p) {
            final int week = (p.minggu as num).toInt();

            return GestureDetector(
              onTap: () {
                context.read<LatihanBloc>().add(ChangeWeek(week));
              },
              child: BlocBuilder<LatihanBloc, LatihanState>(
                builder: (context, state) {
                  final isSelected = state.selectedWeek == week;

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text('Week'),
                        Text(
                          '$week',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
