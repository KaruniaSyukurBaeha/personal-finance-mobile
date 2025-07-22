part of 'edit_category_cubit.dart';

@immutable
sealed class EditCategoryState {}

class EditCategoryInitial extends EditCategoryState {}

class EditCategoryLoading extends EditCategoryState {}

class EditCategorySuccess extends EditCategoryState {
  final String message;
  EditCategorySuccess({required this.message});
}

class EditCategoryError extends EditCategoryState {
  final String message;
  EditCategoryError({required this.message});
}