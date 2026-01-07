import 'package:frontend_fisio/features/Models/UsersModel.dart';

class LoginResponse {
  final String message;
  final String token;
  final UserModel user;

  LoginResponse(
      {required this.message, required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      user: UserModel.fromJson(json['user']), // Parsing nested object
    );
  }
}
