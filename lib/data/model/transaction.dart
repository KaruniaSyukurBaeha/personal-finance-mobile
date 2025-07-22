// lib/data/model/transaction.dart

class Transaction {
  final int id;
  final String? entryType;
  final double amount;
  final int categoryId;
  final String categoryName;
  final DateTime txnDate;     // hanya Y-M-D, tanpa waktu/zona
  final String description;
  final DateTime createdAt;   // Anda bisa keep toLocal jika perlu show waktu
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.entryType,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.txnDate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // 1) Ambil raw string
    final rawDate = json["txn_date"] as String;

    // 2) Ekstrak bagian sebelum 'T' (YYYY-MM-DD)
    final dateOnly = rawDate.split('T').first;

    // 3) Parse menjadi DateTime lokal pada midnight
    final txnDate = DateTime.parse(dateOnly);

    // createdAt/updatedAt: parse ISO dan convert ke lokal bila ingin waktu yang benar
    final createdAt = DateTime.parse(json["created_at"] as String).toLocal();
    final updatedAt = DateTime.parse(json["updated_at"] as String).toLocal();

    return Transaction(
      id: json["id"] as int,
      entryType: json["entry_type"] as String?,
      amount: (json["amount"] as num).toDouble(),
      categoryId: json["category_id"] as int,
      categoryName: json['category_name'] as String,
      txnDate: txnDate,
      description: json["description"] as String,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}