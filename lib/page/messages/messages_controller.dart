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
import 'package:untitled/route_config.dart';
import 'package:untitled/utils/time_utils.dart';
import 'package:untitled/widgets/dialog.dart';

import 'messages_page_bean.dart';

/**
 * 消息控制
 */
//系统UId
const int sysUid = 10000;
const String sysSession = "ll10000";

typedef NIMSessionUpdate = Function(List<MsgPageBean> list);

class MessagesController extends GetxController {
  RxString systemName = '官方客服'.obs;
  RxString newSystemMsg = ''.obs;
  RxString newSystemMsgTime = ''.obs;
  RxString systemAvatar =
      'https://moshengapp.oss-cn-beijing.aliyuncs.com/system/9e83620211101130902922.png'
          .obs;
  RxInt unReadSystemMsg = 0.obs;
  final List<MsgPageBean> _listBean = [];
  List<NIMSession> nIMSessionList = [];
  List<String> sessionIdList = [];
  NIMSessionUpdate? _nimSessionUpdate;

  void pageChangeListener(NIMSessionUpdate nimSessionUpdate) {
    _nimSessionUpdate = nimSessionUpdate;
  }

  void _onSessionUpdate() {
    NimCore.instance.messageService.onSessionUpdate
        .listen((List<NIMSession> list) {
      int length = list.length;
      logger.i(list.length);
      for (int i = 0; i < length; i++) {
        NIMSession session = list[i];
        if (session.sessionId == sysSession) {
          ///系统消息
          newSystemMsg.value = session.lastMessageContent ?? "";
          newSystemMsgTime.value =
              TimeUtils.dateAndTimeToString(session.lastMessageTime);
          unReadSystemMsg.value = session.unreadCount ?? 0;
          systemName.value = session.senderNickname ?? "官方客服";
        } else {
          _sessionChange(session);
        }
      }
      if (_nimSessionUpdate != null) {
        _nimSessionUpdate!(_listBean);
      }
    });
  }

  void _sessionChange(NIMSession chageSession) {
    for (int i = 0; i < nIMSessionList.length; i++) {
      NIMSession session = nIMSessionList[i];
      if (session.sessionId == chageSession.sessionId) {
        session = chageSession;
        _updatePageData(chageSession);
        return;
      }
    }
    _updatePageData(chageSession);
    nIMSessionList.add(chageSession);
    sessionIdList.add(chageSession.sessionId);
  }

  void _updatePageData(NIMSession session) {
    for (int i = 0; i < _listBean.length; i++) {
      MsgPageBean msgPageBean = _listBean[i];
      if (session.sessionId == msgPageBean.sessionId) {
        msgPageBean = setMsgPageBean(msgPageBean, session);
        return;
      }
    }
    MsgPageBean msgPageBean = MsgPageBean();
    _listBean.add(setMsgPageBean(msgPageBean, session));
  }

  MsgPageBean setMsgPageBean(MsgPageBean msgPageBean, NIMSession session) {
    msgPageBean.time = TimeUtils.dateAndTimeToString(session.lastMessageTime);
    msgPageBean.unreadMsgNum = session.unreadCount ?? 0;
    msgPageBean.nickName = session.senderNickname ?? "";
    msgPageBean.sessionId = session.sessionId;
    if (session.extension != null) {
      msgPageBean.heardUrl = session.extension!['avatar'] ?? '';
      msgPageBean.age = session.extension!['age'];
      msgPageBean.height = session.extension!['height'];
      msgPageBean.region = session.extension!['region'];
    }
    return msgPageBean;
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
    logger.i("querySessionList length=${nIMSessionList.length}");
    _listBean.clear();
    for (int i = 0; i < nIMSessionList.length; i++) {
      NIMSession session = nIMSessionList[i];
      MsgPageBean msgPageBean = MsgPageBean();
      logger.i('${session.sessionId}extension${session.extension}');
      sessionIdList.add(session.sessionId);
      if (session.sessionId == sysSession) {
        newSystemMsg.value = session.lastMessageContent ?? "";
        newSystemMsgTime.value =
            TimeUtils.dateAndTimeToString(session.lastMessageTime);
        unReadSystemMsg.value = session.unreadCount ?? 0;
        systemName.value = session.senderNickname ?? "官方客服";
        NimCore.instance.userService
            .getUserInfo(session.sessionId)
            .then((value) => {
                  if (value.isSuccess)
                    {systemAvatar.value = value.data?.avatar ?? ""}
                });
      } else {
        msgPageBean.sessionId = session.sessionId;
        _listBean.add(setMsgPageBean(msgPageBean, session));
      }
    }
    return _listBean;
  }

  ///获取会话成员的最新数据
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
          logger.i('${user.userId} ${user.nick}---${user.ext}--${user.avatar}');
          if (user.userId == sysSession) {
            systemAvatar.value = user.avatar ?? systemAvatar.value;
            continue;
          }
          _updateInfo(user);
          _updateSession(list, user);
        }
      }
    }
  }

  void _updateInfo(NIMUser user) {
    for (int i = 0; i < _listBean.length; i++) {
      if (user.userId == _listBean[i].sessionId) {
        if (user.ext != null) {
          _listBean[i].region = json.decode(user.ext!)['region'];
          _listBean[i].age = json.decode(user.ext!)['age'];
          _listBean[i].height = json.decode(user.ext!)['height'];
        }
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
        if (user.ext != null) {
          session.extension = {
            'avatar': user.avatar ?? "",
            'name': user.nick ?? "",
            'age': json.decode(user.ext!)['age'],
            'height': json.decode(user.ext!)['height'],
            'region': json.decode(user.ext!)['region'],
          };
        }else{
          session.extension = {
            'avatar': user.avatar ?? "",
            'name': user.nick ?? ""};
        }

        NimNetworkManager.instance.updateSession(session);
        break;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    logger.i("onInit");
    _nimEventListener();
  }

  @override
  void onClose() {
    logger.i("onClose");
    _nimSessionUpdate = null;
    nimEventSubscription.cancel();
  }

  @override
  void onReady() {
    logger.i("onReady");
    _onSessionUpdate();
  }

  late final StreamSubscription nimEventSubscription;

  void _nimEventListener() {
    nimEventSubscription =
        NimCore.instance.authService.authStatus.listen((event) {
      logger.e(event.status);
      if (event is NIMKickOutByOtherClientEvent) {    /// 监听到被踢事件
        logger.e('监听到被踢事件${event.status}');
        if (getApplication() != null) {
          NimNetworkManager.instance.logout();
          showKickOutByOtherClientDialog(getApplication()!);
        }
      } else if (event is NIMAuthStatusEvent) {    /// 监听到其他事件
        if (event is NIMDataSyncStatusEvent) { /// 监听到数据同步事件

          if (event.status == NIMAuthStatus.dataSyncStart) {
            /// 数据同步开始
          } else if (event.status == NIMAuthStatus.dataSyncFinish) {
            /// 数据同步完成
          }
        }
      }
    });
  }
}
