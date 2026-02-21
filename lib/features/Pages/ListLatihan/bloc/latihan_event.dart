import 'package:equatable/equatable.dart';

abstract class LatihanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadLatihan extends LatihanEvent {}

class ChangeFase extends LatihanEvent {
  final String fase;
  ChangeFase(this.fase);

  @override
  List<Object?> get props => [fase];
}
