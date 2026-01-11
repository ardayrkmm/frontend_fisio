import 'package:equatable/equatable.dart';
import 'package:frontend_fisio/features/Models/LatihanModel.dart';

class LatihanState extends Equatable {
  final List<LatihanModel> latihanList;
  final bool isLoading;
  final int selectedWeek;
  final bool isKondisiEmpty; // Untuk mentrigger JDialog
  final String? errorMessage;

  const LatihanState({
    this.latihanList = const [],
    this.isLoading = false,
    this.selectedWeek = 1,
    this.isKondisiEmpty = false,
    this.errorMessage,
  });

  LatihanState copyWith({
    List<LatihanModel>? latihanList,
    bool? isLoading,
    int? selectedWeek,
    bool? isKondisiEmpty,
    String? errorMessage,
  }) {
    return LatihanState(
      latihanList: latihanList ?? this.latihanList,
      isLoading: isLoading ?? this.isLoading,
      selectedWeek: selectedWeek ?? this.selectedWeek,
      isKondisiEmpty: isKondisiEmpty ?? this.isKondisiEmpty,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [latihanList, isLoading, selectedWeek, isKondisiEmpty, errorMessage];
}
