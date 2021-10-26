import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/toast.dart';

/**
 * 聊天控制
 */
class ChatController extends GetxController {
  final NimNetworkManager _nimNetworkManager = NimNetworkManager.instance;
  RxBool isFollow = false.obs;
  RxBool isShowRecodingBtn = false.obs;
  RxBool isRecoding = false.obs;
  RxString headerUrl = ''.obs; //对方的头像
  RxString mineHeaderUrl = ''.obs; //自己的头像
  late UserBasic hisBasic;
  UserBasic? mineBasic = GetStorageUtils.getMineUserBasic();

  List<NIMMessage> nimMessageList = <NIMMessage>[].obs;

  void setUserBasic(UserBasic hisBasic) {
    this.hisBasic = hisBasic;
    isFollow.value = hisBasic.isFollow == 1;
    headerUrl.value = hisBasic.headImgUrl ?? '';
    mineHeaderUrl.value = '${mineBasic?.headImgUrl}';
  }

  /// 是否是他发送的消息
  bool isHisMsg(String? account) {
    return '$account'.contains('${hisBasic.uid}');
  }

  void queryHistoryMsg() async {
    final result = await _nimNetworkManager.queryHistoryMsg(hisBasic.uid);
    if (result.isSuccess) {
      List<NIMMessage> list = result.data ?? [];
      if (list.isNotEmpty) {
        nimMessageList.addAll(list);
      }
    }
  }

  void queryMoreHistoryMsg() async {
    if (nimMessageList.isNotEmpty) {
      final result = await _nimNetworkManager
          .queryMoreHistoryMsg(nimMessageList[nimMessageList.length]);
      if (result.isSuccess) {
        List<NIMMessage> list = result.data ?? [];
        nimMessageList.addAll(list);
      }
    }
  }

  int trendsLength() {
    return hisBasic.trendsList?.length ?? 0;
  }

  void add() {
    hisBasic.isFollow = 1;
    isFollow.value = true;
    addFollow(hisBasic.uid).then((value) => {
          if (value.isOk())
            {}
          else
            {
              hisBasic.isFollow = 0,
              isFollow.value = false,
            }
        });
  }

  void del() {
    hisBasic.isFollow = 0;
    isFollow.value = false;
    delFollow(hisBasic.uid).then((value) => {
          if (value.isOk())
            {
              hisBasic.isFollow = 1,
              isFollow.value = true,
            }
        });
  }

  /**
   * 创建临时会话
   */
  void createSession() async {
    logger.i('createSession');
    _nimNetworkManager.createSession(hisBasic.uid);
  }

  void sendTextMessage(String content) async {
    createSession();
    final r = await chatMessage(hisBasic.uid, content);
    if (!r.isOk()) {
      MyToast.show(r.msg);
      return;
    }
    final result =
        await _nimNetworkManager.createTextMsg(content, hisBasic.uid);
    logger.i('${result.isSuccess} ${result.errorDetails} ${result.code}');
    if (result.isSuccess) {
      nimMessageList.add(result.data!);
    }
  }

  void messageReceive() {
    NimCore.instance.messageService.onMessage.listen((List<NIMMessage> list) {
      // 处理新收到的消息，为了上传处理方便，SDK 保证参数 messages 全部来自同一个聊天对象。
      nimMessageList.addAll(list);
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
  void startRecoding() async {
    isRecoding.value = true;

    /// 启动(开始)录音，如果成功，会按照顺序回调onRecordReady和onRecordStart。
    NimCore.instance.audioService.startRecord({'maxLength': 40});

    /// 监听录音过程事件
    NimCore.instance.audioService.onAudioRecordStatus
        .listen((RecordInfo recordInfo) {
      logger.i(recordInfo);
      if (recordInfo.recordState == RecordState.SUCCESS) {
        //录制成功
        _sendAudio(recordInfo.filePath ?? '');
      }
    });
  }

  ///停止录音
  void stopRecoding() {
    isRecoding.value = false;
    NimCore.instance.audioService.stopRecord();
  }

  ///发送语音
  void _sendAudio(String filePath) async {
    if (filePath.isNotEmpty) {
      final r =
          await _nimNetworkManager.sendAudioMessage(filePath, hisBasic.uid);
      if (r.isSuccess) {
        nimMessageList.add(r.data!);
      }
    }
  }

  @override
  void onInit() {
    logger.i("onInit");
    queryHistoryMsg();
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
