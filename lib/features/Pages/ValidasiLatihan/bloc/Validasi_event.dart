abstract class QuestionEvent {}

class LoadQuestions extends QuestionEvent {}

class ToggleAnswer extends QuestionEvent {
  final String questionId;
  final String optionId;

  ToggleAnswer({
    required this.questionId,
    required this.optionId,
  });
}

class NextQuestion extends QuestionEvent {}
