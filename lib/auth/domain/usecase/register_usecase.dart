import 'package:dartz/dartz.dart';
import 'package:quiz_app/auth/domain/repository/base_auth_repository.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/network/response_model.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';

class RegisterUsecase extends BaseUseCase<ResponseModel, RegisterRequest> {
  final BaseAuthRepository baseAuthRepository;

  RegisterUsecase(this.baseAuthRepository);

  @override
  Future<Either<Failure, ResponseModel>> call(
      RegisterRequest parameters) async {
    return await baseAuthRepository.register(parameters);
  }
}

class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });
}
