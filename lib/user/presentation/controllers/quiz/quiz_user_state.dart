part of 'quiz_user_bloc.dart';

class QuizUserState extends Equatable {
  final List<QuizUser> quizzes;
  final Status status;
  final String message;

  const QuizUserState({
    this.quizzes = const [],
    this.status = Status.loading,
    this.message = '',
  });

  QuizUserState copyWith({
    List<QuizUser>? quizzes,
    Status? status,
    String? message,
  }) {
    return QuizUserState(
      quizzes: quizzes ?? this.quizzes,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        quizzes,
        status,
        message,
      ];
}
