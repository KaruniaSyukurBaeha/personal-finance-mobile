part of 'add_category_cubit.dart';

@immutable
sealed class AddCategoryState {}

final class AddCategoryInitial extends AddCategoryState {}

class AddCategoryLoading extends AddCategoryState {}

class AddCategorySuccess extends AddCategoryState {
  final String message;

  AddCategorySuccess({required this.message});
}

class AddCategoryError extends AddCategoryState {
  final String message;

  AddCategoryError({required this.message});
}