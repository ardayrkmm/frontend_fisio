import 'package:frontend_fisio/features/Models/UsersModel.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileLoggedOut extends ProfileState {}
