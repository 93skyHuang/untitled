import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';

/**
 * 聊天控制
 */
class ChatController extends GetxController {
  final NimNetworkManager _nimNetworkManager = NimNetworkManager.instance;
  RxBool isFollow = false.obs;
  RxBool isShowRecodingBtn = false.obs;
  RxBool isRecoding = false.obs;
  RxString recodeBtnText = "按住说话".obs;
  RxString cancelRecodeText = "松开发送，上滑取消".obs;
  RxString hisName = "".obs;
  RxString headerUrl = ''.obs; //对方的头像
  RxString mineHeaderUrl = ''.obs; //自己的头像
  RxString curPlayAudioMsgId = '-1'.obs; //当前播放的消息id
  RxBool isGetHisInfo = false.obs;
  UserBasic? hisBasic;

  UserBasic? mineBasic = GetStorageUtils.getMineUserBasic();

  RxList<NIMMessage> nimMessageList = <NIMMessage>[].obs;
  int hisUid = -1;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  RxBool isNoMoreData = false.obs;

  void setUserUid(int uid) {
    hisUid = uid;
    final u = GetStorageUtils.getUserBasic(uid);
    logger.i(u);
    if (u == null) {
      getInfo();
    } else {
      setUserBasic(u);
    }
    createSession();
  }

  void setUserBasic(UserBasic hisBasic) {
    this.hisBasic = hisBasic;
    isFollow.value = hisBasic.isFollow == 1;
    hisName.value = hisBasic.cname ?? '$hisUid';
    headerUrl.value = hisBasic.headImgUrl ?? '';
    mineHeaderUrl.value = '${mineBasic?.headImgUrl}';
    isGetHisInfo.value = true;
  }

  void getInfo() async {
    final value = await getHomeUserData(hisUid);
    if (value.isOk()) {
      GetStorageUtils.saveUserBasic(value.data!);
      setUserBasic(value.data!);
    }
  }

  /// 是否是他发送的消息
  bool isHisMsg(String? account) {
    logger.i(account);
    return '$account'.contains('$hisUid');
  }

  void queryHistoryMsg() async {
    nimMessageList.clear();
    isNoMoreData.value = false;
    final result = await _nimNetworkManager.queryHistoryMsg(hisUid);
    if (result.isSuccess) {
      List<NIMMessage> list = result.data ?? [];
      if (list.isNotEmpty) {
        list.sort((nim1, nim2) => nim2.timestamp.compareTo(nim1.timestamp));
        nimMessageList.addAll(list);
      }
    }
  }

  Future<int> queryMoreHistoryMsg() async {
    if (nimMessageList.isNotEmpty) {
      logger.i("${nimMessageList.value.length} ");
      final result = await _nimNetworkManager
          .queryMoreHistoryMsg(nimMessageList[nimMessageList.value.length - 1]);
      logger.i("${result.data?.length}");
      if (result.isSuccess) {
        List<NIMMessage> list = result.data ?? [];
        if (list.isNotEmpty) {
          list.sort((nim1, nim2) => nim2.timestamp.compareTo(nim1.timestamp));
          nimMessageList.addAll(list);
        } else {
          isNoMoreData.value = true;
          return 1; //没有数据
        }
      } else {
        return 2; //加载失败
      }
    }
    return 0; //
  }

  int trendsLength() {
    return hisBasic?.trendsList?.length ?? 0;
  }

  void add() {
    hisBasic?.isFollow = 1;
    isFollow.value = true;
    addFollow(hisUid).then((value) => {
          if (value.isOk())
            {}
          else
            {
              MyToast.show(value.msg),
              hisBasic?.isFollow = 0,
              isFollow.value = false,
            }
        });
  }

  void del() {
    hisBasic?.isFollow = 0;
    isFollow.value = false;
    delFollow(hisUid).then((value) => {
          if (value.isOk())
            {}
          else
            {
              hisBasic?.isFollow = 1,
              isFollow.value = true,
              MyToast.show(value.msg),
            }
        });
  }

  /**
   * 创建临时会话
   */
  void createSession() async {
    logger.i('createSession');
    _nimNetworkManager.createSession(hisUid);
  }

  void sendTextMessage(String content) async {
    final r = await chatMessage(hisUid, content);
    if (!r.isOk()) {
      if (r.code == 300) {

      } else {
        MyToast.show(r.msg);
      }
      return;
    }
    NimCore.instance.messageService.onMessageStatus.listen((event) {
      logger.i('消息状态${event.status} ${event.content} ${event.messageId}');
      // if (event.status == NIMMessageStatus.fail) {
      //   changeTagMsg(event);
      // }
    });
    final result = await _nimNetworkManager.createTextMsg(content, hisUid);
    if (result.isSuccess) {
      NIMMessage msg = result.data!;
      final s = await _nimNetworkManager.sendMsg(msg);
      if (s.isSuccess) {
        nimMessageList.insert(0, s.data!);
      } else {
        msg.status = NIMMessageStatus.fail;
        nimMessageList.insert(0, msg);
      }
    }
  }

