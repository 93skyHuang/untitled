import 'dart:io';

import 'package:nim_core/nim_core.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

void nimSdkInit() async {
  NIMLoginInfo? auto;
  int uid = GetStorageUtils.getUID();
  logger.i("$uid nimSdkInit=$nimSdkInit");
  if (uid != -1) {
    String token = GetStorageUtils.getNimToken();
    String account = "ll$uid";
    auto = NIMLoginInfo(
      account: account,
      token: token,
    );
    logger.i("云信自动登录$auto");
  }

  final options = Platform.isAndroid
      ? NIMAndroidSDKOptions(
          appKey: 'a43f20db62b5b8d8debdb207e01cdb47',

          /// 其他 通用/Android 配置
          autoLoginInfo: auto)
      : NIMIOSSDKOptions(
          appKey: 'a43f20db62b5b8d8debdb207e01cdb47', autoLoginInfo: auto,

          /// 其他通用配置/iOS 配置
        );
  NimCore.instance.initialize(options).then((result) {
    if (result.isSuccess) {
      logger.i('云信 initialize isSuccess info=$auto');
    } else {
      logger.e('云信initialize 失败info=$auto      '
          'errorDetails${result.errorDetails}'
          'result.code${result.code}');
    }
  });
}
