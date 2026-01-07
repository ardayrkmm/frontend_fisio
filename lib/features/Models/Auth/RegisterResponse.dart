import 'package:frontend_fisio/features/Models/UsersModel.dart';

class RegisterResponse {
  final String message;
  final String? token;
  final String? verificationToken;
  final UserModel? user;

  RegisterResponse({
    required this.message,
    this.token,
    this.verificationToken,
    this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      token: json['token'],
      verificationToken: json['verification_token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
