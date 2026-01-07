import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Repository/AuthRepository.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Authrepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        // Memanggil fungsi login di repository yang sudah kita buat
        await authRepository.login(event.email, event.password);

        emit(LoginSuccess("Login Berhasil!"));
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });
  }
}
