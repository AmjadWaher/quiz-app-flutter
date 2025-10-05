import 'package:dartz/dartz.dart';

import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_quiz_repository_admin.dart';

class GetAllQuizzes extends BaseUseCase<List<QuizAdmin>, String> {
  final BaseQuizRepositoryAdmin baseQuizRepository;

  GetAllQuizzes(this.baseQuizRepository);
  @override
  Future<Either<Failure, List<QuizAdmin>>> call(String parameters) async {
    return baseQuizRepository.getAllQuizzes(parameters);
  }
}
