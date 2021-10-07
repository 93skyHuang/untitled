import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';

class LoginController extends GetxController {
  RxBool isSendSmsCode = false.obs;

  void getSmsCode(String phone) {
    getPhoneSms(phone).then((value) => {
          if (value.isOk()) {isSendSmsCode.value = true} else {}
        });
  }

  void login(String phone, String code) {
    phoneLogin(phone, code).then((value) => {});
  }

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
