part of 'quiz_admin_bloc.dart';

sealed class QuizAdminEvent extends Equatable {
  const QuizAdminEvent();

  @override
  List<Object> get props => [];
}

class GetAllQuizzesEvent extends QuizAdminEvent {
  final String userId;

  const GetAllQuizzesEvent(this.userId);
}

class GetQuizzesByCategoryIdEvent extends QuizAdminEvent {
  final int id;
  final List<CategoryAdmin>? categories;

  const GetQuizzesByCategoryIdEvent(this.id, {this.categories});
}

class AddQuizEvent extends QuizAdminEvent {
  final QuizParameters quiz;

  const AddQuizEvent(this.quiz);
}

class DeleteQuizEvent extends QuizAdminEvent {
  final DeleteQuizParameters quiz;

  const DeleteQuizEvent(this.quiz);
}

class UpdateQuizEvent extends QuizAdminEvent {
  final QuizParameters quiz;

  const UpdateQuizEvent(this.quiz);
}

class SearchQuizEvent extends QuizAdminEvent {
  final String title;

  const SearchQuizEvent(this.title);
}
