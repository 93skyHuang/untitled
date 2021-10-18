import 'package:dio/dio.dart';
import 'package:untitled/network/rsa_interceptors.dart';

var _dio;
var _noEncryptionDio;

Dio getDio() {
  if (_dio == null) {
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

//无加密Dio
Dio getNoEncryptionDio() {
  if (_noEncryptionDio == null) {
    _noEncryptionDio = Dio();
    _noEncryptionDio.interceptors.add(DecryptionInterceptors());
    _noEncryptionDio.options = BaseOptions(
      baseUrl: "http://www.sancun.vip",
      connectTimeout: 10000,
      sendTimeout: 50000,
      receiveTimeout: 8000,
    );
  }
  return _noEncryptionDio;
}
