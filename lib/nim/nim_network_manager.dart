import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';

/**
 * 云信网络接口管理
 */
class NimNetworkManager {
  NimNetworkManager._();

  static final NimNetworkManager instance = NimNetworkManager._();

  void nimLogin(int uid, String token) {
    logger.i('云信登录uid=$uid token=$token');
    NimCore.instance.authService
        .login(NIMLoginInfo(
      account: "ll$uid",
      token: token,
    ))
        .then(
      (result) {
        if (result.isSuccess) {
          logger.i('云信登录成功uid=$uid token=$token');
          onlineClientsListener();
        } else {
          logger.e('云信登录失败uid$uid token=$token      '
              'errorDetails${result.errorDetails}'
              'result.code${result.code}');
        }
      },
    ).whenComplete(() => {
              logger.i('云信登录操作完成'),
            });
  }

  void logout() {
    GetStorageUtils.saveUid(0);
    GetStorageUtils.saveNimToken('');
    GetStorageUtils.saveSex(1);
    GetStorageUtils.saveSvip(false);
    GetStorageUtils.saveIsHead(false);
    GetStorageUtils.saveIsVideo(false);
    NimCore.instance.authService.logout().then((result) {
      if (result.isSuccess) {
        /// 成功
      } else {
        /// 失败
      }
    });
  }

  StreamSubscription? _onlineClientsSubscription;

  void onlineClientsListener() {
    _onlineClientsSubscription =
        NimCore.instance.authService.onlineClients.listen((clients) {
      clients.forEach((client) {
        logger.i(client);
        switch (client.clientType) {
          case NIMClientType.ios:
          case NIMClientType.android:
            NimNetworkManager.instance.kickOutOtherOnlineClient(client);
            break;
          default:
            // 未知
            break;
        }
      });
    });
  }

  void _cancelOnlineClientsSubscription() {
    _onlineClientsSubscription?.cancel();
    _onlineClientsSubscription = null;
  }

  void kickOutOtherOnlineClient(NIMOnlineClient client) {
    NimCore.instance.authService
        .kickOutOtherOnlineClient(client)
        .then((result) {
      if (result.isSuccess) {
        logger.i('kickOutOtherOnlineClient success $client');
        _cancelOnlineClientsSubscription();

        /// 成功
      } else {
        logger.e('kickOutOtherOnlineClient $client');
        _cancelOnlineClientsSubscription();

        /// 失败
      }
    });
  }

  void loginStatus() {
    final subscription =
        NimCore.instance.authService.authStatus.listen((event) {
      if (event is NIMKickOutByOtherClientEvent) {
        /// 监听到被踢事件
      } else if (event is NIMAuthStatusEvent) {
        /// 监听到其他事件
      }
    });

    /// 不再监听时，需要取消监听，否则造成内存泄漏
    /// subscription.cancel();
  }

  void dataStatus() {
    /// 开始监听事件
    final subscription =
        NimCore.instance.authService.authStatus.listen((event) {
      if (event is NIMDataSyncStatusEvent) {
        /// 监听到数据同步事件
        if (event.status == NIMAuthStatus.dataSyncStart) {
          /// 数据同步开始
        } else if (event.status == NIMAuthStatus.dataSyncFinish) {
          /// 数据同步完成
        }
      }
    });

    /// 不再监听时，需要取消监听，否则造成内存泄漏
    /// subscription.cancel();
  }

  void systemMessage() {
    NimCore.instance.systemMessageService.onReceiveSystemMsg
        .listen((SystemMessage event) {});
  }

  /**
   * 查询系统的最近一条消息
   */
  Future<NIMResult<NIMMessage>> queryLastMsg(int uid) async {
    final result = await NimCore.instance.messageService
        .queryLastMessage('ll$uid', NIMSessionType.system);
    return result;
  }

  Future<NIMResult<void>> sendMessageReceipt(int uid) async {
    List<NIMSessionInfo> sessionInfoList = [];
    NIMSessionInfo nimSessionInfo =
        NIMSessionInfo(sessionId: 'll$uid', sessionType: NIMSessionType.p2p);
    sessionInfoList.add(nimSessionInfo);
    final result = await NimCore.instance.messageService
        .clearSessionUnreadCount(sessionInfoList);
    logger.i('--${result.isSuccess} --$uid');
    return result;
  }

