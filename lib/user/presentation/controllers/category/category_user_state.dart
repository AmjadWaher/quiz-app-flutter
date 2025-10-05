// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_user_bloc.dart';

class CategoryUserState extends Equatable {
  final List<CategoryUser> categories;
  final List<FilterCategory> filterCategories;

  final Status status;
  final String message;
  const CategoryUserState({
    this.categories = const [],
    this.filterCategories = const [],
    this.status = Status.loading,
    this.message = '',
  });

  CategoryUserState copyWith({
    List<CategoryUser>? categories,
    List<FilterCategory>? filterCategories,
    Status? status,
    String? message,
  }) {
    return CategoryUserState(
      categories: categories ?? this.categories,
      filterCategories: filterCategories ?? this.filterCategories,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [categories, status, message, filterCategories];
}

class FilterCategory extends Equatable {
  final int id;
  final String name;
  final bool isSelected;

  const FilterCategory({
    required this.id,
    required this.name,
    required this.isSelected,
  });

  FilterCategory copyWith({
    int? id,
    String? name,
    bool? isSelected,
  }) {
    return FilterCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object> get props => [id, name, isSelected];
}
