import 'dart:convert';

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
const String sysSession = "ll10000";

class MessagesController extends GetxController {
  RxString systemName = '官方客服'.obs;
  RxString newSystemMsg = ''.obs;
  RxString newSystemMsgTime = ''.obs;
  RxString systemAvatar =
      'https://moshengapp.oss-cn-beijing.aliyuncs.com/system/9e83620211101130902922.png'
          .obs;
  RxInt unReadSystemMsg = 0.obs;
  final List<MsgPageBean> _listBean = [];
  final RxList<MsgPageBean> listPage = <MsgPageBean>[].obs;
  List<NIMSession> nIMSessionList = [];
  List<String> sessionIdList = [];

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
    nIMSessionList = result.data ?? [];
    logger.i("$result  length=${nIMSessionList.length}");
    _listBean.clear();
    for (int i = 0; i < nIMSessionList.length; i++) {
      NIMSession session = nIMSessionList[i];
      MsgPageBean msgPageBean = MsgPageBean();
      logger.i('extension${session.extension}');
      sessionIdList.add(session.sessionId);
      msgPageBean.time = TimeUtils.dateAndTimeToString(session.lastMessageTime);
      msgPageBean.unreadMsgNum = session.unreadCount;
      msgPageBean.sessionId = session.sessionId;
      int uid = int.parse(
          session.sessionId.substring(session.sessionId.lastIndexOf('l') + 1));
      if (uid == sysUid) {
        newSystemMsg.value = session.lastMessageContent ?? "";
        newSystemMsgTime.value =
            TimeUtils.dateAndTimeToString(session.lastMessageTime);
        unReadSystemMsg.value = session.unreadCount;
        systemName.value = session.senderNickname ?? "官方小助手";
      } else {
        logger.i("---extension${session.extension}");
        if (session.extension != null) {
          msgPageBean.heardUrl = session.extension!['avatar'] ?? '';
          msgPageBean.nickName = session.extension!['name'] ?? '';
          msgPageBean.age = session.extension!['age'];
          msgPageBean.uid = uid;
          msgPageBean.height = session.extension!['height'];
          msgPageBean.region = session.extension!['region'];
          _listBean.add(msgPageBean);
        } else {
          msgPageBean.nickName = session.senderNickname ?? "";
          _listBean.add(msgPageBean);
        }
      }
    }
    return _listBean;
  }

  ///获取最新数据
  Future<List<MsgPageBean>> getNewInfo() async {
    await _fetchUserInfoList(nIMSessionList, sessionIdList);
    return _listBean;
  }

  Future<void> _fetchUserInfoList(
      List<NIMSession> list, List<String> userId) async {
    if (userId.isNotEmpty) {
      final re = await NimCore.instance.userService.fetchUserInfoList(userId);
      if (re.isSuccess && re.data != null) {
        List<NIMUser> userList = re.data!;
        for (int i = 0; i < userList.length; i++) {
          NIMUser user = userList[i];
          logger.i('${user.userId} ${user.nick}---${user.ext}');
          if (user.userId == sysSession) {
            systemAvatar.value = user.avatar ?? systemAvatar.value;
            continue;
          }
          if (user.ext != null) {
            _updateInfo(user);
            _updateSession(list, user);
          }
        }
      }
    }
  }

  void _updateInfo(NIMUser user) {
    for (int i = 0; i < _listBean.length; i++) {
      if (user.userId == _listBean[i].sessionId) {
        _listBean[i].region = json.decode(user.ext!)['region'];
        _listBean[i].age = json.decode(user.ext!)['age'];
        _listBean[i].height = json.decode(user.ext!)['height'];
        _listBean[i].heardUrl = user.avatar ?? "";
        _listBean[i].nickName = user.nick ?? "";
        break;
      }
    }
  }

  void _updateSession(List<NIMSession> list, NIMUser user) {
    for (int i = 0; i < list.length; i++) {
      NIMSession session = list[i];
      if (session.sessionId == user.userId) {
        session.extension = {
          'avatar': user.avatar ?? "",
          'name': user.nick ?? "",
          'age': json.decode(user.ext!)['age'],
          'height': json.decode(user.ext!)['height'],
          'region': json.decode(user.ext!)['region'],
        };
        NimNetworkManager.instance.updateSession(session);
        break;
      }
    }
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
