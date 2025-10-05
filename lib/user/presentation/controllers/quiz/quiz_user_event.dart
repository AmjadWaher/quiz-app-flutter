part of 'quiz_user_bloc.dart';

sealed class QuizUserEvent extends Equatable {
  const QuizUserEvent();

  @override
  List<Object> get props => [];
}

class FetchAllQuizzesEvent extends QuizUserEvent {}

class FetchQuizzesByCategoryIdEvent extends QuizUserEvent {
  final int id;

  const FetchQuizzesByCategoryIdEvent(this.id,);
}

class SearchQuizEvent extends QuizUserEvent {
  final String title;

  const SearchQuizEvent(this.title);
}
