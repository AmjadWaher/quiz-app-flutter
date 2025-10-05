// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'question_user_bloc.dart';

sealed class QuestionUserEvent extends Equatable {
  const QuestionUserEvent();

  @override
  List<Object> get props => [];
}

class InitialQuestionState extends QuestionUserEvent {}

class NextQuestionRequested extends QuestionUserEvent {
  final int answerIndex;
  const NextQuestionRequested(this.answerIndex);

  @override
  List<Object> get props => [answerIndex];
}

class SelectedAnswer extends QuestionUserEvent {
  final int answerIndex;

  const SelectedAnswer(this.answerIndex);

  @override
  List<Object> get props => [answerIndex];
}

class QuizCompleted extends QuestionUserEvent {}
