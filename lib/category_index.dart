import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pencatatan_keuangan/presentation/add_category/add_category.dart';
import 'package:pencatatan_keuangan/presentation/edit_category/edit_category.dart';
import 'package:pencatatan_keuangan/presentation/category_list/cubit/category_list_cubit.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.title});
  final String title;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Karunia Syukur Baeha",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black54, fontSize: 14),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CategoryListCubit, CategoryListState>(
        builder: (context, state) {
          if (state is CategoryListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryListError) {
            return Center(child: Text(state.message));
          }
          if (state is CategoryListLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  final isIncome = category.type?.toLowerCase() == 'income';
                  final chipColor =
                      isIncome ? Colors.green.shade100 : Colors.red.shade100;
                  final textColor = isIncome ? Colors.green.shade800 : Colors.red.shade800;
                  final icon = isIncome ? Icons.arrow_circle_down : Icons.arrow_circle_up;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, color: textColor, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Chip(
                                  backgroundColor: chipColor,
                                  label: Text(
                                    isIncome ? 'Income' : 'Expense',
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  category.description?.isNotEmpty == true
                                      ? category.description!
                                      : '-',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),

                          PopupMenuButton<_Action>(
                            onSelected: (action) async {
                              if (action == _Action.edit) {
                                final updated = await Navigator.push<bool?>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditCategoryPage(category: category),
                                  ),
                                );
                                if (updated == true) {
                                  context.read<CategoryListCubit>().category();
                                }
                              } 
                              if (action == _Action.delete) {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Konfirmasi Hapus"),
                                    content: const Text("Yakin ingin menghapus kategori ini?"),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
                                      TextButton(onPressed: () => Navigator.pop(context, true),  child: const Text("Hapus")),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  final messenger = ScaffoldMessenger.of(context);
                                  await context.read<CategoryListCubit>().delete(category.id);
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text('Kategori "${category.name}" berhasil dihapus'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: _Action.edit,
                                child: ListTile(
                                  leading: Icon(Icons.edit, color: Colors.blue),
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
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddCategoryPage()),
          );
          if (added == true) {
            context.read<CategoryListCubit>().category();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum _Action { edit, delete }