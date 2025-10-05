part of 'category_admin_bloc.dart';

sealed class CategoryAdminEvent extends Equatable {
  const CategoryAdminEvent();

  @override
  List<Object> get props => [];
}

class GetAllCategoriesEvent extends CategoryAdminEvent {}

class AddCategoryEvent extends CategoryAdminEvent {
  final String name;
  final String description;

  const AddCategoryEvent(this.name, this.description);
}

class DeleteCategoryEvent extends CategoryAdminEvent {
  final CategoryAdmin category;

  const DeleteCategoryEvent(this.category);
}

class UpdateCategoryEvent extends CategoryAdminEvent {
  final CategoryAdmin category;

  const UpdateCategoryEvent(this.category);
}
