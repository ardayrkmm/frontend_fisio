import 'package:equatable/equatable.dart';
import 'package:frontend_fisio/features/Models/UsersModel.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final UserModel user;
  final String token;

  const LoggedIn({required this.user, required this.token});

  @override
  List<Object> get props => [user, token];
}

class LoggedOut extends AuthEvent {}
