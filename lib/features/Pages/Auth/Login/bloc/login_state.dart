abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  // Kamu juga bisa menyertakan object UserData di sini jika butuh
  LoginSuccess(this.message);
}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}
