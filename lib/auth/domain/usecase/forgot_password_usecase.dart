import 'package:dartz/dartz.dart';
import 'package:quiz_app/auth/domain/repository/base_auth_repository.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/network/response_model.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';

class ForgotPasswordUsecase extends BaseUseCase<ResponseModel, String> {
  final BaseAuthRepository baseAuthRepository;

  ForgotPasswordUsecase(this.baseAuthRepository);

  @override
  Future<Either<Failure, ResponseModel>> call(String parameters) async {
    return await baseAuthRepository.forgotPassword(parameters);
  }
}
