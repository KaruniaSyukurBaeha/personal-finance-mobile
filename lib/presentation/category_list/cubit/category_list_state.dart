part of 'category_list_cubit.dart';

@immutable
sealed class CategoryListState {}

final class CategoryListInitial extends CategoryListState {}

final class CategoryListLoaded extends CategoryListState {
  final List<Category> categories;
  CategoryListLoaded({required this.categories});
}

class CategoryListError extends CategoryListState {
  final String message;
  CategoryListError({required this.message});
}

class CategoryListLoading extends CategoryListState {}