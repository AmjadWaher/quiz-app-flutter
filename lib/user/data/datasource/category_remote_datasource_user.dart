import 'package:dio/dio.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/network/api_constance.dart';
import 'package:quiz_app/core/network/error_message_model.dart';
import 'package:quiz_app/core/service/service_locator.dart';
import 'package:quiz_app/user/data/models/category_user_model.dart';

abstract class BaseCategoryRemoteDatasourceUser {
  Future<List<CategoryUserModel>> getAllCategories();
  Future<List<CategoryUserModel>> searchForCategories(String name);
}

class CategoryRemoteDatasourceUser implements BaseCategoryRemoteDatasourceUser {
  @override
  Future<List<CategoryUserModel>> getAllCategories() async {
    final response = await getIt<Dio>().get(ApiConstance.categoryPath);

    if (response.statusCode == 200) {
      return List<CategoryUserModel>.from(
        (response.data as List).map((json) => CategoryUserModel.fromJson(json)),
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<CategoryUserModel>> searchForCategories(String name) async {
    final response =
        await getIt<Dio>().get(ApiConstance.searchForCategories(name));

    if (response.statusCode == 200) {
      return List<CategoryUserModel>.from(
        (response.data as List).map((json) => CategoryUserModel.fromJson(json)),
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}
