import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/admin/domain/entities/category_admin.dart';
import 'package:quiz_app/admin/domain/usecase/category/add_category.dart';

abstract class BaseCategoryRepositoryAdmin {
  Future<Either<Failure, List<CategoryAdmin>>> getAllCategories();
  Future<Either<Failure, CategoryAdmin>> addCategory(CategoryParameter parameters);
  Future<Either<Failure, void>> deleteCategory(int id);
  Future<Either<Failure, void>> updateCategory(CategoryParameter parameters);

}
