import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';

abstract class BaseQuestionRepositoryAdmin {
  Future<Either<Failure,void>> deleteQuestion(int id);
}