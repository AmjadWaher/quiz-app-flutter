import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/core/service/service_locator.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';

import 'package:quiz_app/admin/domain/usecase/category/get_all_categories.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/get_all_quizzes.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/get_all_quizzes_by_category_id.dart';

part 'statistics_admin_event.dart';
part 'statistics_admin_state.dart';

class StatisticsAdminBloc
    extends Bloc<StatisticsAdminEvent, StatisticsAdminState> {
  final GetAllQuizzes getAllQuizzes;
  final GetAllQuizzesByCategoryId getAllQuizzesByCategoryId;
  final GetAllCategories getAllCategories;
  StatisticsAdminBloc(
      this.getAllQuizzes, this.getAllQuizzesByCategoryId, this.getAllCategories)
      : super(StatisticsAdminState()) {
    on<GetStatisticsDataEvent>(_onGetData);
  }

  void _onGetData(
      GetStatisticsDataEvent event, Emitter<StatisticsAdminState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final userId = await getIt<FlutterSecureStorage>().read(key: 'id');
    final quizResult = await getAllQuizzes(userId!);
    final categoryResult = await getAllCategories(NoParameters());

    final quizState = quizResult.fold(
      (faliure) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: faliure.message,
          ),
        );
        return null;
      },
      (success) => success,
    );
    if (quizState == null) return;

    final categoryState = await categoryResult.fold((faliure) {
      emit(
        state.copyWith(
          status: Status.error,
          errorMessage: faliure.message,
        ),
      );
      return null;
    }, (success) async {
      final categories = await Future.wait(
        success.map(
          (category) async {
            final quiz = await quizByCategoryId(category.id);
            if (quiz == null) {
              return StatisticsCategory();
            } else {
              return StatisticsCategory(
                name: category.name,
                count: quiz.length,
              );
            }
          },
        ).toList(),
      );

      return categories;
    });

    if (categoryState == null) return;

    emit(state.copyWith(
      status: Status.loaded,
      latestQuiz: quizState.reversed.take(5).toList(),
      totalQuiz: quizState.length,
      categories: categoryState,
      totalCategory: categoryState.length,
    ));
  }

  Future<List<QuizAdmin>?> quizByCategoryId(int id) async {
    final result = await getAllQuizzesByCategoryId(id);

    return result.fold((failure) => null, (success) => success);
  }
}
