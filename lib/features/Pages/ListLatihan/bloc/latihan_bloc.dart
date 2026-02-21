import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Repository/LatihanRepository.dart';
import 'latihan_event.dart';
import 'latihan_state.dart';

class LatihanBloc extends Bloc<LatihanEvent, LatihanState> {
  final LatihanRepository repository;

  LatihanBloc(this.repository) : super(const LatihanState()) {
    on<LoadLatihan>(_onLoadLatihan);
    on<ChangeFase>(_onChangeFase);
  }

  Future<void> _onLoadLatihan(
    LoadLatihan event,
    Emitter<LatihanState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isKondisiEmpty: false, errorMessage: null));

    try {
      // 1. GENERATE JADWAL (Idempotent)
      final generateResult = await repository.generateJadwalOtomatis();
      final statusCode = generateResult['statusCode'] as int;
      final message = generateResult['message'] as String;

      if (statusCode == 404 && message.toLowerCase().contains("isi form kondisi terlebih dahulu")) {
         // Belum isi kondisi sama sekali
         emit(state.copyWith(isLoading: false, isKondisiEmpty: true));
         return; // Berhenti The flow stops here, no fetch fase.
      } else if (statusCode == 400 || statusCode == 201 || statusCode == 200) {
         // Lanjut fetch semua
      } else {
         // Unexpected status
         emit(state.copyWith(isLoading: false, errorMessage: message.isNotEmpty ? message : "Gagal memproses jadwal"));
         return;
      }

      // 2. FETCH SEMUA JADWAL
      final listProgram = await repository.getSemuaJadwal();

      if (listProgram.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          allPrograms: [],
        ));
        return;
      }

      // Default the selected tab to the active program's phase (assuming latest/first in list)
      final initialFase = listProgram.first.fase.isNotEmpty ? listProgram.first.fase : 'F1';

      emit(state.copyWith(
        allPrograms: listProgram,
        selectedFase: initialFase,
        isLoading: false,
      ));

    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onChangeFase(ChangeFase event, Emitter<LatihanState> emit) {
    emit(state.copyWith(selectedFase: event.fase));
  }
}
