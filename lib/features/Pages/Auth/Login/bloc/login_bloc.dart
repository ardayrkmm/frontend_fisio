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
        final loginResponse = await authRepository.login(event.email, event.password);
        
        // Save to AuthBloc via UI event or here if we had reference
        // We pass it to UI via state so UI can dispatch to AuthBloc

        emit(LoginSuccess(
          "Login Berhasil!", 
          user: loginResponse.user, 
          token: loginResponse.token
        ));
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });
  }
}
