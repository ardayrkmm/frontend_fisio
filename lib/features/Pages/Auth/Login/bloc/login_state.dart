import 'package:frontend_fisio/features/Models/UsersModel.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  final UserModel? user;
  final String? token;
  
  LoginSuccess(this.message, {this.user, this.token});
}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}
