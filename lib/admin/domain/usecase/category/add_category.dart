// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/core/error/failure.dart';

import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/entities/category_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_category_repository_admin.dart';

class AddCategory extends BaseUseCase<CategoryAdmin, CategoryParameter> {
  final BaseCategoryRepositoryAdmin baseCatecoryRepository;

  AddCategory(this.baseCatecoryRepository);

  @override
  Future<Either<Failure, CategoryAdmin>> call(CategoryParameter parameters) async {
    return await baseCatecoryRepository.addCategory(parameters);
  }
}

class CategoryParameter extends Equatable {
  final int? id;
  final String name;
  final String description;

  const CategoryParameter({
    this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [name, description];
}
