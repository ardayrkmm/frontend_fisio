import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Utils/Waktu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_fisio/features/Repository/HomeRepository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadHomeUser>(_onLoadHomeUser);
  }

  Future<void> _onLoadHomeUser(
    LoadHomeUser event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());

      final prefs = await SharedPreferences.getInstance();
      final namaUser = prefs.getString('nama_user') ?? 'Pengguna';
      final greeting = GreetingHelper.getGreeting();

      // 1. Cek Kondisi
      final genResult = await repository.generateJadwalOtomatis();
      final statusCode = genResult['statusCode'] as int;
      final message = genResult['message'] as String;

      bool isKondisiTerisi = true;
      if (statusCode == 404 && message.toLowerCase().contains("isi form kondisi terlebih dahulu")) {
        isKondisiTerisi = false;
      }

      // 2. Fetch Active Program (if kondisi is filled)
      var activeProgram;
      if (isKondisiTerisi) {
         activeProgram = await repository.getActiveProgram();
      }

      // 3. Fetch Last Workout
      final lastWorkout = await repository.getLastWorkout();

      emit(
        HomeLoaded(
          namaUser: namaUser,
          greeting: greeting,
          isKondisiTerisi: isKondisiTerisi,
          activeProgram: activeProgram,
          lastWorkout: lastWorkout,
        ),
      );
    } catch (e) {
      emit(HomeError('Gagal memuat data: ${e.toString()}'));
    }
  }
}
