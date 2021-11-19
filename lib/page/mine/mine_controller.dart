import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:logger/logger.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

class MineController extends GetxController {
  Rx<UserBasic> userBasic = UserBasic().obs;
  RxString svipEndTime = "".obs;
  RxString headerImgUrl = "".obs;
  RxBool isSvip = false.obs;

  @override
  void onInit() {
    super.onInit();
    logger.i("MineControlleronInit");
    getInfo();
    getPTime();
  }

  void getInfo() {
    getUserBasic().then((value) => {
          userBasic.value = value.data!,
          GetStorageUtils.saveUserBasic(userBasic.value),
          isSvip.value = userBasic.value.svip == 1,
          headerImgUrl.value = userBasic.value.headImgUrl ?? "",
          GetStorageUtils.saveSvip(isSvip.value),
          GetStorageUtils.saveIsHead(userBasic.value.isHead == 1),
          GetStorageUtils.saveIsVideo(userBasic.value.isVideo == 1)
        });
  }

  void getPTime() {
    getPayTime().then((value) =>
        {if (value.isOk()) svipEndTime.value = value.data!.svipEndTime ?? ""});
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
