import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pencatatan_keuangan/presentation/add_transaction/add_transaction.dart';
import 'package:pencatatan_keuangan/presentation/edit_transaction/edit_transaction.dart';
import 'package:pencatatan_keuangan/presentation/transaction_list/cubit/transaction_list_cubit.dart';
import '../../data/model/transaction.dart';

enum _Action { edit, delete }

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key, required this.title});
  final String title;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int _filterType = 0;
  DateTimeRange? _dateRange;

  bool _matchesFilter(Transaction t) {
    if (_filterType == 1 && t.entryType != 'income') return false;
    if (_filterType == 2 && t.entryType != 'expense') return false;
    if (_dateRange != null) {
      if (t.txnDate.isBefore(_dateRange!.start) ||
          t.txnDate.isAfter(_dateRange!.end)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _dateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  void _clearDateFilter() {
    setState(() => _dateRange = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: _filterType == 0,
                  onSelected: (_) => setState(() {
                    _filterType = 0;
                    _dateRange = null;  
                  }),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _filterType == 1,
                  onSelected: (_) => setState(() {
                    _filterType = 1;
                  }),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: _filterType == 2,
                  onSelected: (_) => setState(() {
                    _filterType = 2;
                  }),
                ),

                const SizedBox(width: 16),

                if (_dateRange != null) ...[
                  Chip(
                    label: Text(
                      '${DateFormat.yMd().format(_dateRange!.start)} – '
                      '${DateFormat.yMd().format(_dateRange!.end)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    deleteIcon: const Icon(Icons.clear, size: 18),
                    onDeleted: _clearDateFilter,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 12),
                ],

                IconButton(
                  icon: const Icon(Icons.date_range),
                  tooltip: 'Filter Tanggal',
                  onPressed: _pickDateRange,
                  constraints: const BoxConstraints.tightFor(
                    width: 36, height: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          if (state is TransactionListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TransactionListError) {
            return Center(child: Text(state.message));
          }
          if (state is TransactionListLoaded) {
            final filtered = state.transactions.where(_matchesFilter).toList();
            if (filtered.isEmpty) {
              return const Center(child: Text('Tidak ada transaksi.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final t = filtered[i];
                final isInc = t.entryType == 'income';
                final dateStr =
                    DateFormat.yMMMMd('id_ID').format(t.txnDate);
                final amtStr = NumberFormat.currency(
                  locale: 'id_ID', symbol: 'Rp ',
                ).format(t.amount);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.categoryName),
                        const SizedBox(height: 4),
                        Text(dateStr,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          amtStr,
                          style: TextStyle(
                            color: isInc
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<_Action>(
                          onSelected: (action) async {
                            switch (action) {
                              case _Action.edit:
                                final ok = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditTransactionPage(
                                            transaction: t),
                                  ),
                                );
                                if (ok == true) {
                                  context
                                      .read<TransactionListCubit>()
                                      .transaction();
                                }
                                break;
                              case _Action.delete:
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title:
                                        const Text('Konfirmasi Hapus'),
                                    content: const Text(
                                        'Yakin ingin menghapus transaksi ini?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                  context, false),
                                          child: const Text('Batal')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                  context, true),
                                          child: const Text('Hapus')),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await context
                                      .read<TransactionListCubit>()
                                      .delete(t.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Transaksi "${t.description}" dihapus'),
                                      backgroundColor: Colors.green,
                                    ));
                                  }
                                }
                                break;
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: _Action.edit,
                              child: ListTile(
                                leading:
                                    Icon(Icons.edit, color: Colors.blue),
                                title: Text('Edit'),
                              ),
                            ),
                            PopupMenuItem(
                              value: _Action.delete,
                              child: ListTile(
                                leading:
                                    Icon(Icons.delete, color: Colors.red),
                                title: Text('Hapus'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: () async {
            final added = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddTransactionPage()),
            );
            if (added == true) {
              context.read<TransactionListCubit>().transaction();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}