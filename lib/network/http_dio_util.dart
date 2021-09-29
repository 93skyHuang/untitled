import 'dart:math';

import 'package:dio/dio.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/network/rsa_interceptors.dart';
import 'package:untitled/network/rsa_util.dart';

import 'md5_util.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: "http://www.sancun.vip",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

var dio = Dio();

Dio _getDio() {
  dio.interceptors.add(EncryptionAndDecryptionInterceptors());
  dio.options = baseOptions;
  return dio;
}

Future test2() async {
  final dio = Dio();
  dio.options.baseUrl = 'https://www.wanandroid.com';
  try {
    Response r = await dio.get("/banner/json");
    logger.i('$r');
  } catch (error) {
    logger.e('message $error');
  }
}

Future test() async {
  try {
    logger.i("message test");
    _getDio().post('/index/User/getUserInfo', data: {'uid': 105324});
  } on DioError catch (error) {
    throw error;
  }
}
