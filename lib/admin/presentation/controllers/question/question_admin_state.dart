part of 'question_admin_bloc.dart';

class QuestionAdminState extends Equatable {
  final List<QuestionFromItem> questions;
  const QuestionAdminState({
    this.questions = const [],
  });

  QuestionAdminState copyWith({
    List<QuestionFromItem>? questions,
  }) {
    return QuestionAdminState(
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object> get props => [questions];
}

class QuestionFromItem {
  final TextEditingController questionController;
  final List<TextEditingController> optionsControllers;
  int correctOptionIndex;

  QuestionFromItem({
    required this.questionController,
    required this.optionsControllers,
    required this.correctOptionIndex,
  });
}
