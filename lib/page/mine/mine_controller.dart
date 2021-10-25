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
      if(value.isOk()){
        userBasic.value = value.data!,
        GetStorageUtils.saveSvip( userBasic.value.svip==1),
        GetStorageUtils.saveUserBasic(value.data!.uid, value.data!)
      }
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
