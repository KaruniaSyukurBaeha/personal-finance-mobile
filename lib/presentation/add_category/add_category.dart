import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/add_category_cubit.dart'; 

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? type;
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kategori"),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => AddCategoryCubit(),
        child: BlocConsumer<AddCategoryCubit, AddCategoryState>(
          listener: (ctx, state) {
            if (state is AddCategorySuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              Navigator.pop(ctx, true);
            }
            if (state is AddCategoryError) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (ctx, state) {
            final loading = state is AddCategoryLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nama Kategori',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.category),
                              ),
                              validator: (v) => v == null || v.isEmpty ? 'Field ini wajib diisi' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Deskripsi',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.notes),
                              ),
                              maxLines: 2,
                              validator: (v) => v == null || v.isEmpty ? 'Field ini wajib diisi' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: type,
                              decoration: const InputDecoration(
                                labelText: 'Tipe Kategori',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.swap_vert),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'income', child: Text('Income')),
                                DropdownMenuItem(value: 'expense', child: Text('Expense')),
                              ],
                              onChanged: (v) => setState(() => type = v),
                              validator: (v) => v == null ? 'Pilih tipe kategori' : null,
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
                              width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save),
                        label: Text(loading ? 'Menyimpan...' : 'Simpan Kategori'),
                        onPressed: loading 
                          ? null 
                          : () {
                              if (_formKey.currentState!.validate()) {
                                ctx.read<AddCategoryCubit>().submit(
                                  nameController.text.trim(),
                                  type!,
                                  descriptionController.text.trim(),                                  
                                );
                              }
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
