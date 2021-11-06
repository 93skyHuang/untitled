import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/user_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/widget/loading.dart';

class EditUserInfoController extends GetxController {
  Rx<UserInfo> userInfo = UserInfo().obs;
  RxList hobby = [].obs;

  @override
  void onInit() {
    super.onInit();
    logger.i("EditUserInfoController");
    getInfo();
    getHobbyList();
  }

  void getInfo() {
    getUserInfo().then((value) => {userInfo.value = value.data!});
  }

  void getHobbyList() {
    getHobby().then((value) => {hobby.value = value.data!});
  }

  void setUser(BuildContext context) {
    Loading.show(context);
    updateUserData(
            expectAge: userInfo.value.expectAge,
            expectHeight: userInfo.value.expectHeight,
            hobby: userInfo.value.hobby,
            expectRegion: userInfo.value.expectRegion,
            expectConstellation: userInfo.value.expectConstellation,
            expectType: userInfo.value.expectType)
        .then((value) => {
          Loading.dismiss(context),
              if (value.isOk()) {Get.back()}
            });
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
