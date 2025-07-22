import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pencatatan_keuangan/core/transaction_repository.dart';
import 'package:pencatatan_keuangan/data/model/transaction.dart';
import 'package:pencatatan_keuangan/data/transaction_response.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  TransactionRepository transactionRepository = TransactionRepository();

  DashboardCubit() : super(DashboardInitial()) {
    transaction();
  }

  void transaction() async {
    emit(DashboardLoading());
    try {
      TransactionResponse result = await transactionRepository.index();
      debugPrint("Hasil ${result.transactions.length}");
      emit(DashboardLoaded(transactions: result.transactions));
    } on DioError {
      emit(DashboardError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> delete(int id) async {
    try {
      emit(DashboardLoading());
      await transactionRepository.delete(id);
      transaction(); 
    } catch (e) {
      emit(DashboardError(message: "Gagal menghapus data"));
    }
  }
}
