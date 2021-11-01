import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/find_tab_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

class FindController extends GetxController {
  RxList<FindTabInfo> findTabList =
      <FindTabInfo>[FindTabInfo(id: 0, title: "精选"),FindTabInfo(id: 1, title: "实名专区"),FindTabInfo(id: 2, title: "VIP专区"),FindTabInfo(id: 3, title: "活跃专区")].obs;

  void _getTabTitle() {
    getFindTab().then((value) => {
          if (value.isOk())
            {
              findTabList.value = value.data!,
            }
        });
  }

  @override
  void onInit() {
    logger.i("onInit");
    super.onInit();
    _getTabTitle();
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
