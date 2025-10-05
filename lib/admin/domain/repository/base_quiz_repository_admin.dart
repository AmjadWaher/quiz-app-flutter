import 'package:dartz/dartz.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/delete_quiz.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/search_quiz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/add_quiz.dart';

abstract class BaseQuizRepositoryAdmin {
  Future<Either<Failure, List<QuizAdmin>>> getAllQuizzes(String userId);
  Future<Either<Failure, List<QuizAdmin>>> getAllQuizzesByCategoryId(int id);
  Future<Either<Failure, List<QuizAdmin>>> searchQuiz(SearchParameters parameters);
  Future<Either<Failure, QuizAdmin>> addQuiz(QuizParameters parameters);
  Future<Either<Failure, QuizAdmin>> updateQuiz(QuizParameters parameters);
  Future<Either<Failure, void>> deleteQuiz(DeleteQuizParameters parameters);
}
