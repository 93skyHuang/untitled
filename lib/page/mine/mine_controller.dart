import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:logger/logger.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

class MineController extends GetxController {
  Rx<UserBasic>  userBasic=UserBasic().obs;

  @override
  void onInit() {
    logger.i("MineControlleronInit");
    getInfo();
  }

  void getInfo() {
    getUserBasic().then((value) => {
          userBasic.value = value.data!,
          GetStorageUtils.saveUserBasic(userBasic.value),
          GetStorageUtils.saveSvip(userBasic.value.svip == 1),
          GetStorageUtils.saveIsHead(userBasic.value.isHead == 1),
          GetStorageUtils.saveIsVideo(userBasic.value.isVideo == 1)
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
