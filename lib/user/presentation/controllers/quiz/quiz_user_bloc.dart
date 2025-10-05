import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/core/utils/status_enum.dart';

import 'package:quiz_app/user/domain/entities/quiz_user.dart';
import 'package:quiz_app/user/domain/usecase/quiz/quiz_usecase_user.dart';

part 'quiz_user_event.dart';
part 'quiz_user_state.dart';

class QuizUserBloc extends Bloc<QuizUserEvent, QuizUserState> {
  final FetchQuizzesByCategoryId fetchQuizzesByCategoryId;

  List<QuizUser> _quizzes = [];
  QuizUserBloc(
    this.fetchQuizzesByCategoryId,
  ) : super(QuizUserState()) {
    on<FetchQuizzesByCategoryIdEvent>(_onFetchQuizzesByCategoryId);
  }

  void _onFetchQuizzesByCategoryId(
      FetchQuizzesByCategoryIdEvent event, Emitter<QuizUserState> emit) async {
    final quizzesResult = await fetchQuizzesByCategoryId(event.id);

    quizzesResult.fold(
        (failure) => emit(
            state.copyWith(message: failure.message, status: Status.error)),
        (success) {
      _quizzes = success;
      emit(state.copyWith(quizzes: _quizzes, status: Status.loaded));
    });
  }
}
