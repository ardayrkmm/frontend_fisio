abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final String verificationToken; // Simpan ini untuk dikirim ke page OTP

  RegisterSuccess({required this.message, required this.verificationToken});
}

class RegisterError extends RegisterState {
  final String error;
  RegisterError(this.error);
}
