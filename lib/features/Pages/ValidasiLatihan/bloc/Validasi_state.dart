import 'package:frontend_fisio/features/Models/QuestionModel.dart';

abstract class QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final int currentIndex;
  final List<QuestionModel> questions;
  final Map<String, List<String>> answers;

  QuestionLoaded({
    required this.currentIndex,
    required this.questions,
    required this.answers,
  });

  QuestionModel get currentQuestion => questions[currentIndex];
}

class QuestionFinished extends QuestionState {
  final Map<String, List<String>> answers;

  QuestionFinished(this.answers);
}

class QuestionError extends QuestionState {
  final String message;
  QuestionError(this.message);
}
