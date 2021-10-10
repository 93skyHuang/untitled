import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/find_tab_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/sp_util.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widgets/toast.dart';

class FindController extends GetxController {
  RxList<FindTabInfo> findTabList = [FindTabInfo(id: 0, title: '精选')].obs;

  void refreshTitle() {
    getFindTab().then((value) => {
          if (value.isOk())
            {
              findTabList.value = value.data!,
            }
          else
            {}
        });
  }

  @override
  void onInit() {
    logger.i("onInit");
    refreshTitle();
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
