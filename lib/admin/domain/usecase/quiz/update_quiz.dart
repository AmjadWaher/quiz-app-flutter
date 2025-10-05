import 'package:dartz/dartz.dart';

import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_quiz_repository_admin.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/add_quiz.dart';

class UpdateQuiz extends BaseUseCase<QuizAdmin, QuizParameters> {
  final BaseQuizRepositoryAdmin baseQuizRepository;

  UpdateQuiz(this.baseQuizRepository);
  @override
  Future<Either<Failure, QuizAdmin>> call(QuizParameters parameters) async {
    return baseQuizRepository.updateQuiz(parameters);
  }
}
