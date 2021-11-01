import 'dart:async';

import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/dialog.dart';

import '../route_config.dart';

class HomeController extends GetxController {
  late final StreamSubscription nimEventSubscription;

  void nimEventListener() {
    nimEventSubscription =
        NimCore.instance.authService.authStatus.listen((event) {
      if (event is NIMKickOutByOtherClientEvent) {
        logger.e('监听到被踢事件${event.status}');
        if (getApplication() != null) {
          NimNetworkManager.instance.logout();
          showKickOutByOtherClientDialog(getApplication()!);
        }
        /// 监听到被踢事件
      } else if (event is NIMAuthStatusEvent) {
        /// 监听到其他事件
        logger.e(event.status);
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
