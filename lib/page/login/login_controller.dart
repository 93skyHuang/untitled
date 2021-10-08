import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/sp_util.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widgets/toast.dart';

class LoginController extends GetxController {
  RxBool isSendSmsCode = false.obs;

  void getSmsCode(String phone) {
    if (!GetUtils.isPhoneNumber(phone)) {
      MyToast.show('请输入正确的手机号码');
      return;
    }
    getPhoneSms(phone).then((value) => {
          if (value.isOk())
            isSendSmsCode.value = true
          else
            MyToast.show(value.msg)
        });
  }

  void login(String phone, String code) {
    if (!GetUtils.isPhoneNumber(phone)) {
      MyToast.show('请输入正确的手机号码');
      return;
    }
    phoneLogin(phone, code).then((value) => {
          if (value.isOk())
            {
              SPUtils.saveUid(value.data?.uid),
              Get.offNamed(homePName)}
          else
            MyToast.show(value.msg)
        });
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
