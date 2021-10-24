import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/logger.dart';

/**
 * 消息控制
 */
class MessagesController extends GetxController {
  RxString newSystemMsg = ''.obs;
  RxString newSystemMsgTime = ''.obs;
  RxBool isCanChat = false.obs;
  RxInt unReadSystemMsg = 0.obs;

  void newSystemMessageOnReceiver() {
    NimCore.instance.systemMessageService.onReceiveSystemMsg
        .listen((SystemMessage event) {
      logger.i(event);
      newSystemMsg.value = event.content ?? newSystemMsg.value;
      int time = event.time ?? 0;
      newSystemMsgTime.value = '$time';
      unReadSystemMsg.value++;
    });
  }

  void queryUnReadSystemMsgNum() async {
    final r = await NimCore.instance.systemMessageService
        .querySystemMessageUnreadCount();
    logger.i(r);
    unReadSystemMsg.value = r.data ?? 0;
  }

  /**
   * 查询一条系统消息
   */
  void querySystemMsg() async {
    final result =
        await NimCore.instance.systemMessageService.querySystemMessages(1);
    logger.i(result);
    if (result.isSuccess) {
      List<SystemMessage> msg = result.data ?? [];
      logger.i(msg.length);
      if (msg.isNotEmpty) {
        SystemMessage systemMessage = msg[0];
        newSystemMsg.value = systemMessage.content ?? newSystemMsg.value;
        int time = systemMessage.time ?? 0;
        newSystemMsgTime.value = '$time';
        logger.i(systemMessage);
      }
    }
  }

  ///获取会话列表
  Future<List<NIMSession>> querySessionList() async {
    final result = await NimCore.instance.messageService.querySessionList();
    List<NIMSession> list = result.data ?? [];
    logger.i("$result  length=${list.length}");
    for (int i = 0; i < list.length; i++) {
      logger.i(list[i].sessionId);
    }
    return list;
  }

  @override
  void onInit() {
    logger.i("onInit");
    newSystemMessageOnReceiver();
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
