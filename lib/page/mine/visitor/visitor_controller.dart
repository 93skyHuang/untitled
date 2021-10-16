import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';

class VisitorController extends GetxController {
  RxList visitors = [].obs;

  @override
  void onInit() {
    logger.i("FollowController");
  }

  void getList() {
    getVisitor(1).then((value) => {visitors.value = value.data!});
  }

  @override
  void onClose() {
    logger.i("onClose");
  }

  @override
  void onReady() {
    logger.i("onReady");
  }

  void del(int uid) {
    delFollow(uid).then((value) => {
          if (value.isOk()) {getList()}
        });
  }
}
