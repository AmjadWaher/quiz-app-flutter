import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/entities/category_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_category_repository_admin.dart';

class GetAllCategories extends BaseUseCase<List<CategoryAdmin>, NoParameters> {
  final BaseCategoryRepositoryAdmin baseCatecoryRepository;
  GetAllCategories(this.baseCatecoryRepository);

  @override
  Future<Either<Failure,List<CategoryAdmin>>> call(NoParameters parameters) async {
    return await baseCatecoryRepository.getAllCategories();
  }
}
