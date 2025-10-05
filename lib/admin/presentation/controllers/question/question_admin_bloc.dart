import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/admin/domain/usecase/question/delete_quesetion.dart';

part 'question_admin_event.dart';
part 'question_admin_state.dart';

class QuestionAdminBloc extends Bloc<QuestionAdminEvent, QuestionAdminState> {
  final DeleteQuesetion deleteQuesetion;
  QuestionAdminBloc(this.deleteQuesetion) : super(QuestionAdminState()) {
    on<InitialQuestoinsEvent>(_onInitialQuestions);
    on<AddQuestionEvent>(_onAddQuestion);
    on<RemoveQuestionEvent>(_onRemoveQuestion);
    on<ResetQuestoinsEvent>(_onResetQuestions);
    on<SelectedCorrectOptionEvent>(_onSelectedCorrectOption);
    on<DeleteQuestionEvent>(_onDeleteQuestion);
  }
  void _onResetQuestions(
      ResetQuestoinsEvent event, Emitter<QuestionAdminState> emit) {
    emit(state.copyWith(questions: [
      QuestionFromItem(
        questionController: TextEditingController(),
        optionsControllers: List.generate(
          4,
          (index) => TextEditingController(),
        ),
        correctOptionIndex: 0,
      ),
    ]));
  }

  void _onInitialQuestions(
      InitialQuestoinsEvent event, Emitter<QuestionAdminState> emit) {
    emit(state.copyWith(questions: event.questions));
  }

  void _onAddQuestion(AddQuestionEvent event, Emitter<QuestionAdminState> emit) {
    final updateQuestions = List<QuestionFromItem>.from(state.questions);
    updateQuestions.add(event.question);

    emit(state.copyWith(questions: updateQuestions));
  }

  void _onSelectedCorrectOption(
      SelectedCorrectOptionEvent event, Emitter<QuestionAdminState> emit) {
    final updateQuestions = List<QuestionFromItem>.from(state.questions);
    final question = updateQuestions[event.questionIndex];

    final updateQuestion = QuestionFromItem(
      questionController: question.questionController,
      optionsControllers: question.optionsControllers,
      correctOptionIndex: event.correctOption,
    );

    updateQuestions[event.questionIndex] = updateQuestion;

    emit(state.copyWith(questions: updateQuestions));
  }

  void _onRemoveQuestion(
      RemoveQuestionEvent event, Emitter<QuestionAdminState> emit) {
    final updateQuestions = List<QuestionFromItem>.from(state.questions);
    updateQuestions.removeAt(event.index);

    emit(state.copyWith(questions: updateQuestions));
  }

  void _onDeleteQuestion(
      DeleteQuestionEvent event, Emitter<QuestionAdminState> emit) async {
     await deleteQuesetion(event.id);
  }
}
