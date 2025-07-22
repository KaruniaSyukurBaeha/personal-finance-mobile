import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/category.dart';
import 'cubit/edit_category_cubit.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;
  const EditCategoryPage({super.key, required this.category});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  String? _type;
  final List<String> _options = ['income', 'expense'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category.name);
    _descCtrl = TextEditingController(text: widget.category.description ?? '');
    final raw = widget.category.type?.trim().toLowerCase();
    _type = _options.contains(raw) ? raw : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditCategoryCubit>(
      create: (_) => EditCategoryCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Kategori'),
          centerTitle: true,
        ),
        body: BlocConsumer<EditCategoryCubit, EditCategoryState>(
          listener: (ctx, state) {
            if (state is EditCategorySuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(ctx, true);
            }
            if (state is EditCategoryError) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (ctx, state) {
            final loading = state is EditCategoryLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Nama Kategori',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.category),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Wajib diisi' : null,
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
                                  v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _type ?? _options.first,
                              decoration: const InputDecoration(
                                labelText: 'Tipe Kategori',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.swap_vert),
                              ),
                              items: _options.map((opt) {
                                final label =
                                    '${opt[0].toUpperCase()}${opt.substring(1)}';
                                return DropdownMenuItem(
                                  value: opt,
                                  child: Text(label),
                                );
                              }).toList(),
                              onChanged: (v) => setState(() => _type = v),
                              validator: (v) =>
                                  v == null ? 'Pilih tipe kategori' : null,
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
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.check),
                        label: Text(loading ? 'Menyimpan...' : 'Update'),
                        onPressed: loading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate() &&
                                    _type != null) {
                                  ctx.read<EditCategoryCubit>().update(
                                        widget.category.id,
                                        _nameCtrl.text.trim(),
                                        _type!,
                                        _descCtrl.text.trim(),
                                      );
                                } else {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Mohon lengkapi semua field'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
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