import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend_fisio/features/Pages/Auth/Verifikasi/bloc/verifikasi_event.dart';
import 'package:frontend_fisio/features/Pages/Auth/Verifikasi/bloc/verifikasi_state.dart';
import 'package:frontend_fisio/features/Repository/AuthRepository.dart';

class VerifikasiBloc extends Bloc<VerifikasiEvent, VerifikasiState> {
  final Authrepository authRepository;

  VerifikasiBloc(this.authRepository) : super(VerifikasiInitial()) {
    on<VerifikasiSubmitted>((event, emit) async {
      emit(VerifikasiLoading());
      try {
        final response = await authRepository.Verifikasi(
          token: event.token,
          otp: event.otp,
        );

        emit(VerifikasiSuccess(
          message: response.message,
        ));
      } catch (e) {
        emit(VerifikasiError(e.toString()));
      }
    });
  }
}
