import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/user/data/datasource/quiz_remote_datasource_user.dart';
import 'package:quiz_app/user/domain/domain_user.dart';

class QuizUserRepository extends BaseQuizRepositoryUser {
  final BaseQuizRemoteDatasourceUser baseQuizRemoteDatasourceUser;

  QuizUserRepository(this.baseQuizRemoteDatasourceUser);

  @override
  Future<Either<Failure, List<QuizUser>>> getQuizzesByCategoryId(int id) async {
    final result =
        await baseQuizRemoteDatasourceUser.getQuizzesByCategoryId(id);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
}
