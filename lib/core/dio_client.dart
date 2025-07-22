import 'package:dio/dio.dart';

class DioClient {
  late Dio dio;

  DioClient(){
    dio = Dio();
    dio.options.baseUrl = "http://your-url:5000/";    
    dio.options.contentType = "application/json";
  }
}