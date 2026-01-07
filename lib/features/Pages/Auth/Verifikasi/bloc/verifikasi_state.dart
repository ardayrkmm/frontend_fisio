abstract class VerifikasiState {}

class VerifikasiInitial extends VerifikasiState {}

class VerifikasiLoading extends VerifikasiState {}

class VerifikasiSuccess extends VerifikasiState {
  final String message;
  // Simpan ini untuk dikirim ke page OTP

  VerifikasiSuccess({required this.message});
}

class VerifikasiError extends VerifikasiState {
  final String error;
  VerifikasiError(this.error);
}
