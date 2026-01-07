import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Latihan/bloc/Latihan_event.dart';
import 'package:frontend_fisio/features/Pages/Latihan/bloc/Latihan_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc() : super(ExerciseState.initial()) {
    on<PauseExercise>((event, emit) {
      emit(state.copyWith(isPaused: !state.isPaused));
    });

    on<NextRepetition>((event, emit) {
      if (state.repetition < state.totalRepetition) {
        emit(state.copyWith(repetition: state.repetition + 1));
      }
    });
  }
}
