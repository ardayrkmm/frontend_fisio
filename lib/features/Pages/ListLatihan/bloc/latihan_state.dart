import 'package:equatable/equatable.dart';
import 'package:frontend_fisio/features/Models/LatihanModel.dart';

class LatihanState extends Equatable {
  final List<LatihanModel> latihanList;
  final int selectedWeek;
  final bool isLoading;

  const LatihanState({
    this.latihanList = const [],
    this.selectedWeek = 1,
    this.isLoading = false,
  });

  LatihanState copyWith({
    List<LatihanModel>? latihanList,
    int? selectedWeek,
    bool? isLoading,
  }) {
    return LatihanState(
      latihanList: latihanList ?? this.latihanList,
      selectedWeek: selectedWeek ?? this.selectedWeek,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [latihanList, selectedWeek, isLoading];
}
