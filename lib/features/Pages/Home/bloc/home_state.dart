import 'package:equatable/equatable.dart';
import 'package:frontend_fisio/features/Models/HomeModels.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String namaUser;
  final String greeting;
  final bool isKondisiTerisi;
  final HomeHistoryData? lastWorkout;
  final JadwalFaseData? activeProgram;

  HomeLoaded({
    required this.namaUser,
    required this.greeting,
    required this.isKondisiTerisi,
    this.lastWorkout,
    this.activeProgram,
  });

  @override
  List<Object?> get props => [
        namaUser,
        greeting,
        isKondisiTerisi,
        lastWorkout,
        activeProgram,
      ];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
