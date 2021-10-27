import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:untitled/constant/error_code.dart';
import 'package:untitled/network/rsa_util.dart';
import 'logger.dart';
import 'dart:math';

import 'md5_util.dart';

/**
 * 加解密拦截器
 */
class EncryptionAndDecryptionInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i(
        '《===== REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path} '
        '=> body:${options.data}');
    final data = options.data;
    final random = getRandomOf8();
    const clientId = '85694257';
    String dataStr = json.encode(data);
    // logger.i(dataStr);
    String encryptedStr;
    rsaEncrypted(dataStr).then((dataEn) => {
          encryptedStr = '$clientId$dataEn$random',
          options.data = {
            "random": random,
            "sign": signHandler(encryptedStr),
            "data": dataEn
          },
          logger.i('--- ${options.data.toString()}---'),
          handler.next(options)
        });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
        '======》RESPONSE statusCode=[${response.statusCode}] => PATH: ${response.realUri}'
        '  =》body: ${response.toString()}');
    if (response.statusCode == 200) {
      response.data = json.decode(response.data);
      if (response.data['code'] == respCodeSuccess) {
        rsaDecrypted(response.data['data'])
            .then((value) => {
                  logger.i(value),
                  if (value.isEmpty)
                    response.data['data'] = null
                  else
                    response.data['data'] = json.decode(value),
                })
            .whenComplete(() => {
                  handler.next(response),
                });
      } else {
        handler.next(response);
      }
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e(
        'ERROR[${err.response}] => PATH: ${err.requestOptions.baseUrl}${err.requestOptions.path}');
    handler.next(err);
  }

  String getRandomOf8() {
    String scopeF = '123456789'; //首位
    String scopeC = '0123456789'; //中间]
    String result = '';
    for (int i = 0; i < 8; i++) {
      if (i == 0) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return result;
  }

  /**
   * sign 处理
   */
  String signHandler(String sign) {
    sign = encryptedMD5(sign);
    if (sign.isNotEmpty && sign.length > 32) {
      sign = sign.substring(0, 32);
    }
    return sign.toUpperCase();
  }
}

/**
 * 解密拦截器
 */

class DecryptionInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i(
        '《===== REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path} '
            '=> body:${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
        '======》RESPONSE statusCode=[${response.statusCode}] => PATH: ${response.realUri}'
        '  =》body: ${response.toString()}');
    if (response.statusCode == 200) {
      response.data = json.decode(response.data);
      if (response.data['code'] == respCodeSuccess) {
        rsaDecrypted(response.data['data'])
            .then((value) => {
                  logger.i(value),
                  if (value.isEmpty)
                    response.data['data'] = null
                  else
                    response.data['data'] = json.decode(value),
                })
            .whenComplete(() => {
                  logger.i('======》Decrypted RESPONSE :${response.toString()}'),
                  handler.next(response),
                });
      } else {
        handler.next(response);
      }
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e(
        'ERROR[${err.response}] => PATH: ${err.requestOptions.baseUrl}${err.requestOptions.path}');
    handler.next(err);
  }
}
