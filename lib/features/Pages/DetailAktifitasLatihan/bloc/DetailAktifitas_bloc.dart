// bloc/workout_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Models/WorkoutModel.dart';
import 'package:frontend_fisio/features/Models/gerakan.dart';
import 'package:frontend_fisio/features/Pages/DetailAktifitasLatihan/bloc/DetailAktifitas_event.dart';
import 'package:frontend_fisio/features/Pages/DetailAktifitasLatihan/bloc/DetailAktifitas_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc() : super(WorkoutInitial()) {
    on<LoadWorkoutEvent>((event, emit) {
      emit(
        WorkoutLoaded(
          WorkoutModel(
            title: 'Latihan Pertama',
            totalMinutes: 30,
            date: '13 Jul 2025',
            exercises: [
              GerakanModel(
                title: 'Gerakan 1',
                image: 'assets/images/gerakan1.png',
                duration: '02.30 Minutes',
                repetisi: 12,
                set: 3,
              ),
              GerakanModel(
                title: 'Gerakan 2',
                image: 'assets/images/gerakan2.png',
                duration: '02.00 Minutes',
                repetisi: 12,
                set: 3,
              ),
              GerakanModel(
                title: 'Gerakan 3',
                image: 'assets/images/gerakan3.png',
                duration: '03.20 Minutes',
                repetisi: 12,
                set: 3,
              ),
            ],
          ),
        ),
      );
    });
  }
}
