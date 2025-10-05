part of 'category_user_bloc.dart';

sealed class CategoryUserEvent extends Equatable {
  const CategoryUserEvent();

  @override
  List<Object> get props => [];
}

class FetchAllCategoriesEvent extends CategoryUserEvent {}

class SearchForCategoriesEvent extends CategoryUserEvent {
  final String name;

  const SearchForCategoriesEvent(this.name);
}

class FilterCategoriesEvent extends CategoryUserEvent {
  final int categoryId;

  const FilterCategoriesEvent(this.categoryId);
}

class SelectFilterCategoryEvent extends CategoryUserEvent {
  final int categoryId;

  const SelectFilterCategoryEvent(this.categoryId);
}
