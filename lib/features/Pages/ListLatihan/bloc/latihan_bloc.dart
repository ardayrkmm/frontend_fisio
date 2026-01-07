import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Repository/LatihanRepository.dart';
import 'latihan_event.dart';
import 'latihan_state.dart';

class LatihanBloc extends Bloc<LatihanEvent, LatihanState> {
  final LatihanRepository repository;

  LatihanBloc(this.repository) : super(const LatihanState()) {
    on<LoadLatihan>(_onLoadLatihan);
    on<ChangeWeek>(_onChangeWeek);
  }

  Future<void> _onLoadLatihan(
    LoadLatihan event,
    Emitter<LatihanState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final data = await repository.getLatihan(state.selectedWeek);

    emit(state.copyWith(
      latihanList: data,
      isLoading: false,
    ));
  }

  Future<void> _onChangeWeek(
    ChangeWeek event,
    Emitter<LatihanState> emit,
  ) async {
    emit(state.copyWith(
      selectedWeek: event.week,
      isLoading: true,
    ));

    final data = await repository.getLatihan(event.week);

    emit(state.copyWith(
      latihanList: data,
      isLoading: false,
    ));
  }
}
