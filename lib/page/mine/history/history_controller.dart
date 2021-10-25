import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';

class HistoryController extends GetxController {
  RxList historys = [].obs;

  @override
  void onInit() {
    logger.i("FollowController");
  }

  void getList() {
    getMyFootList(1).then((value) => {historys.value = value.data!});
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
