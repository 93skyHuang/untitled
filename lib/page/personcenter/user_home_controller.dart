import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/find_tab_info.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

class UserHomeController extends GetxController {
  Rx<UserBasic> userBasic = UserBasic().obs;
  RxList trends = [].obs;
  RxList videoTrends = [].obs;

  @override
  void onInit() {
    logger.i("UserHomeController");
  }

  void getInfo(int uid) {
    getHomeUserData(uid).then((value) => {
      if(value.isOk()){
        trends.clear(),
        videoTrends.clear(),
        userBasic.value = value.data!,
        for(int i=0;i<userBasic.value.trendsList!.length;i++){
          if(userBasic.value.trendsList![i]!.type==2){
            videoTrends.add(userBasic.value.trendsList![i])
          }else{
            trends.add(userBasic.value.trendsList![i])
          }
        }
      }
    });
  }

  void add() {
    addFollow(userBasic.value.uid).then((value) => {
      if (value.isOk())
        {
          getInfo(userBasic.value.uid),
        }
    });
  }

  void del() {
    delFollow(userBasic.value.uid).then((value) => {
      if (value.isOk())
        {
          getInfo(userBasic.value.uid),
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