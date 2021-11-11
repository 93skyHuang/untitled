import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/page/login/add_basic_info.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widgets/toast.dart';

class LoginController extends GetxController {
  RxBool isSendSmsCode = false.obs;

  void getSmsCode(String phone) {
    if (!GetUtils.isPhoneNumber(phone)) {
      MyToast.show('请输入正确的手机号码');
      return;
    }
    getPhoneSms(phone).then((value) =>
        {if (value.isOk()) getSmsCodeSuccess() else MyToast.show(value.msg)});
  }

  void login(String phone, String code) {
    if (!GetUtils.isPhoneNumber(phone)) {
      MyToast.show('请输入正确的手机号码');
      return;
    }
    phoneLogin(phone, code).then((value) => {
          if (value.isOk())
            {
              if (value.data?.isNewUser == 1||value.data?.sex==0)
                {
                  Get.offNamed(addBasicInfoPName),
                  GetStorageUtils.saveIsShowVerifiedTipsInHomePage(true)
                }
              else
                Get.offNamed(homePName)
            }
          else
            MyToast.show(value.msg)
        });
  }

  void getSmsCodeSuccess() {
    isSendSmsCode.value = true;
    Future.delayed(const Duration(seconds: 30)).then((value) => {
          logger.i('delayed message $isClose'),
          if (!isClose)
            if (isSendSmsCode.value) {isSendSmsCode.value = false}
        });
  }

  @override
  void onInit() {
    logger.i("onInit");
  }

  bool isClose = false;

  @override
  void onClose() {
    isClose = true;
    logger.i("onClose");
  }

  @override
  void onReady() {
    logger.i("onReady");
  }
}
