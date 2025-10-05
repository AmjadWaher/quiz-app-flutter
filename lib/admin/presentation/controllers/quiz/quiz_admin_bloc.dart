import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/core/service/service_locator.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/admin/domain/entities/category_admin.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/usecase/category/get_all_categories.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/add_quiz.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/delete_quiz.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/get_all_quizzes.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/get_all_quizzes_by_category_id.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/search_quiz.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/update_quiz.dart';
import 'package:quiz_app/admin/presentation/controllers/question/question_admin_bloc.dart';

part 'quiz_admin_event.dart';
part 'quiz_admin_state.dart';

class QuizAdminBloc extends Bloc<QuizAdminEvent, QuizAdminState> {
  final GetAllQuizzes getAllQuizzes;
  final GetAllCategories getAllCategories;
  final GetAllQuizzesByCategoryId getQuizzesByCategoryId;
  final AddQuiz addQuiz;
  final DeleteQuiz deleteQuiz;
  final UpdateQuiz updateQuiz;
  final SearchQuiz searchQuiz;

  List<QuizAdmin> _quizzes = [];
  QuizAdminBloc(
    this.getAllQuizzes,
    this.getAllCategories,
    this.getQuizzesByCategoryId,
    this.deleteQuiz,
    this.addQuiz,
    this.updateQuiz,
    this.searchQuiz,
  ) : super(QuizAdminState()) {
    on<GetAllQuizzesEvent>(_onGetAllQuizzes);
    on<SearchQuizEvent>(_onSearchQuiz);
    on<GetQuizzesByCategoryIdEvent>(_onGetQuizzesByCategoryId);
    on<AddQuizEvent>(_onAddQuiz);
    on<UpdateQuizEvent>(_onUpdateQuiz);
    on<DeleteQuizEvent>(_onDeleteQuiz);
  }

  void _onGetAllQuizzes(
      GetAllQuizzesEvent event, Emitter<QuizAdminState> emit) async {
    if (state.status != Status.loading) {
      emit(state.copyWith(status: Status.loading));
    }
    final quizzesResult = await getAllQuizzes(event.userId);

    quizzesResult.fold(
        (failure) => emit(
            state.copyWith(message: failure.message, status: Status.error)),
        (success) {
      _quizzes = success;
    });
    if (state.categories.isEmpty) {
      final categoriesResult = await getAllCategories(NoParameters());
      categoriesResult.fold(
        (failure) {
          emit(state.copyWith(message: failure.message, status: Status.error));
          return null;
        },
        (success) => emit(state.copyWith(categories: success)),
      );
    }

    emit(state.copyWith(
      quizzes: _quizzes,
      selectedCategoryId: -1,
      status: Status.loaded,
    ));
  }

  void _onGetQuizzesByCategoryId(
      GetQuizzesByCategoryIdEvent event, Emitter<QuizAdminState> emit) async {
    emit(state.copyWith(status: Status.loading));
    if (event.id == -1) {
      final userId = await getIt<FlutterSecureStorage>().read(key: 'id');
      final quizzesResult = await getAllQuizzes(userId!);
      quizzesResult.fold(
        (failure) {
          emit(
              state.copyWith(message: failure.message, status: Status.loading));
          return;
        },
        (success) {
          _quizzes = success;
          emit(state.copyWith(selectedCategoryId: event.id));
        },
      );
    } else {
      final quizzesResult = await getQuizzesByCategoryId(event.id);

      quizzesResult.fold((failure) {
        emit(state.copyWith(message: failure.message, status: Status.error));
        return;
      }, (success) {
        _quizzes = success;
        emit(state.copyWith(selectedCategoryId: event.id));
      });

      if (state.categories.isEmpty) {
        emit(state.copyWith(categories: event.categories));
      }
    }

    emit(state.copyWith(
      quizzes: _quizzes,
      status: Status.loaded,
    ));
  }

  void _onAddQuiz(AddQuizEvent event, Emitter<QuizAdminState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final result = await addQuiz(event.quiz);

    result.fold(
      (failure) => emit(state.copyWith(
        message: failure.message,
        status: Status.error,
      )),
      (success) {
        _quizzes.add(success);
        emit(state.copyWith(quizzes: _quizzes, status: Status.loaded));
      },
    );
  }

  void _onUpdateQuiz(
      UpdateQuizEvent event, Emitter<QuizAdminState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final result = await updateQuiz(event.quiz);

    result.fold(
      (failure) => emit(state.copyWith(
        message: failure.message,
        status: Status.error,
      )),
      (success) {
        final updateQuizzes = List<QuizAdmin>.from(_quizzes);
        final index = updateQuizzes.indexWhere((q) => q.id == event.quiz.id!);
        updateQuizzes[index] = success;

        emit(state.copyWith(quizzes: updateQuizzes, status: Status.loaded));
      },
    );
  }

  void _onDeleteQuiz(
      DeleteQuizEvent event, Emitter<QuizAdminState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final deleteResult = await deleteQuiz(event.quiz);

    deleteResult.fold(
      (failure) =>
          emit(state.copyWith(message: failure.message, status: Status.error)),
      (success) {
        _quizzes.remove(event.quiz);
        emit(
          state.copyWith(
            quizzes: _quizzes,
            status: Status.loaded,
          ),
        );
      },
    );
  }

  void _onSearchQuiz(
      SearchQuizEvent event, Emitter<QuizAdminState> emit) async {
    if (event.title.isNotEmpty) {
      final userId = await getIt<FlutterSecureStorage>().read(key: 'id');
      log(userId.toString());
      final result = await searchQuiz(
        SearchParameters(
          event.title,
          categoryId:
              state.selectedCategoryId != -1 ? state.selectedCategoryId : null,
          userId: userId,
        ),
      );
      result.fold(
        (failure) => emit(
            state.copyWith(message: failure.message, status: Status.error)),
        (success) {
          final searchQuizzes = List<QuizAdmin>.from(success);
          emit(
            state.copyWith(quizzes: searchQuizzes, status: Status.loaded),
          );
        },
      );
    } else {
      emit(state.copyWith(quizzes: _quizzes, status: Status.loaded));
    }
  }
}
