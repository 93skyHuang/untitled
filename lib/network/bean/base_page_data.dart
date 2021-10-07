import 'package:untitled/constant/error_code.dart';

class BasePageData<T> {
  BasePageData(this.code, this.msg, this.data);

  int code = 100;
  String msg = '';
  T? data;

  bool isOk() {
    return code == respCodeSuccess;
  }

  @override
  String toString() {
    return 'BasePageData {code=$code  msg=$msg  data=${data.toString()}}';
  }
}
