import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pencatatan_keuangan/core/category_repository.dart';

part 'edit_category_state.dart';

class EditCategoryCubit extends Cubit<EditCategoryState> {
  final categoryRepository = CategoryRepository();

  EditCategoryCubit() : super(EditCategoryInitial());

  void update(
    int id,
    String name, 
    String type, 
    String description,
    // String createdAt,
    // String updatedAt,
    ) async {
    emit(EditCategoryLoading());
    try {
      final params = {
        "name": name, 
        "type": type, 
        "description": description,        
        // "created_at": createdAt,
        // "updated_at": updatedAt,
        };
      final result = await categoryRepository.update(
        id,
        params);

      emit(EditCategorySuccess(message: result.message));
    } on DioError catch (_) {
      emit(EditCategoryError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(EditCategoryError(message: e.toString()));
    }
  }
}
