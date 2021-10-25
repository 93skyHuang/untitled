import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/page/chat/message_bean.dart';
import 'package:untitled/widgets/toast.dart';

/**
 * 聊天控制
 */
class ChatController extends GetxController {
  RxBool isFollow = false.obs;
  RxBool isShowRecodingBtn = false.obs;
  RxBool isRecoding = false.obs;
  RxString headerUrl = ''.obs; //对方的头像
  RxString mineHeaderUrl = ''.obs; //自己的头像
  late UserBasic userBasic;
  late UserBasic mineBasic;

  // List<MessageBean> message=[];

  void setUserBasic(UserBasic userBasic) {
    this.userBasic = userBasic;
    isFollow.value = userBasic.isFollow == 1;
    headerUrl.value = userBasic.headImgUrl ?? '';
    mineHeaderUrl.value = userBasic.headImgUrl ?? '';
  }

  List<MessageBean> getMsg() {
    List<MessageBean> message = [];
    for (int i = 0; i < 2; i++) {
      MessageBean messageBean = MessageBean();
      messageBean.isReceive = i % 2 == 0;
      messageBean.content = 'jtjis44444444444444444444444sji$i';
      messageBean.messageStatus = i % 3;
      message.add(messageBean);
    }

    return message;
  }

  int treadLength() {
    return userBasic.trendsList?.length ?? 0;
  }

  void add() {
    userBasic.isFollow = 1;
    isFollow.value = true;
    addFollow(userBasic.uid).then((value) => {
          if (value.isOk())
            {}
          else
            {
              userBasic.isFollow = 0,
              isFollow.value = false,
            }
        });
  }

  void del() {
    userBasic.isFollow = 0;
    isFollow.value = false;
    delFollow(userBasic.uid).then((value) => {
          if (value.isOk())
            {
              userBasic.isFollow = 1,
              isFollow.value = true,
            }
        });
  }

  /**
   * 创建临时会话
   */
  void createSession() async {
    logger.i('createSession');
    NIMResult<NIMSession> result = await NimCore.instance.messageService
        .createSession(
            sessionId: "ll${userBasic.uid}",
            sessionType: NIMSessionType.p2p,
            time: DateTime.now().millisecond);
    logger.i(
        '${result.isSuccess} ${result.data?.sessionId}  ${result.data?.senderNickname}');
  }

  void sendTextMessage(String content) async {
    createSession();
    final r = await chatMessage(userBasic.uid, content);
    if (!r.isOk()) {
      MyToast.show(r.msg);
      return;
    }
    final result =
        await NimNetworkManager.instance.createTextMsg(content, userBasic.uid);
    logger.i('${result.isSuccess} ${result.errorDetails} ${result.code}');
  }

  void sendAudioMessage(String filePath) async {
    // 该帐号为示例
    String account = 'll${userBasic.uid}';
// 以单聊类型为例
    NIMSessionType sessionType = NIMSessionType.p2p;
// 示例音频，需要开发者在相应目录下有文件
    File file = new File(filePath);
// 显示名称
    String displayName = 'this is a file';
// 发送语音消息
    Future<NIMResult<NIMMessage>> result = MessageBuilder.createAudioMessage(
            sessionId: account,
            sessionType: sessionType,
            filePath: file.path,
            fileSize: file.lengthSync(),
            duration: 2000)
        .then((value) => value.isSuccess
            ? NimCore.instance.messageService
                .sendMessage(message: value.data!, resend: false)
            : Future.value(value));
  }

  void messageReceive() {
    NimCore.instance.messageService.onMessage.listen((List<NIMMessage> list) {
      // 处理新收到的消息，为了上传处理方便，SDK 保证参数 messages 全部来自同一个聊天对象。
    });
  }

  ///打开录音
  void openOrCloseRecoding() {
    if (isShowRecodingBtn.value) {
      isShowRecodingBtn.value = false;
    } else {
      isShowRecodingBtn.value = true;
    }
  }

  ///操作录音
  void startRecoding() {
    isRecoding.value = true;
  }

  void stopRecoding(){
    isRecoding.value = false;
  }

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
