import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/admin/data/datasource/question_remote_datasource_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_question_repository_admin.dart';

class QuestionRepositoryAdmin extends BaseQuestionRepositoryAdmin {
  final BaseQuestionRemoteDatasourceAdmin baseQuestionRemoteDatasource;

  QuestionRepositoryAdmin(this.baseQuestionRemoteDatasource);
  @override
  Future<Either<Failure, void>> deleteQuestion(int id) async {
    final result = await baseQuestionRemoteDatasource.deleteQuestion(id);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
}
