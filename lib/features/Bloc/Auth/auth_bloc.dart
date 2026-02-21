import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Bloc/Auth/auth_event.dart';
import 'package:frontend_fisio/features/Bloc/Auth/auth_state.dart';
import 'package:frontend_fisio/features/Repository/AuthRepository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Authrepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final bool hasToken = await authRepository.hasToken();
      
      if (hasToken) {
        final user = await authRepository.getUser();
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          // If token exists but no user data, try fetching profile or just logout
          // For now, let's try to fetch profile if we want to be robust, 
          // but based on request, we rely on persisted data.
          // Fallback:
          try {
             final fetchedUser = await authRepository.getProfile();
             emit(Authenticated(user: fetchedUser));
          } catch (_) {
             emit(Unauthenticated());
          }
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.persistToken(event.token);
    await authRepository.persistUser(event.user);
    emit(Authenticated(user: event.user));
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.deleteToken();
    await authRepository.deleteUser();
    emit(Unauthenticated());
  }
}