  void changeTagMsg(NIMMessage msg) {
    if (nimMessageList.isNotEmpty) {
      bool isFind = false;
      for (int i = 0; i < nimMessageList.length; i++) {
        logger.i(
            '${nimMessageList[i].messageId}--${nimMessageList[i].content} $i-- ${msg.messageId} ');
        if (nimMessageList[i].messageId == msg.messageId) {
          nimMessageList[i] = msg;
          isFind = true;
          break;
        }
      }
      if (!isFind) {
        nimMessageList.add(msg);
      }
    }
  }

  void _messageReceive() {
    NimCore.instance.messageService.onMessage.listen((List<NIMMessage> list) {
      // 处理新收到的消息，为了上传处理方便，SDK 保证参数 messages 全部来自同一个聊天对象。
      NIMMessage message = list[0];
      if (isHisMsg(message.fromAccount)) {
        nimMessageList.insertAll(0, list);
      }
    });
  }

  ///打开录音
  void openOrCloseRecoding() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    } else {
      if (isShowRecodingBtn.value) {
        isShowRecodingBtn.value = false;
      } else {
        isShowRecodingBtn.value = true;
      }
    }
  }

  ///操作录音
  void startRecoding() async {
    recodeBtnText.value = "松开结束";
    if (!_mRecorderIsInited) {
      await openTheRecorder();
      _mRecorderIsInited = true;
    }
    isRecoding.value = true;
    recodeBtnText.value = "松开发送";
    String path = "${DateTime.now().millisecondsSinceEpoch}.mp4";
    record(path);

    // /// 启动(开始)录音，如果成功，会按照顺序回调onRecordReady和onRecordStart。
    // NimCore.instance.audioService.startRecord({'maxLength': 40});
    //
    // /// 监听录音过程事件
    // NimCore.instance.audioService.onAudioRecordStatus
    //     .listen((RecordInfo recordInfo) {
    //   logger.i(recordInfo);
    //   if (recordInfo.recordState == RecordState.SUCCESS) {
    //     //录制成功
    //     _sendAudio(recordInfo.filePath ?? '');
    //   }
    // });
  }

  void cancelRecoding() {
    stopRecorder(false);
    // NimCore.instance.audioService.stopRecord();
  }

  ///停止录音
  void stopRecodingAndStartSend() {
    stopRecorder(true);
    // NimCore.instance.audioService.stopRecord();
  }

  ///发送语音
  void _sendAudio(String filePath) async {
    if (filePath.isNotEmpty) {
      final r = await _nimNetworkManager.createAudioMessage(filePath, hisUid);
      if (r.isSuccess) {
        NIMMessage msg = r.data!;
        final s = await _nimNetworkManager.sendMsg(msg);
        if (s.isSuccess) {
          nimMessageList.insert(0, s.data!);
        } else {
          msg.status = NIMMessageStatus.fail;
          nimMessageList.insert(0, msg);
        }
      }
      NimCore.instance.messageService.onMessageStatus.listen((event) {
        logger.i('_sendAudio 消息状态${event.status}');
        changeTagMsg(event);
      });
    }
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _mRecorder!.openAudioSession();
    _mRecorderIsInited = true;
  }

  void record(String path) async {
    logger.i(path);
    _mRecorder!.startRecorder(
      toFile: path,
      codec: Codec.aacMP4,
    );
  }

  Future<void> stopRecorder(bool isSend) async {
    isRecoding.value = false;
    recodeBtnText.value = "按住说话";
    cancelRecodeText.value = "松开发送，上滑取消";
    await _mRecorder!.stopRecorder().then((path) {
      logger.i(path);
      if (path != null) {
        if (isSend) {
          _sendAudio(path);
        } else {
          File file = File(path);
          file.exists().then((value) => {if (value) file.delete()});
        }
      }
    });
  }

  Future<void> playVoice(String msgId, String? path) async {
    if (path == null) {
      logger.e('null 消息');
      MyToast.show('未找到该语音');
      return;
    }
    if (curPlayAudioMsgId.value != msgId) {
      curPlayAudioMsgId.value = msgId;
      logger.i(path);
      if (!_mPlayerIsInited) {
        await _mPlayer!.openAudioSession();
        _mPlayerIsInited = true;
      }
      if (_mPlayer!.isPlaying) {
        await stopPlayer();
      }
      _mPlayer!.startPlayer(
          fromURI: path,
          whenFinished: () {
            curPlayAudioMsgId.value = "-1";
            stopPlayer();
          });
    }
  }

  Future<void> stopPlayer() async {
    _mPlayer!.stopPlayer();
  }

  @override
  void onInit() {
    super.onInit();
    logger.i("onInit");
  }

  @override
  void onClose() {
    logger.i("onClose");
    _mPlayer!.closeAudioSession();
    _mPlayer = null;
    _mRecorder!.closeAudioSession();
    _mRecorder = null;
  }

  @override
  void onReady() {
    logger.i("onReady");
    queryHistoryMsg();
    _messageReceive();
  }
}
