import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';

class VipController extends GetxController {

  @override
  void onInit() {
      getPayList().then((value) => {
        logger.i(
            '终1111于${value.toString()} ---${value.isOk()}') });
    logger.i("VipControlleronInit");
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
