import 'package:dartz/dartz.dart';
import 'package:quiz_app/auth/domain/repository/base_auth_repository.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/network/response_model.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';

class ResetPasswordUsecase
    extends BaseUseCase<ResponseModel, ResetPasswordParameters> {
  final BaseAuthRepository baseAuthRepository;

  ResetPasswordUsecase(this.baseAuthRepository);

  @override
  Future<Either<Failure, ResponseModel>> call(
      ResetPasswordParameters parameters) async {
    return await baseAuthRepository.resetPassword(parameters);
  }
}

class ResetPasswordParameters {
  final String email;
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordParameters({
    required this.email,
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });
}
