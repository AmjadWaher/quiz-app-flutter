import 'package:dartz/dartz.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/delete_quiz.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/search_quiz.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/admin/data/datasource/quiz_remote_datasource_admin.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_quiz_repository_admin.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/add_quiz.dart';

class QuizzesRepositoryAdmin extends BaseQuizRepositoryAdmin {
  final BaseQuizRemoteDatasourceAdmin baseQuizRemoteDatasource;

  QuizzesRepositoryAdmin(this.baseQuizRemoteDatasource);

  @override
  Future<Either<Failure, List<QuizAdmin>>> getAllQuizzes(String userId) async {
    final result = await baseQuizRemoteDatasource.getAllQuizzes(userId);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, QuizAdmin>> addQuiz(QuizParameters parameters) async {
    final result = await baseQuizRemoteDatasource.addQuiz(parameters);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, List<QuizAdmin>>> getAllQuizzesByCategoryId(
      int id) async {
    final result = await baseQuizRemoteDatasource.getAllQuizzesByCategoryId(id);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, List<QuizAdmin>>> searchQuiz(
      SearchParameters parameters) async {
    final result = await baseQuizRemoteDatasource.searchQuiz(parameters);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuiz(
      DeleteQuizParameters parameters) async {
    final result = await baseQuizRemoteDatasource.deleteQuiz(parameters);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, QuizAdmin>> updateQuiz(
      QuizParameters parameters) async {
    final result = await baseQuizRemoteDatasource.updateQuiz(parameters);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
}
