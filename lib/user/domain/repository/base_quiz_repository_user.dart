import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/user/domain/domain_user.dart';

abstract class BaseQuizRepositoryUser {
  Future<Either<Failure, List<QuizUser>>> getQuizzesByCategoryId(int id);
}
