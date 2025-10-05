import 'package:dartz/dartz.dart';
import 'package:quiz_app/auth/data/datasource/auth_remote_datasource.dart';
import 'package:quiz_app/auth/data/models/user_model.dart';
import 'package:quiz_app/auth/domain/repository/base_auth_repository.dart';
import 'package:quiz_app/auth/domain/usecase/login_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/register_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/reset_password_usecase.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/network/response_model.dart';

class AuthRepository extends BaseAuthRepository {
  final BaseAuthRemoteDataSource _baseAuthRemoteDataSource;

  AuthRepository(this._baseAuthRemoteDataSource);
  @override
  Future<Either<Failure, ResponseModel>> forgotPassword(String email) async {
    try {
      final reslut = await _baseAuthRemoteDataSource.forgotPassword(email);

      return Right(reslut);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> login(LoginParameters parameters) async {
    try {
      final reslut = await _baseAuthRemoteDataSource.login(
          parameters.email, parameters.password);

      return Right(reslut);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, ResponseModel>> register(
      RegisterRequest registerRequest) async {
    try {
      final reslut = await _baseAuthRemoteDataSource.register(registerRequest);
      return Right(reslut);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, ResponseModel>> resetPassword(
      ResetPasswordParameters parameters) async {
    try {
      final reslut = await _baseAuthRemoteDataSource.resetPassword(parameters);

      return Right(reslut);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
}
