import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String phone;
  final String avatar;

  const ProfileState({
    required this.name,
    required this.phone,
    required this.avatar,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      name: 'Arda Ym',
      phone: '+6285951545918',
      avatar: 'assets/profile.png',
    );
  }

  @override
  List<Object?> get props => [name, phone, avatar];
}
