import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pencatatan_keuangan/core/category_repository.dart';

part 'add_category_state.dart';

class AddCategoryCubit extends Cubit<AddCategoryState> {
  final categoryRepository = CategoryRepository();

  AddCategoryCubit() : super(AddCategoryInitial());

  void submit(
    String name, 
    String type, 
    String description,
    // String createdAt,
    // String updatedAt,
    ) async {
    emit(AddCategoryLoading());
    try {
      final params = {
        "name": name, 
        "type": type, 
        "description": description,        
        // "created_at": createdAt,
        // "updated_at": updatedAt,
        };
      final result = await categoryRepository.create(params);

      emit(AddCategorySuccess(message: result.message));
    } on DioError catch (_) {
      emit(AddCategoryError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(AddCategoryError(message: e.toString()));
    }
  }
}