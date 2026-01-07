import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_event.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<LoadProfile>((event, emit) {
      emit(state);
    });
  }
}
