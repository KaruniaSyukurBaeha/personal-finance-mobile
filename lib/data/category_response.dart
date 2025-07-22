import 'package:pencatatan_keuangan/data/model/category.dart';

class CategoryResponse {
  final List<Category> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(List<dynamic> json) {
    List<Category> categories = [];
    for (int i = 0; i < json.length; i++) {
      Category type = Category.fromJson(json[i]);
      categories.add(type);
    }
    return CategoryResponse(categories: categories);
  }
}