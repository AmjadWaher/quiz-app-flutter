import 'package:dartz/dartz.dart';
import 'package:quiz_app/auth/data/models/user_model.dart';
import 'package:quiz_app/auth/domain/repository/base_auth_repository.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';

class LoginUsecase extends BaseUseCase<UserModel, LoginParameters> {
  final BaseAuthRepository _baseAuthRepository;

  LoginUsecase(this._baseAuthRepository);
  @override
  Future<Either<Failure, UserModel>> call(LoginParameters parameters) async {
    return await _baseAuthRepository.login(parameters);
  }
}

class LoginParameters {
  final String email;
  final String password;

  LoginParameters({required this.email, required this.password});
}
