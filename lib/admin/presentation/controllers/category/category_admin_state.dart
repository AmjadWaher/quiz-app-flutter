part of 'category_admin_bloc.dart';

class CategoryAdminState extends Equatable {
  final List<CategoryAdmin> categories;
  final Status status;
  final String message;
  const CategoryAdminState({
    this.categories = const [],
    this.status = Status.loading,
    this.message = '',
  });

  CategoryAdminState copyWith({
    List<CategoryAdmin>? categories,
    Status? status,
    String? message,
  }) {
    return CategoryAdminState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [categories,status,message];
}
