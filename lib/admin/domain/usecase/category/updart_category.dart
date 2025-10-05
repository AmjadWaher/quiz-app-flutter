import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/repository/base_category_repository_admin.dart';
import 'package:quiz_app/admin/domain/usecase/category/add_category.dart';

class UpdateCategory extends BaseUseCase<void,CategoryParameter>{
  final BaseCategoryRepositoryAdmin baseCatecoryRepository;

  UpdateCategory(this.baseCatecoryRepository);

  @override
  Future<Either<Failure, void>> call(CategoryParameter parameters) async{
    return await baseCatecoryRepository.updateCategory(parameters);
  }
}