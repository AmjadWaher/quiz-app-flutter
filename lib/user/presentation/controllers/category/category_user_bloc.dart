import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/user/domain/entities/category_user.dart';
import 'package:quiz_app/user/domain/usecase/category/fetch_all_categories.dart';

part 'category_user_event.dart';
part 'category_user_state.dart';

class CategoryUserBloc extends Bloc<CategoryUserEvent, CategoryUserState> {
  final FetchAllCategories getAllCategories;

  List<CategoryUser> _categories = [];
  CategoryUserBloc(
    this.getAllCategories,
  ) : super(CategoryUserState()) {
    on<FetchAllCategoriesEvent>(_onFetchAllCategories);
    on<FilterCategoriesEvent>(_onFilterCategories);
    on<SearchForCategoriesEvent>(_onSearchForCategories);
    on<SelectFilterCategoryEvent>(_onSelectFilterCategory);
  }

  void _onFetchAllCategories(
      FetchAllCategoriesEvent event, Emitter<CategoryUserState> emit) async {
    final result = await getAllCategories(NoParameters());
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.error,
      )),
      (success) {
        _categories = success;
      },
    );

    final filterCategories = [
      FilterCategory(id: -1, name: 'All', isSelected: true),
      ..._categories.map(
        (category) => FilterCategory(
            id: category.id, name: category.name, isSelected: false),
      ),
    ];

    emit(state.copyWith(
      filterCategories: filterCategories,
      categories: _categories,
      status: Status.loaded,
    ));
  }

  void _onFilterCategories(
      FilterCategoriesEvent event, Emitter<CategoryUserState> emit) async {
    if (event.categoryId == -1) {
      emit(state.copyWith(
        categories: _categories,
        status: Status.loaded,
      ));
    } else {
      final category = _categories.firstWhere(
        (category) => category.id == event.categoryId,
      );
      emit(state.copyWith(
        categories: [category],
        status: Status.loaded,
      ));
    }
  }

  void _onSearchForCategories(
      SearchForCategoriesEvent event, Emitter<CategoryUserState> emit) async {
    emit(state.copyWith(status: Status.loading));

    final categories = _categories.where((category) {
      final name = category.name.toLowerCase();
      final searchTerm = event.name.toLowerCase();
      return name.contains(searchTerm);
    }).toList();

    emit(state.copyWith(
      categories: categories,
      status: Status.loaded,
    ));
  }

  void _onSelectFilterCategory(
      SelectFilterCategoryEvent event, Emitter<CategoryUserState> emit) {
    final updateFilterCategory =
        List<FilterCategory>.from(state.filterCategories.map(
      (category) => category.id == event.categoryId
          ? category = category.copyWith(isSelected: true)
          : category = category.copyWith(isSelected: false),
    ));

    emit(state.copyWith(filterCategories: updateFilterCategory));
  }
}
