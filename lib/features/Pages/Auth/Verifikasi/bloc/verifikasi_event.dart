abstract class VerifikasiEvent {}

class VerifikasiSubmitted extends VerifikasiEvent {
  final String token;
  final String otp;

  VerifikasiSubmitted({
    required this.token,
    required this.otp,
  });
}
