abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String phone;
  final String avatar;

  ProfileLoaded({
    required this.name,
    required this.phone,
    required this.avatar,
  });
}

class ProfileLoggedOut extends ProfileState {}
