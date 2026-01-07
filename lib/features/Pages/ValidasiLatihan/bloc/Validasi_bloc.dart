import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_event.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_state.dart';
import 'package:frontend_fisio/features/Repository/QuestionRepository.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final QuestionRepository repository;

  QuestionBloc(this.repository) : super(QuestionInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<ToggleAnswer>(_onToggleAnswer);
    on<NextQuestion>(_onNextQuestion);
  }

  // 🔹 LOAD DARI API
  Future<void> _onLoadQuestions(
    LoadQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    emit(QuestionLoading());
    try {
      final questions = await repository.getQuestions();

      emit(
        QuestionLoaded(
          currentIndex: 0,
          questions: questions,
          answers: {},
        ),
      );
    } catch (e) {
      emit(QuestionError(e.toString()));
    }
  }

  // 🔹 PILIH JAWABAN
  void _onToggleAnswer(
    ToggleAnswer event,
    Emitter<QuestionState> emit,
  ) {
    final state = this.state as QuestionLoaded;

    final currentAnswers =
        List<String>.from(state.answers[event.questionId] ?? []);

    final isMulti = state.currentQuestion.multiSelect;

    if (isMulti) {
      currentAnswers.contains(event.optionId)
          ? currentAnswers.remove(event.optionId)
          : currentAnswers.add(event.optionId);
    } else {
      currentAnswers
        ..clear()
        ..add(event.optionId);
    }

    emit(
      QuestionLoaded(
        currentIndex: state.currentIndex,
        questions: state.questions,
        answers: {
          ...state.answers,
          event.questionId: currentAnswers,
        },
      ),
    );
  }

  // 🔹 NEXT / FINISH
  void _onNextQuestion(
    NextQuestion event,
    Emitter<QuestionState> emit,
  ) async {
    final state = this.state as QuestionLoaded;

    if (state.currentIndex + 1 < state.questions.length) {
      emit(
        QuestionLoaded(
          currentIndex: state.currentIndex + 1,
          questions: state.questions,
          answers: state.answers,
        ),
      );
    } else {
      // ⬅️ PERTANYAAN HABIS (EMPTY)
      await repository.submitKondisiUser(state.answers);

      emit(QuestionFinished(state.answers));
    }
  }
}
