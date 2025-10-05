import 'package:dartz/dartz.dart';

import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_quiz_repository_admin.dart';

class SearchQuiz extends BaseUseCase<List<QuizAdmin>, SearchParameters> {
  final BaseQuizRepositoryAdmin baseQuizRepository;

  SearchQuiz(this.baseQuizRepository);
  @override
  Future<Either<Failure, List<QuizAdmin>>> call(
      SearchParameters parameters) async {
    return baseQuizRepository.searchQuiz(parameters);
  }
}

class SearchParameters {
  final int? categoryId;
  final String? userId;
  final String title;

  SearchParameters(this.title, {this.categoryId, this.userId});
}
