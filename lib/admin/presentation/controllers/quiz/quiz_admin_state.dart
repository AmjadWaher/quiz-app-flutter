part of 'quiz_admin_bloc.dart';

class QuizAdminState extends Equatable {
  final List<CategoryAdmin> categories;
  final List<QuizAdmin> quizzes;
  final Status status;
  final String message;
  final int selectedCategoryId;
  final List<QuestionFromItem> questions;

  const QuizAdminState({
    this.categories = const [],
    this.quizzes = const [],
    this.status = Status.loading,
    this.message = '',
    this.selectedCategoryId = -1,
    this.questions = const [],
  });

  QuizAdminState copyWith({
    List<CategoryAdmin>? categories,
    List<QuizAdmin>? quizzes,
    Status? status,
    String? message,
    int? selectedCategoryId,
    List<QuestionFromItem>? questions,
  }) {
    return QuizAdminState(
      categories: categories ?? this.categories,
      quizzes: quizzes ?? this.quizzes,
      status: status ?? this.status,
      message: message ?? this.message,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object> get props => [
        categories,
        quizzes,
        status,
        message,
        selectedCategoryId,
        questions,
      ];
}
