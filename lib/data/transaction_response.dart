import 'package:pencatatan_keuangan/data/model/transaction.dart';

class TransactionResponse {
  final List<Transaction> transactions;

  TransactionResponse({required this.transactions});

  factory TransactionResponse.fromJson(List<dynamic> json) {
    List<Transaction> transactions = [];
    for (int i = 0; i < json.length; i++) {
      Transaction type = Transaction.fromJson(json[i]);
      transactions.add(type);
    }
    return TransactionResponse(transactions: transactions);
  }
}