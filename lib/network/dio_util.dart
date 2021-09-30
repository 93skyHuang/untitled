import 'package:dio/dio.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/network/rsa_interceptors.dart';

import 'bean/user_info.dart';

var _dio;

Dio getDio() {
  if(_dio==null){
    _dio = Dio();
    _dio.interceptors.add(EncryptionAndDecryptionInterceptors());
    _dio.options = BaseOptions(
      baseUrl: "http://www.sancun.vip",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
  }
  return _dio;
}
