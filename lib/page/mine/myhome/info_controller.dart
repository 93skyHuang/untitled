import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/user_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';

class InfoController extends GetxController {
  Rx<UserInfo> userInfo = UserInfo().obs;

  @override
  void onInit() {
    logger.i("MyHomeControllerInit");
    getInfo();
  }

  void getInfo() {
    getUserInfo().then((value) => {userInfo.value = value.data!});
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
