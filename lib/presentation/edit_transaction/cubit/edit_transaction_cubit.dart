import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:pencatatan_keuangan/core/transaction_repository.dart';

part 'edit_transaction_state.dart';

class EditTransactionCubit extends Cubit<EditTransactionState> {
  final transactionRepository = TransactionRepository();

  EditTransactionCubit() : super(EditTransactionInitial());

  void update(     
    int id,
    String? entryType, 
    double amount,    
    int categoryId,  
    DateTime txnDate,
    String description,
    ) async {
    emit(EditTransactionLoading());
    try {
      final params = {        
        "entry_type": entryType, 
        "amount": amount,            
        "category_id": categoryId,
        "txn_date": DateFormat('yyyy-MM-dd').format(txnDate),
        "description": description, 
        };
      final result = await transactionRepository.update(
        id,
        params);

      emit(EditTransactionSuccess(message: result.message));
    } on DioError catch (_) {
      emit(EditTransactionError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(EditTransactionError(message: e.toString()));
    }
  }
}
