abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String nama;
  final String phone;
  final String password;

  RegisterSubmitted(
      {required this.email,
      required this.nama,
      required this.phone,
      required this.password});
}
