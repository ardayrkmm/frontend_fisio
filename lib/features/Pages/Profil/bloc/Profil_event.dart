abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? name;
  final String? phone;

  UpdateProfile({this.name, this.phone});
}

class LogoutRequested extends ProfileEvent {}
