import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
import 'package:pencatatan_keuangan/core/category_repository.dart';
import 'package:pencatatan_keuangan/data/category_response.dart';
import 'package:pencatatan_keuangan/data/model/category.dart';

part 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  CategoryRepository categoryRepository = CategoryRepository();

  CategoryListCubit() : super(CategoryListInitial()) {
    category();
  }

  void category() async {
    emit(CategoryListLoading());
    try {
      CategoryResponse result = await categoryRepository.index();
      debugPrint("Hasil ${result.categories.length}");
      emit(CategoryListLoaded(categories: result.categories));
    } on DioError {
      emit(CategoryListError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(CategoryListError(message: e.toString()));
    }
  }

  /// Menghapus item berdasarkan ID
  Future<void> delete(int id) async {
    try {
      emit(CategoryListLoading());
      await categoryRepository.delete(id);
      category(); // Refresh data
    } catch (e) {
      emit(CategoryListError(message: "Gagal menghapus data"));
    }
  }
}
