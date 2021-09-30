import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'dart:convert';

import 'package:untitled/network/logger.dart';

String publicKeyStr = '';
String privateStr = '';

loadKey() async {
  if (publicKeyStr.isEmpty || publicKeyStr.isEmpty) {
    publicKeyStr = await rootBundle.loadString('assets/rsa/public.pem');
    privateStr = await rootBundle.loadString('assets/rsa/private.pem');
  }
}

//加密
Future<String> rsaEncrypted(String content) async {
  if (content == null || content.isEmpty) {
    return '';
  }
  await loadKey();
  logger.i('content==$content');
  var publicKey = RSAKeyParser().parse(publicKeyStr) as RSAPublicKey;
  // var privateKey = RSAKeyParser().parse(privateStr) as RSAPrivateKey;
  final enrcypter = Encrypter(RSA(publicKey: publicKey));
  // enrcypter.encrypt(content).base64;
  List<int> sourceBytes = utf8.encode(content);
  int inputLen = sourceBytes.length;
  int maxLen = 117;
  List<int> totalBytes = [];
  for (var i = 0; i < inputLen; i += maxLen) {
    int endLen = inputLen - i;
    List<int> item;
    if (endLen > maxLen) {
      item = sourceBytes.sublist(i, i + maxLen);
    } else {
      item = sourceBytes.sublist(i, i + endLen);
    }
    totalBytes.addAll(enrcypter.encryptBytes(item).bytes);
  }
  return base64.encode(totalBytes); //加密后内容可以在线解析或者自行解析
}

//解密
Future<String> rsaDecrypted(String content) async {
  var privateKey = RSAKeyParser().parse(privateStr) as RSAPrivateKey;
  final encrypt = Encrypter(RSA(privateKey: privateKey));
  Uint8List sourceBytes = base64.decode(content);
  int inputLen = sourceBytes.length;
  int maxLen = 128;
  List<int> totalBytes = [];
  for (var i = 0; i < inputLen; i += maxLen) {
    int endLen = inputLen - i;
    Uint8List item;
    if (endLen > maxLen) {
      item = sourceBytes.sublist(i, i + maxLen);
    } else {
      item = sourceBytes.sublist(i, i + endLen);
    }
    totalBytes.addAll(encrypt.decryptBytes(Encrypted(item)));
  }
  return utf8.decode(totalBytes);
}
