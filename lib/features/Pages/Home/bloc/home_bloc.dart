import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Utils/Waktu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeUser>(_onLoadHomeUser);
  }

  Future<void> _onLoadHomeUser(
    LoadHomeUser event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());

      final prefs = await SharedPreferences.getInstance();

      // Contoh: ambil nama user (sementara)
      // Nantinya bisa dari API /me
      final namaUser = prefs.getString('nama_user') ?? 'User';

      final greeting = GreetingHelper.getGreeting();

      emit(
        HomeLoaded(
          namaUser: namaUser,
          greeting: greeting,
        ),
      );
    } catch (e) {
      emit(HomeError('Gagal memuat data'));
    }
  }
}
