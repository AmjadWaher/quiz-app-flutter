part of 'question_admin_bloc.dart';

sealed class QuestionAdminEvent extends Equatable {
  const QuestionAdminEvent();

  @override
  List<Object> get props => [];
}

class ResetQuestoinsEvent extends QuestionAdminEvent {}

class InitialQuestoinsEvent extends QuestionAdminEvent {
  final List<QuestionFromItem> questions;

  const InitialQuestoinsEvent(this.questions);
}

class AddQuestionEvent extends QuestionAdminEvent {
  final QuestionFromItem question;

  const AddQuestionEvent(this.question);
}

class SelectedCorrectOptionEvent extends QuestionAdminEvent {
  final int questionIndex;
  final int correctOption;

  const SelectedCorrectOptionEvent(this.questionIndex, this.correctOption);
}

class RemoveQuestionEvent extends QuestionAdminEvent {
  final int index;

  const RemoveQuestionEvent(this.index);
}

class DeleteQuestionEvent extends QuestionAdminEvent{
  final int id;

  const DeleteQuestionEvent(this.id);
}