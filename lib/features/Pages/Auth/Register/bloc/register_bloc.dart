import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Auth/Register/bloc/register_event.dart';
import 'package:frontend_fisio/features/Pages/Auth/Register/bloc/register_state.dart';
import 'package:frontend_fisio/features/Repository/AuthRepository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Authrepository authRepository;

  RegisterBloc(this.authRepository) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        final response = await authRepository.register(
          email: event.email,
          nama: event.nama,
          phone: event.phone,
          password: event.password,
        );

        emit(RegisterSuccess(
          message: response.message,
          verificationToken: response.verificationToken ?? "",
        ));
      } catch (e) {
        emit(RegisterError(e.toString()));
      }
    });
  }
}
