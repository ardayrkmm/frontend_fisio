import 'package:equatable/equatable.dart';

class AktifitasState extends Equatable {
  final DateTime selectedDate;
  final List<int> weeklyResult;

  const AktifitasState({
    required this.selectedDate,
    required this.weeklyResult,
  });

  factory AktifitasState.initial() {
    return AktifitasState(
      selectedDate: DateTime(2025, 7, 15),
      weeklyResult: [80, 55, 30, 18, 65, 90, 55],
    );
  }

  AktifitasState copyWith({
    DateTime? selectedDate,
    List<int>? weeklyResult,
  }) {
    return AktifitasState(
      selectedDate: selectedDate ?? this.selectedDate,
      weeklyResult: weeklyResult ?? this.weeklyResult,
    );
  }

  @override
  List<Object?> get props => [selectedDate, weeklyResult];
}
