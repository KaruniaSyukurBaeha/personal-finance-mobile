import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:pencatatan_keuangan/data/model/transaction.dart';
import 'package:pencatatan_keuangan/presentation/dashboard/cubit/dashboard_cubit.dart';
import 'package:pencatatan_keuangan/trasactions_index.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),        
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Karunia Syukur Baeha',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (ctx, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is DashboardLoaded) {
            final txns = state.transactions;
            final totalIncome = txns
                .where((t) => t.entryType == 'income')
                .fold<double>(0, (sum, t) => sum + t.amount);
            final totalExpense = txns
                .where((t) => t.entryType == 'expense')
                .fold<double>(0, (sum, t) => sum + t.amount);
            final balance = totalIncome - totalExpense;
            return _buildContent(ctx, txns, totalIncome, totalExpense, balance);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      List<Transaction> txns,
      double totalIncome,
      double totalExpense,
      double balance) {
    final f = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFmt = DateFormat.yMMMMd('id_ID');
    final summaryCard = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statItem('Income', totalIncome, Colors.green, f),
          _statItem('Expense', totalExpense, Colors.red, f),
          _statItem('Balance', balance, Colors.deepPurple, f),
        ],
      ),
    );

    final recent = txns.take(5).toList();
    final recentList = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaksi Terbaru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...recent.map((t) {
            final isInc = t.entryType == 'income';
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor:
                      isInc ? Colors.green[50] : Colors.red[50],
                  child: Icon(
                    isInc ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isInc ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(
                  t.description,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.categoryName,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFmt.format(t.txnDate),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                trailing: Text(
                  '${isInc ? '+' : '-'}${f.format(t.amount)}',
                  style: TextStyle(
                    color: isInc ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tileColor: Colors.white,
              ),
            );
          }).toList(),
          if (txns.length > 5)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00695C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionPage(title: 'Daftar Transaksi'),
                      ),
                    );
                  },
                  child: const Text(
                    'Lihat Semua Transaksi',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        summaryCard,
        recentList,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _statItem(
      String label, double value, Color color, NumberFormat f) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text(
          f.format(value),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}