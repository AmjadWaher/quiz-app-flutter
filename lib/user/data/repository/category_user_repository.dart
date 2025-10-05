import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/user/data/datasource/category_remote_datasource_user.dart';
import 'package:quiz_app/user/domain/entities/category_user.dart';
import 'package:quiz_app/user/domain/repository/base_category_repository_user.dart';

class CategoryUserRepository extends BaseCategoryRepositoryUser {
  final BaseCategoryRemoteDatasourceUser baseCategoryRemoteDatasourceUser;

  CategoryUserRepository(this.baseCategoryRemoteDatasourceUser);
  @override
  Future<Either<Failure, List<CategoryUser>>> getAllCategories() async {
    final result = await baseCategoryRemoteDatasourceUser.getAllCategories();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
}
