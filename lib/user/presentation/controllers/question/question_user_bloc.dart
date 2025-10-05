import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'question_user_event.dart';
part 'question_user_state.dart';

class QuestionUserBloc extends Bloc<QuestionUserEvent, QuestionUserState> {
  QuestionUserBloc() : super(QuestionUserState()) {
    on<InitialQuestionState>(_onInitialQuestionState);
    on<NextQuestionRequested>(_onNextQuestionRequested);
    on<SelectedAnswer>(_onSelectedAnswer);
  }

  void _onInitialQuestionState(
      InitialQuestionState event, Emitter<QuestionUserState> emit) {
    emit(state.copyWith(
      selectedAnswerIndex: -1,
      currentQuestionIndex: 0,
      submittedAnswers: const [],
    ));
  }

  void _onNextQuestionRequested(
      NextQuestionRequested event, Emitter<QuestionUserState> emit) {
    final updateAnswers = List<int?>.of(state.submittedAnswers);
    updateAnswers.add(event.answerIndex);
    emit(state.copyWith(
      selectedAnswerIndex: -1,
      submittedAnswers: updateAnswers,
      currentQuestionIndex: state.currentQuestionIndex + 1,
    ));
    log(state.submittedAnswers.length.toString());
  }

  void _onSelectedAnswer(
      SelectedAnswer event, Emitter<QuestionUserState> emit) {
    emit(state.copyWith(selectedAnswerIndex: event.answerIndex));
  }
}