  /**
   * 查询与该用户的历史消息
   */
  Future<NIMResult<List<NIMMessage>>> queryHistoryMsg(int uid) async {
    final result = await NimCore.instance.messageService
        .queryMessageList('ll$uid', NIMSessionType.p2p, 10);
    return result;
  }

  /**
   * 查询与该用户的更多历史消息 传入最后一条消息
   */
  Future<NIMResult<List<NIMMessage>>> queryMoreHistoryMsg(
      NIMMessage anchor) async {
    final result = await NimCore.instance.messageService
        .queryMessageListEx(anchor, QueryDirection.QUERY_OLD, 30);
    return result;
  }

  Future<NIMResult<NIMSession>> createSession(int uid) async {
    /// [sessionId] - 会话id ，对方帐号或群组id。
    /// [sessionType] - 会话类型
    /// [tag] - 会话tag ， eg:置顶标签（UIKit中的实现： RECENT_TAG_STICKY） ，用户参照自己的tag 实现即可， 如不需要，传 0 即可
    /// [time] - 会话时间 ，单位为ms。
    /// [linkToLastMessage] - 是否放入最后一条消息的相关信息
    NIMResult<NIMSession> result = await NimCore.instance.messageService
        .createSession(
            sessionId: 'll$uid',
            sessionType: NIMSessionType.p2p,
            time: DateTime.now().millisecond);
    logger.i(
        '${result.isSuccess} ${result.data?.sessionId}  ${result.data?.senderNickname}');
    return result;
  }

  ///更新聊天人信息
  void updateSession(NIMSession nimSession) async {
    var result = await NimCore.instance.messageService
        .updateSession(session: nimSession);
  }

  Future<NIMResult<NIMMessage>> createTextMsg(String content, int uid) async {
    String account = 'll$uid';
    // 以单聊类型为例
    NIMSessionType sessionType = NIMSessionType.p2p;
    String text = content;
    Future<NIMResult<NIMMessage>> result = MessageBuilder.createTextMessage(
        sessionId: account, sessionType: sessionType, text: text);
    return result;
  }

  Future<NIMResult<NIMMessage>> sendMsg(NIMMessage msg) {
    final result = NimCore.instance.messageService
        .sendMessage(message: msg, resend: false);
    result.then((value) => logger.i(
        '${value.isSuccess} ${value.errorDetails} ${value.code} ${value.data}'));
    return result;
  }

//   Future<NIMResult<NIMMessage>> sendCustomAudioMessage(
//       String filePath, int uid) async {
//     // 该帐号为示例
//     String account = 'll$uid';
// // 以单聊类型为例
//     NIMSessionType sessionType = NIMSessionType.p2p;
// // 示例音频，需要开发者在相应目录下有文件
//     File file = File(filePath);
// // 发送语音消息
//     Future<NIMResult<NIMMessage>> result = MessageBuilder.createAudioMessage(
//             sessionId: account,
//             sessionType: sessionType,
//             filePath: file.path,
//             fileSize: file.lengthSync(),
//             duration: 2000)
//         .then((value) => value.isSuccess
//             ? NimCore.instance.messageService
//                 .sendMessage(message: value.data!, resend: false)
//             : Future.value(value));
//     return result;
//   }

  Future<NIMResult<NIMMessage>> createAudioMessage(
      String filePath, int uid, Duration duration) async {
    // 该帐号为示例
    String account = 'll$uid';
// 以单聊类型为例
    NIMSessionType sessionType = NIMSessionType.p2p;
// 示例音频，需要开发者在相应目录下有文件
    File file = File(filePath);
    logger.i(duration);
// 发送语音消息
    Future<NIMResult<NIMMessage>> result = MessageBuilder.createAudioMessage(
        sessionId: account,
        sessionType: sessionType,
        filePath: file.path,
        fileSize: file.lengthSync(),
        duration: duration.inMilliseconds);
    return result;
    // Map<String,dynamic> map={"file":file,"duration":duration?.inMilliseconds ?? 0,"type":"Audio"};
    // Future<NIMResult<NIMMessage>> result = MessageBuilder.createCustomMessage(
    //         sessionId: account,
    //         sessionType: sessionType,
    //     attachment: NIMCustomMessageAttachment(data: map),);
    // return result;
  }
}
