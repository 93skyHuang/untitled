import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

String encryptedMD5(String data) {
  var content = const Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  return hex.encode(digest.bytes);
}
