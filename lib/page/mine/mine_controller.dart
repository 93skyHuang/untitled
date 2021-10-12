import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/sp_util.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widgets/toast.dart';

class MineController extends GetxController {


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
