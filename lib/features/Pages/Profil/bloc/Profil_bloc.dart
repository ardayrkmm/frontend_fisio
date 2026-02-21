import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_event.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_state.dart';
import 'package:frontend_fisio/features/Repository/AuthRepository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Authrepository authRepository;

  ProfileBloc(this.authRepository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await authRepository.getProfile();
        emit(ProfileLoaded(user: user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await authRepository.updateProfile(
          nama: event.name,
          noTelepon: event.phone,
        );
        emit(ProfileLoaded(user: user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(ProfileLoggedOut());
    });
  }
}
