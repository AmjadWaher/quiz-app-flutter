import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/repository/base_question_repository_admin.dart';

class DeleteQuesetion extends BaseUseCase<void, int> {
  final BaseQuestionRepositoryAdmin baseQuestionRepository;

  DeleteQuesetion(this.baseQuestionRepository);
  @override
  Future<Either<Failure, void>> call(int parameters) async {
    return await baseQuestionRepository.deleteQuestion(parameters);
  }
}
