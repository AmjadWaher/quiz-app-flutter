import 'package:dartz/dartz.dart';

import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/user/domain/domain_user.dart';

class FetchQuizzesByCategoryId extends BaseUseCase<List<QuizUser>, int> {
  final BaseQuizRepositoryUser baseQuizRepositoryUser;

  FetchQuizzesByCategoryId(this.baseQuizRepositoryUser);
  @override
  Future<Either<Failure, List<QuizUser>>> call(int parameters) async {
    return baseQuizRepositoryUser.getQuizzesByCategoryId(parameters);
  }
}
