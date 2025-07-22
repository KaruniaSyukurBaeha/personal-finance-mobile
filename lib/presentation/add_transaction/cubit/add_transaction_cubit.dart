import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:pencatatan_keuangan/core/transaction_repository.dart';

part 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final transactionRepository = TransactionRepository();

  AddTransactionCubit() : super(AddTransactionInitial());

  void submit(     
    String? entryType, 
    double amount,    
    int categoryId,  
    DateTime txnDate,
    String description,
    ) async {
    emit(AddTransactionLoading());
    try {
      final params = {        
        "entry_type": entryType, 
        "amount": amount,            
        "category_id": categoryId,
        "txn_date": DateFormat('yyyy-MM-dd').format(txnDate),
        "description": description, 
        };
      final result = await transactionRepository.create(params);

      emit(AddTransactionSuccess(message: result.message));
    } on DioError catch (_) {
      emit(AddTransactionError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(AddTransactionError(message: e.toString()));
    }
  }
}