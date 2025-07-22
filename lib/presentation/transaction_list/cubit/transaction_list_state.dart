part of 'transaction_list_cubit.dart';

@immutable
sealed class TransactionListState {}

final class TransactionListInitial extends TransactionListState {}

final class TransactionListLoaded extends TransactionListState {
  final List<Transaction> transactions;
  TransactionListLoaded({required this.transactions});
}

class TransactionListError extends TransactionListState {
  final String message;
  TransactionListError({required this.message});
}

class TransactionListLoading extends TransactionListState {}
