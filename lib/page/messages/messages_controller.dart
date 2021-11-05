import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/utils/time_utils.dart';

import 'messages_page_bean.dart';

/**
 * 消息控制
 */
//系统UId
const int sysUid = 10000;

class MessagesController extends GetxController {
  RxString newSystemMsg = ''.obs;
  RxString newSystemMsgTime = ''.obs;
  RxInt unReadSystemMsg = 0.obs;

  void newSystemMessageOnReceiver() {
    NimCore.instance.messageService.onMessage.listen((List<NIMMessage> list) {
      // 处理新收到的消息，为了上传处理方便，SDK 保证参数 messages 全部来自同一个聊天对象。
      NIMMessage message = list[0];
      if (message.fromAccount == "ll10000") {
        newSystemMsg.value = message.content ?? "";
        newSystemMsgTime.value =
            TimeUtils.dateAndTimeToString(message.timestamp);
      }
    });
  }

  /**
   * 查询一条系统消息
   */
  void querySystemMsg() async {
    final result = await NimNetworkManager.instance.queryLastMsg(sysUid);
    if (result.isSuccess && result.data != null) {
      NIMMessage msg = result.data!;
      newSystemMsg.value = msg.content ?? "";
      newSystemMsgTime.value = TimeUtils.dateAndTimeToString(msg.timestamp);
      // unReadSystemMsg.value=msg.isRemoteRead
    }
  }

  ///获取会话列表
  Future<List<MsgPageBean>> querySessionList() async {
    final result = await NimCore.instance.messageService.querySessionList();
    List<NIMSession> list = result.data ?? [];
    logger.i("$result  length=${list.length}");
    List<MsgPageBean> listBean = [];
    for (int i = 0; i < list.length; i++) {
      logger.i(list[i].sessionId);
      NIMSession session = list[i];
      MsgPageBean msgPageBean = MsgPageBean();
      logger.i(session.extension);
      msgPageBean.time = TimeUtils.dateAndTimeToString(session.lastMessageTime);
      msgPageBean.unreadMsgNum = session.unreadCount;
      int uid = int.parse(
          session.sessionId.substring(session.sessionId.lastIndexOf('l') + 1));
      if (uid == sysUid) {
        newSystemMsg.value = session.lastMessageContent ?? "";
        newSystemMsgTime.value =
            TimeUtils.dateAndTimeToString(session.lastMessageTime);
        unReadSystemMsg.value = session.unreadCount;
      } else {
        UserBasic? userBasic = await getUserInfo(uid);
        msgPageBean.heardUrl = '${userBasic?.headImgUrl}';
        msgPageBean.nickName = '${userBasic?.cname}';
        msgPageBean.age = userBasic?.age;
        msgPageBean.uid = userBasic?.uid ?? -1;
        msgPageBean.height = userBasic?.height;
        msgPageBean.region = userBasic?.region;
        listBean.add(msgPageBean);
      }
    }
    return listBean;
  }

  Future<UserBasic?> getUserInfo(int uid) async {
    UserBasic? userBasic = GetStorageUtils.getUserBasic(uid);
    if (userBasic == null) {
      final d = await getHomeUserData(uid);
      if (d.isOk()) {
        userBasic = d.data ?? UserBasic();
        GetStorageUtils.saveUserBasic(userBasic);
      }
    }
    return userBasic;
  }

  @override
  void onInit() {
    super.onInit();
    logger.i("onInit");
  }

  @override
  void onClose() {
    logger.i("onClose");
  }

  @override
  void onReady() {
    logger.i("onReady");
    // querySystemMsg();
    newSystemMessageOnReceiver();
  }
}
