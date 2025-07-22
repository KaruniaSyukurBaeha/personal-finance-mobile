import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/model/category.dart';
import '../../data/model/transaction.dart';
import '../category_list/cubit/category_list_cubit.dart';
import 'cubit/edit_transaction_cubit.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction transaction;
  const EditTransactionPage({super.key, required this.transaction});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  String? _entryType;
  Category? _selectedCategory;
  DateTime? _pickedDate;
  late TextEditingController _amountCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _entryType = widget.transaction.entryType;
    _pickedDate = widget.transaction.txnDate;
    _amountCtrl = TextEditingController(text: widget.transaction.amount.toString());
    _descCtrl   = TextEditingController(text: widget.transaction.description);

    context.read<CategoryListCubit>().category();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _pickedDate = d);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditTransactionCubit>(
      create: (_) => EditTransactionCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Transaksi'),
          centerTitle: true,
        ),
        body: BlocConsumer<EditTransactionCubit, EditTransactionState>(
          listener: (ctx, state) {
            if (state is EditTransactionSuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              Navigator.pop(ctx, true);
            }
            if (state is EditTransactionError) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (ctx, state) {
            final loading = state is EditTransactionLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _entryType,
                              decoration: const InputDecoration(
                                labelText: 'Tipe Transaksi',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.swap_vert),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'income', child: Text('Income')),
                                DropdownMenuItem(value: 'expense', child: Text('Expense')),
                              ],
                              onChanged: (v) => setState(() => _entryType = v),
                              validator: (v) => v == null ? 'Pilih tipe' : null,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _amountCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Nominal',
                                prefixText: 'Rp ',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Masukkan nominal' : null,
                            ),
                            const SizedBox(height: 16),

                            BlocBuilder<CategoryListCubit, CategoryListState>(
                              builder: (cctx, cstate) {
                                if (cstate is CategoryListLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (cstate is CategoryListLoaded) {
                                  _selectedCategory ??=
                                      cstate.categories.firstWhere((c) => c.id == widget.transaction.categoryId);
                                  return DropdownButtonFormField<Category>(
                                    value: _selectedCategory,
                                    decoration: const InputDecoration(
                                      labelText: 'Kategori',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.category),
                                    ),
                                    items: cstate.categories.map((c) =>
                                      DropdownMenuItem(value: c, child: Text(c.name))
                                    ).toList(),
                                    onChanged: (c) => setState(() => _selectedCategory = c),
                                    validator: (_) => _selectedCategory == null ? 'Pilih kategori' : null,
                                  );
                                }
                                return const Text('Gagal memuat kategori');
                              },
                            ),
                            const SizedBox(height: 16),

                            GestureDetector(
                              onTap: _pickDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Tanggal',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _pickedDate == null
                                      ? 'Pilih Tanggal'
                                      : DateFormat.yMMMMd('id_ID').format(_pickedDate!),
                                  style: TextStyle(
                                    color: _pickedDate == null ? Colors.grey[600] : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _descCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Deskripsi',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.notes),
                              ),
                              maxLines: 2,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Masukkan deskripsi' : null,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: loading
                            ? const SizedBox(
                                width: 24, height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.check),
                        label: Text(loading ? 'Menyimpan...' : 'Update Transaksi'),
                        onPressed: loading
                            ? null
                            : () {
                                if (!_formKey.currentState!.validate()) return;
                                if (_entryType == null || _selectedCategory == null || _pickedDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Mohon lengkapi semua field'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }
                                ctx.read<EditTransactionCubit>().update(
                                  widget.transaction.id,
                                  _entryType!,
                                  double.parse(_amountCtrl.text.trim()),
                                  _selectedCategory!.id,
                                  _pickedDate!,
                                  _descCtrl.text.trim(),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}