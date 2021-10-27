import 'dart:async';

import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

class HomeController extends GetxController {
  late final StreamSubscription nimEventSubscription;

  RxBool isSvip = GetStorageUtils.getSvip().obs;

  //unknown	未定义
  // unLogin	未登录/登录失败
  // netBroken	网络连接已断开
  // connecting	正在连接服务器
  // logging	正在登录中
  // loggedIn	已成功登录
  // kickOut	被其他端的登录踢掉，此时应该跳转至手动登录界面
  // kickOutByOtherClient	被同时在线的其他端主动踢掉，此时应该跳转至手动登录界面
  // forbidden	被服务器禁止登录
  // versionError	客户端版本错误
  // pwdError	用户名或密码错误

  void nimEventListener() {
    nimEventSubscription =
        NimCore.instance.authService.authStatus.listen((event) {
      if (event is NIMKickOutByOtherClientEvent) {
        logger.i('监听到被踢事件');

        /// 监听到被踢事件
      } else if (event is NIMAuthStatusEvent) {
        /// 监听到其他事件
        logger.i(event);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    logger.i("onInit");
  }

  @override
  void onClose() {
    logger.i("onClose");
    nimEventSubscription.cancel();
  }

  @override
  void onReady() {
    logger.i("onReady");
    nimEventListener();
  }
}
