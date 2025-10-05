import 'package:dio/dio.dart';
import 'package:quiz_app/auth/data/models/user_model.dart';
import 'package:quiz_app/auth/domain/entities/user.dart';
import 'package:quiz_app/auth/domain/usecase/register_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/reset_password_usecase.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/network/api_constance.dart';
import 'package:quiz_app/core/network/error_message_model.dart';
import 'package:quiz_app/core/network/response_model.dart';
import 'package:quiz_app/core/service/service_locator.dart';

abstract class BaseAuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<ResponseModel> register(RegisterRequest registerRequest);
  Future<ResponseModel> resetPassword(ResetPasswordParameters parameters);
  Future<ResponseModel> forgotPassword(String email);
}

class AuthRemoteDatasource extends BaseAuthRemoteDataSource {
  @override
  Future<ResponseModel> forgotPassword(String email) async {
    final response = await getIt<Dio>().post(
      ApiConstance.forgotPassword,
      data: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      return ResponseModel.fromJson(response.data);
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await getIt<Dio>().post(
      ApiConstance.loginPath,
      data: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw ServerException(
        errorMessageModel:
            ErrorMessageModel.fromJson(response.data as Map<String, dynamic>),
      );
    }
  }

  @override
  Future<ResponseModel> register(RegisterRequest registerRequest) async {
    final response = await getIt<Dio>().post(
      ApiConstance.registerPath,
      data: {
        'username': registerRequest.username,
        'email': registerRequest.email,
        'password': registerRequest.password,
        'confirmPassword': registerRequest.confirmPassword,
        'role': registerRequest.role.toLowerCase() ==
                Role.teacher.name.toLowerCase()
            ? 'Admin'
            : 'User',
      },
    );
    if (response.statusCode == 200) {
      return ResponseModel.fromJson(response.data);
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<ResponseModel> resetPassword(
      ResetPasswordParameters parameters) async {
    final response = await getIt<Dio>().post(
      ApiConstance.resetPassword,
      data: {
        'email': parameters.email,
        'token': parameters.token,
        'password': parameters.newPassword,
        'confirmPassword': parameters.confirmPassword,
      },
    );

    if (response.statusCode == 200) {
      return ResponseModel.fromJson(response.data);
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data));
    }
  }
}
