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
    // 1. Set Loading dan Reset status error sebelumnya
    emit(state.copyWith(
        isLoading: true, isKondisiEmpty: false, errorMessage: null));

    try {
      // 2. Cek/Generate Jadwal Terlebih dahulu
      // Di repository, fungsi ini harus melempar Exception("BELUM_ISI_KONDISI") jika 404
      await repository.generateJadwalOtomatis();

      // 3. Ambil data latihan berdasarkan minggu yang terpilih
      final data = await repository.getLatihan(state.selectedWeek);

      emit(state.copyWith(
        latihanList: data,
        isLoading: false,
      ));
    } catch (e) {
      if (e.toString().contains("BELUM_ISI_KONDISI")) {
        // 4. Jika BE balas 404, tandai state ini
        emit(state.copyWith(
          isLoading: false,
          isKondisiEmpty: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onChangeWeek(
    ChangeWeek event,
    Emitter<LatihanState> emit,
  ) async {
    emit(state.copyWith(
      selectedWeek: event.week,
      isLoading: true,
      isKondisiEmpty: false, // Reset saat ganti minggu
    ));

    try {
      final data = await repository.getLatihan(event.week);
      emit(state.copyWith(
        latihanList: data,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
