import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/find_tab_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

/**
 * 消息控制
 */
class MessagesController extends GetxController {
  RxString newSystemMsg = ''.obs;
  RxString newSystemMsgTime = '11111'.obs;
  RxBool isCanChat = false.obs;

  @override
  void onInit() {
    logger.i("onInit");

  }

  @override
  void onClose() {
    logger.i("onClose");
  }

  @override
  void onReady() {
    logger.i("onReady");
  }
}
