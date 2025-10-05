import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/user/domain/entities/category_user.dart';

abstract class BaseCategoryRepositoryUser {
  Future<Either<Failure, List<CategoryUser>>> getAllCategories();
}
