import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
import 'package:pencatatan_keuangan/core/transaction_repository.dart';
import 'package:pencatatan_keuangan/data/model/transaction.dart';
import 'package:pencatatan_keuangan/data/transaction_response.dart';

part 'transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  TransactionRepository transactionRepository = TransactionRepository();

  TransactionListCubit() : super(TransactionListInitial()) {
    transaction();
  }

  void transaction() async {
    emit(TransactionListLoading());
    try {
      TransactionResponse result = await transactionRepository.index();
      debugPrint("Hasil ${result.transactions.length}");
      emit(TransactionListLoaded(transactions: result.transactions));
    } on DioError {
      emit(TransactionListError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(TransactionListError(message: e.toString()));
    }
  }

  /// Menghapus item berdasarkan ID
  Future<void> delete(int id) async {
    try {
      emit(TransactionListLoading());
      await transactionRepository.delete(id);
      transaction(); 
    } catch (e) {
      emit(TransactionListError(message: "Gagal menghapus data"));
    }
  }
}
