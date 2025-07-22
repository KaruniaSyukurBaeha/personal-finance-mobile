import 'package:pencatatan_keuangan/core/dio_client.dart';
import 'package:pencatatan_keuangan/data/category_response.dart';
import 'package:pencatatan_keuangan/data/create_response.dart';
import 'package:pencatatan_keuangan/data/edit_response.dart';


class CategoryRepository extends DioClient{
  Future<CreateResponse> create(Map<String, dynamic> params) async {
    var response = await dio.post("category", data: params);
    return CreateResponse.fromJson(response.data);
  }

  Future<CategoryResponse> index() async {
    var response = await dio.get("category");
    return CategoryResponse.fromJson(response.data);
  }

  Future<EditResponse> update(int id, Map<String, dynamic> data) async{
    final response = await dio.put("category/$id", data: data);
    // return BaseResponse.fromJson(response.data);
    // return EditResponse(message: response.data, status: true);    
    final json = response.data as Map<String, dynamic>;
    return EditResponse(
      message: json['message'] as String,  // <-- grab the String
      status: true,
    );
  }

  Future<void> delete(int id) async {
    await dio.delete("category/$id");
  }
}