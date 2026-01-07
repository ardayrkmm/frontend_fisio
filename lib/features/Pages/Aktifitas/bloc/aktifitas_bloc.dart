import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Aktifitas/bloc/aktifitas_event.dart';
import 'package:frontend_fisio/features/Pages/Aktifitas/bloc/aktifitas_state.dart';

class ActivityBloc extends Bloc<AktifitasEvent, AktifitasState> {
  ActivityBloc() : super(AktifitasState.initial()) {
    on<LoadActivity>((event, emit) {
      emit(state);
    });

    on<SelectDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.date));
    });
  }
}
