import 'package:dio/dio.dart';

class DioHelper{
   static late Dio dio ;
   static init(){
    dio=Dio(
      BaseOptions(
        receiveTimeout: 100000,
        connectTimeout: 100000,
        baseUrl: 'https://newsapi.org/',
          receiveDataWhenStatusError: true,
      )
    );
   }
  static Future<Response> getData({
  required String url,
    required Map<String,dynamic> query
})async
  {
    return Future.delayed(const Duration(milliseconds: 1000), () =>
      dio.get(url,queryParameters: query,));
  }
}