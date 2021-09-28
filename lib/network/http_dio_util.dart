import 'package:dio/dio.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: "https://www.xxxx/api",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

var _dio;

Dio getDio() {
  if (_dio ??= null) {
    _dio = Dio(baseOptions);
  }
  return _dio;
}
