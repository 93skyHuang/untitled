import 'dart:async';

import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

class HomeController extends GetxController {
  late final StreamSubscription nimEventSubscription;

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
