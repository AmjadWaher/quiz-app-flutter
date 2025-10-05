import 'package:dio/dio.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/network/api_constance.dart';
import 'package:quiz_app/core/network/error_message_model.dart';
import 'package:quiz_app/admin/data/models/category_admin_model.dart';
import 'package:quiz_app/admin/domain/usecase/category/add_category.dart';
import 'package:quiz_app/core/service/service_locator.dart';

abstract class BaseCategoryRemoteDatasourceAdmin {
  Future<List<CategoryAdminModel>> getAllCategories();
  Future<CategoryAdminModel> addCategory(CategoryParameter parameters);
  Future<void> deleteCategory(int id);
  Future<void> updateCategory(CategoryParameter parameters);
}

class CategoryRemoteDatasourceAdmin
    implements BaseCategoryRemoteDatasourceAdmin {
  @override
  Future<List<CategoryAdminModel>> getAllCategories() async {
    final response = await getIt<Dio>().get(ApiConstance.categoryPath);

    if (response.statusCode == 200) {
      return List<CategoryAdminModel>.from(
        (response.data as List)
            .map((json) => CategoryAdminModel.fromJson(json)),
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<CategoryAdminModel> addCategory(CategoryParameter parameters) async {
    final response = await getIt<Dio>().post(ApiConstance.categoryPath, data: {
      'name': parameters.name,
      'description': parameters.description,
    });

    if (response.statusCode == 200) {
      return CategoryAdminModel.fromJson(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    final response =
        await getIt<Dio>().delete(ApiConstance.categoryByIdPath(id));

    if (response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> updateCategory(CategoryParameter parameters) async {
    final response = await getIt<Dio>()
        .put(ApiConstance.categoryByIdPath(parameters.id!), data: {
      'name': parameters.name,
      'description': parameters.description,
    });

    if (response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}
