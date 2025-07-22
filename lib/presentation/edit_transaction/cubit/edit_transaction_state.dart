part of 'edit_transaction_cubit.dart';

@immutable
sealed class EditTransactionState {}

class EditTransactionInitial extends EditTransactionState {}

class EditTransactionLoading extends EditTransactionState {}

class EditTransactionSuccess extends EditTransactionState {
  final String message;
  EditTransactionSuccess({required this.message});
}

class EditTransactionError extends EditTransactionState {
  final String message;
  EditTransactionError({required this.message});
}