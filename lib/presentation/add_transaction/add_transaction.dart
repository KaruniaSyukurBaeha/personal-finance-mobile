// lib/presentation/add_transaction/add_transaction.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'cubit/add_transaction_cubit.dart';
import '../category_list/cubit/category_list_cubit.dart';
import '../../data/model/category.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  String? _entryType;
  Category? _selectedCategory;
  DateTime? _pickedDate;
  final _amountCtrl = TextEditingController();
  final _descCtrl   = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _pickedDate = d);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTransactionCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Transaksi'),
          centerTitle: true,
        ),
        body: BlocConsumer<AddTransactionCubit, AddTransactionState>(
          listener: (ctx, state) {
            if (state is AddTransactionSuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Kembali ke halaman list, kirim true agar bisa refresh
              Navigator.pop(ctx, true);
            }
            if (state is AddTransactionError) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (ctx, state) {
            final loading = state is AddTransactionLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 1) Tipe Transaksi
                    DropdownButtonFormField<String>(
                      value: _entryType,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Transaksi',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.swap_vert),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'income',  child: Text('Income')),
                        DropdownMenuItem(value: 'expense', child: Text('Expense')),
                      ],
                      onChanged: (v) => setState(() => _entryType = v),
                      validator: (v) => v == null ? 'Pilih tipe' : null,
                    ),
                    const SizedBox(height: 16),

                    // 2) Nominal
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

                    // 3) Kategori
                    BlocBuilder<CategoryListCubit, CategoryListState>(
                      builder: (cctx, cstate) {
                        if (cstate is CategoryListLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (cstate is CategoryListLoaded) {
                          return DropdownButtonFormField<Category>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Kategori',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.category),
                            ),
                            items: cstate.categories.map((c) {
                              return DropdownMenuItem(value: c, child: Text(c.name));
                            }).toList(),
                            onChanged: (c) => setState(() => _selectedCategory = c),
                            validator: (_) =>
                                _selectedCategory == null ? 'Pilih kategori' : null,
                          );
                        }
                        return const Text('Gagal memuat kategori');
                      },
                    ),
                    const SizedBox(height: 16),

                    // 4) Tanggal
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
                              color:
                                  _pickedDate == null ? Colors.grey : Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 5) Deskripsi
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
                    const SizedBox(height: 24),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          loading ? 'Menyimpan...' : 'Simpan Transaksi',
                        ),
                        onPressed: loading
                            ? null
                            : () {
                                // 1) Validasi form
                                if (!_formKey.currentState!.validate()) return;

                                // 2) Pastikan dropdown + tanggal tidak kosong
                                if (_entryType == null ||
                                    _selectedCategory == null ||
                                    _pickedDate == null) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Mohon lengkapi semua field'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                // 3) Panggil cubit dengan argumen yang tepat
                                ctx.read<AddTransactionCubit>().submit(
                                      _entryType!,
                                      double.parse(_amountCtrl.text.trim()),
                                      _selectedCategory!.id,
                                      _pickedDate!,
                                      _descCtrl.text.trim(),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
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