import 'package:equatable/equatable.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart';

class LatihanState extends Equatable {
  final List<JadwalFaseData> allPrograms; 
  final String selectedFase;
  final bool isLoading;
  final bool isKondisiEmpty;
  final String? errorMessage;

  const LatihanState({
    this.allPrograms = const [],
    this.selectedFase = 'F1',
    this.isLoading = false,
    this.isKondisiEmpty = false,
    this.errorMessage,
  });

  LatihanState copyWith({
    List<JadwalFaseData>? allPrograms,
    String? selectedFase,
    bool? isLoading,
    bool? isKondisiEmpty,
    String? errorMessage,
  }) {
    return LatihanState(
      allPrograms: allPrograms ?? this.allPrograms,
      selectedFase: selectedFase ?? this.selectedFase,
      isLoading: isLoading ?? this.isLoading,
      isKondisiEmpty: isKondisiEmpty ?? this.isKondisiEmpty,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        allPrograms,
        selectedFase,
        isLoading,
        isKondisiEmpty,
        errorMessage
      ];
}
