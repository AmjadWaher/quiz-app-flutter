import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/admin/domain/entities/category_admin.dart';
import 'package:quiz_app/admin/domain/usecase/category/add_category.dart';
import 'package:quiz_app/admin/domain/usecase/category/delete_category.dart';
import 'package:quiz_app/admin/domain/usecase/category/get_all_categories.dart';
import 'package:quiz_app/admin/domain/usecase/category/updart_category.dart';

part 'category_admin_event.dart';
part 'category_admin_state.dart';

class CategoryAdminBloc extends Bloc<CategoryAdminEvent, CategoryAdminState> {
  final GetAllCategories getAllCategories;
  final DeleteCategory deleteCategory;
  final AddCategory addCategory;
  final UpdateCategory updateCategory;

  List<CategoryAdmin> _categories = [];
  CategoryAdminBloc(
    this.getAllCategories,
    this.deleteCategory,
    this.addCategory,
    this.updateCategory,
  ) : super(CategoryAdminState()) {
    on<GetAllCategoriesEvent>(_onGetAllCategories);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
  }

  void _onGetAllCategories(
      GetAllCategoriesEvent event, Emitter<CategoryAdminState> emit) async {
    final result = await getAllCategories(NoParameters());
    result.fold(
        (failure) => emit(state.copyWith(
              status: Status.error,
            )), (success) {
      _categories = success;
      return emit(state.copyWith(
        categories: _categories,
        status: Status.loaded,
      ));
    });
  }

  void _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<CategoryAdminState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final result = await deleteCategory(event.category.id);

    result.fold(
        (failure) => emit(state.copyWith(
              status: Status.error,
              message: 'error in delete category',
            )), (success) {
      _categories.remove(event.category);
      emit(state.copyWith(
        categories: _categories,
        status: Status.loaded,
      ));
    });
  }

  void _onAddCategory(
      AddCategoryEvent event, Emitter<CategoryAdminState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final result = await addCategory(CategoryParameter(
      name: event.name,
      description: event.description,
    ));
    result.fold(
        (failure) => emit(
            state.copyWith(message: failure.message, status: Status.error)),
        (success) {
      _categories.add(success);
      emit(state.copyWith(
        categories: _categories,
        status: Status.loaded,
      ));
    });
  }

  void _onUpdateCategory(
      UpdateCategoryEvent event, Emitter<CategoryAdminState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final result = await updateCategory(CategoryParameter(
      id: event.category.id,
      name: event.category.name,
      description: event.category.description,
    ));

    result.fold(
      (failure) =>
          emit(state.copyWith(message: failure.message, status: Status.error)),
      (success) {
        final updateCategory = List<CategoryAdmin>.from(state.categories);
        final index =
            updateCategory.indexWhere((c) => c.id == event.category.id);
        if (index != -1) {
          updateCategory[index] = event.category;
        }

        emit(state.copyWith(categories: updateCategory, status: Status.loaded));
      },
    );
  }
}
