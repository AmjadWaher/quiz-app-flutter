import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/repository/base_category_repository_admin.dart';

class DeleteCategory extends BaseUseCase<void,int>{
  final BaseCategoryRepositoryAdmin baseCatecoryRepository;

  DeleteCategory(this.baseCatecoryRepository);

  @override
  Future<Either<Failure, void>> call(int parameters) async{
    return await baseCatecoryRepository.deleteCategory(parameters);
  }
}