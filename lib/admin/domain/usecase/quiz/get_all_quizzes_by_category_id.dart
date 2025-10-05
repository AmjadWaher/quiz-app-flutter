import 'package:dartz/dartz.dart';

import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_quiz_repository_admin.dart';

class GetAllQuizzesByCategoryId extends BaseUseCase<List<QuizAdmin>, int> {
  final BaseQuizRepositoryAdmin baseQuizRepository;

  GetAllQuizzesByCategoryId(this.baseQuizRepository);
  @override
  Future<Either<Failure, List<QuizAdmin>>> call(int parameters) async {
    return baseQuizRepository.getAllQuizzesByCategoryId(parameters);
  }
}
