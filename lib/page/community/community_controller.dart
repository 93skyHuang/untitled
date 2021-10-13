import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/find_tab_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';


class CommunityController extends GetxController {
  RxList<FindTabInfo> findTabList = [FindTabInfo(id: 0, title: '精选')].obs;

  void _getTabTitle() {
    GetStorageUtils.getFindTab().then((value) => {
           findTabList.value = value??findTabList.value
        });
    getFindTab().then((value) => {
          if (value.isOk())
            {
              GetStorageUtils.saveFindTab(value.data),
              findTabList.value = value.data!,
            }
        });
  }

  @override
  void onInit() {
    logger.i("onInit");
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
