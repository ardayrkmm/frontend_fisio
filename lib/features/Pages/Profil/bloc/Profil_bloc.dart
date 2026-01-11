import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_event.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_state.dart';
import 'package:frontend_fisio/features/Repository/AuthRepository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Authrepository authRepository;

  ProfileBloc(this.authRepository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) {
      emit(ProfileLoaded(
        name: "User",
        phone: "08xxxxxxxx",
        avatar: "assets/avatar.png",
      ));
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(ProfileLoggedOut());
    });
  }
}
