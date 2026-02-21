import 'package:equatable/equatable.dart';
import 'package:frontend_fisio/features/Models/UsersModel.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}
