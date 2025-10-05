import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/repository/base_quiz_repository_admin.dart';

class DeleteQuiz extends BaseUseCase<void, DeleteQuizParameters> {
  final BaseQuizRepositoryAdmin baseQuizRepository;

  DeleteQuiz(this.baseQuizRepository);

  @override
  Future<Either<Failure, void>> call(DeleteQuizParameters parameters) async {
    return await baseQuizRepository.deleteQuiz(parameters);
  }
}

class DeleteQuizParameters extends Equatable {
  final int quizId;
  final String userId;

  const DeleteQuizParameters({
    required this.quizId,
    required this.userId,
  });

  @override
  List<Object> get props => [quizId, userId];
}
