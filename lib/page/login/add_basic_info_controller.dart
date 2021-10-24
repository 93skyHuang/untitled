import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widgets/toast.dart';

/**
 * 添加基本信息
 */
class AddBasicInfoController extends GetxController {
  RxString iconUrl=''.obs;

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
