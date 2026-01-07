import 'package:equatable/equatable.dart';

abstract class AktifitasEvent extends Equatable {
  const AktifitasEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivity extends AktifitasEvent {}

class SelectDate extends AktifitasEvent {
  final DateTime date;
  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}
