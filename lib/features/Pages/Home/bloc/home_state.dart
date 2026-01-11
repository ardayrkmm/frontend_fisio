abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String namaUser;
  final String greeting;

  HomeLoaded({
    required this.namaUser,
    required this.greeting,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
