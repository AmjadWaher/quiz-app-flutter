part of 'question_user_bloc.dart';

class QuestionUserState extends Equatable {
  final int currentQuestionIndex;
  final int selectedAnswerIndex;
  final List<int?> submittedAnswers;

  const QuestionUserState({
    this.currentQuestionIndex = 0,
    this.selectedAnswerIndex = -1,
    this.submittedAnswers = const [],
  });

  QuestionUserState copyWith({
    int? currentQuestionIndex,
    int? selectedAnswerIndex,
    List<int?>? submittedAnswers,
  }) {
    return QuestionUserState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
      submittedAnswers: submittedAnswers ?? this.submittedAnswers,
    );
  }

  @override
  List<Object> get props =>
      [currentQuestionIndex, selectedAnswerIndex, submittedAnswers];
}
