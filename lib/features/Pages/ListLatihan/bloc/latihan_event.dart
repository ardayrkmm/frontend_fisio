import 'package:equatable/equatable.dart';

abstract class LatihanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadLatihan extends LatihanEvent {}

class ChangeWeek extends LatihanEvent {
  final int week;

  ChangeWeek(this.week);

  @override
  List<Object?> get props => [week];
}
