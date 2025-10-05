import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/admin/data/datasource/category_remote_datasource_admin.dart';
import 'package:quiz_app/admin/domain/entities/category_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_category_repository_admin.dart';
import 'package:quiz_app/admin/domain/usecase/category/add_category.dart';

class CategoriesRepositoryAdmin extends BaseCategoryRepositoryAdmin {
  final BaseCategoryRemoteDatasourceAdmin baseCategoryRemoteDatasource;

  CategoriesRepositoryAdmin(this.baseCategoryRemoteDatasource);

  @override
  Future<Either<Failure, List<CategoryAdmin>>> getAllCategories() async {
    final result = await baseCategoryRemoteDatasource.getAllCategories();

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, CategoryAdmin>> addCategory(
      CategoryParameter parameters) async {
    final result = await baseCategoryRemoteDatasource.addCategory(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteCategory(int id) async{
   final result = await baseCategoryRemoteDatasource.deleteCategory(id);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateCategory(CategoryParameter parameters) async{
    final result = await baseCategoryRemoteDatasource.updateCategory(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
}
