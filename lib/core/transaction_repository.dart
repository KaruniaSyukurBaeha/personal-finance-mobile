// import 'package:dio/dio.dart';
import 'package:pencatatan_keuangan/core/dio_client.dart';
import 'package:pencatatan_keuangan/data/create_response.dart';
import 'package:pencatatan_keuangan/data/edit_response.dart';
import 'package:pencatatan_keuangan/data/transaction_response.dart';


class TransactionRepository extends DioClient{
  Future<CreateResponse> create(Map<String, dynamic> params) async {
    var response = await dio.post("transaction", data: params);
    // return CreateResponse.fromJson(response.data); //asli
    final json = response.data as Map<String, dynamic>;
    return CreateResponse(
      message: json['message'] as String,  // <-- grab the String      
    );
  }

  Future<TransactionResponse> index() async {
    var response = await dio.get("transaction");
    return TransactionResponse.fromJson(response.data);
  }

  Future<TransactionResponse> fetchIncome() async {
    final response = await dio.get("income");
    return TransactionResponse.fromJson(response.data);
  }
  
  Future<TransactionResponse> fetchExpense() async {
    final response = await dio.get("expense");
    return TransactionResponse.fromJson(response.data);
  }

  Future<EditResponse> update(int id, Map<String, dynamic> data) async{
    final response = await dio.put("transaction/$id", data: data);
    // return BaseResponse.fromJson(response.data);
    // return EditResponse(message: response.data, status: true);
    final json = response.data as Map<String, dynamic>;
    return EditResponse(
      message: json['message'] as String, 
      status: true,
    );
  }

  Future<void> delete(int id) async {
    await dio.delete("transaction/$id");
  }
}

