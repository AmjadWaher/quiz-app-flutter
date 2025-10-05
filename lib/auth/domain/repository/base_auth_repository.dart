import 'package:dartz/dartz.dart';
import 'package:quiz_app/auth/data/models/user_model.dart';
import 'package:quiz_app/auth/domain/usecase/login_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/register_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/reset_password_usecase.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/network/response_model.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, UserModel>> login(LoginParameters parameters);
  Future<Either<Failure, ResponseModel>> register(
      RegisterRequest registerRequest);
  Future<Either<Failure, ResponseModel>> forgotPassword(String email);
  Future<Either<Failure, ResponseModel>> resetPassword(ResetPasswordParameters parameters);
}
