import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/user/domain/entities/category_user.dart';
import 'package:quiz_app/user/domain/repository/base_category_repository_user.dart';

class FetchAllCategories extends BaseUseCase<List<CategoryUser>, NoParameters> {
  final BaseCategoryRepositoryUser baseCatecoryRepository;
  FetchAllCategories(this.baseCatecoryRepository);

  @override
  Future<Either<Failure,List<CategoryUser>>> call(NoParameters parameters) async {
    return await baseCatecoryRepository.getAllCategories();
  }
}
