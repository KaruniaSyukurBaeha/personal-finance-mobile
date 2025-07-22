part of 'add_transaction_cubit.dart';

@immutable
sealed class AddTransactionState {}

final class AddTransactionInitial extends AddTransactionState {}

class AddTransactionLoading extends AddTransactionState {}

class AddTransactionSuccess extends AddTransactionState {
  final String message;

  AddTransactionSuccess({required this.message});
}

class AddTransactionError extends AddTransactionState {
  final String message;

  AddTransactionError({required this.message});
}