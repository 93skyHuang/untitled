import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/widgets/bottom_pupop.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/my_text_widget.dart';
import 'chat_controller.dart';

//聊天页面
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _controller = Get.put(ChatController());
  TextEditingController textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  double start = 0.0;
  double offset = 0.0;
  bool isUpCancel = false;

  ///聊天单边显示区域
  final contentWidth = ScreenUtil().screenWidth - 150;

  @override
  void initState() {
    super.initState();
    //聊天用户的uid
    int uid = Get.arguments['uid'];
    _controller.setUserUid(uid);
  }

  @override
  Widget build(BuildContext context) {
    logger.i('MessagesPage');
    return Scaffold(
      backgroundColor: MyColor.pageBgColor,
      appBar: AppBar(
        elevation: 0.5,
        leading: IconButton(
            icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
            onPressed: () {
              Navigator.maybePop(context);
            }),
        centerTitle: true,
        backgroundColor: MyColor.pageBgColor,
        title: Obx(() => Text(
              _controller.hisName.value,
              style: TextStyle(
                  color: MyColor.blackColor, fontSize: ScreenUtil().setSp(18)),
            )),
      ),
      body: Stack(children: [
        // _userCard(),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFFF0F0F0),
          child: Obx(() => Column(
                children: <Widget>[
                  _controller.isGetHisInfo.value ? _userCard() : Container(),
                  Expanded(
                    flex: 1,
                    child: Container(
                      //列表内容少的时候靠上
                      alignment: Alignment.topCenter,
                      child: _renderList(),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(50),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Obx(() => InkWell(
                              onTap: () {
                                _controller.openOrCloseRecoding();
                              },
                              child: _controller.isShowRecodingBtn.value
                                  ? Container(
                                      margin: EdgeInsets.fromLTRB(12, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        //背景
                                        color: MyColor.mainColor,
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        //设置四周边框
                                        border: Border(),
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.keyboard,
                                        size: 30,
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.fromLTRB(12, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        //背景
                                        color: MyColor.mainColor,
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        //设置四周边框
                                        border: Border(),
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.mic_rounded,
                                        size: 30,
                                      ),
                                    ),
                            )),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            constraints: BoxConstraints(
                              maxHeight: 100.0,
                              minHeight: 50.0,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFF5F6FF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Obx(() => _controller.isShowRecodingBtn.value
                                ? GestureDetector(
                                    onVerticalDragStart: (details) {
                                      logger.i("onVerticalDragStart");
                                      isUpCancel = false;
                                      start = details.globalPosition.dy;
                                      _controller.startRecoding();
                                      _controller.cancelRecodeText.value =
                                          "松开发送，上滑取消";
                                    },
                                    onVerticalDragEnd: (details) {
                                      logger.i("onVerticalDragEnd $isUpCancel");
                                      if (isUpCancel) {
                                        _controller.cancelRecoding();
                                      } else {
                                        _controller.stopRecodingAndStartSend();
                                      }
                                    },
                                    onVerticalDragUpdate: (details) {
                                      logger.i(
                                          "onVerticalDragUpdate $start  $offset");
                                      offset = details.globalPosition.dy;
                                      isUpCancel =
                                          start - offset > 70 ? true : false;
                                      if (isUpCancel) {
                                        _controller.cancelRecodeText.value =
                                            "松开取消发送";
                                      } else {
                                        _controller.cancelRecodeText.value =
                                            "松开发送，上滑取消";
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      child: Text(
                                        _controller.recodeBtnText.value,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: MyColor.mainColor,
                                            fontSize: 16),
                                      ),
                                    ))
                                : TextField(
                                    controller: textEditingController,
                                    maxLines: null,
                                    maxLength: 200,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 16.0, right: 16.0, bottom: 10),
                                      hintText: "回复",
                                      hintStyle: TextStyle(
                                          color: Color(0xFFADB3BA),
                                          fontSize: 14),
                                    ),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  )),
                          ),
                        ),
                        _controller.isShowRecodingBtn.value
                            ? Container(
                                width: 30,
                              )
                            : Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: TextButton(
                                  style: ButtonStyle(
                                      //去除点击效果
                                      // overlayColor: MaterialStateProperty.all(
                                      //     Colors.transparent),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(0, 0)),
                                      visualDensity: VisualDensity.compact,
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                      //圆角
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4))),
                                      //背景
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xFFF3CD8E))),
                                  onPressed: () {
                                    sendTxt();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 60,
                                    height: 40,
                                    child: Text(
                                      '发送',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )),
                      ],
                    ),
                  ),
                ],
              )),
        ),

        ///语音录制动画
        Obx(() => _controller.isRecoding.value
            ? Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Color(0xff77797A),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Image.asset(
                            "assets/images/voice_volume_7.png",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10, left: 10, top: 0),
                          child: Text(
                            _controller.cancelRecodeText.value,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Container()),
      ]),
    );
  }

  bool _isNoMoreData = false;

  _onLoad() {
    if (!_isNoMoreData) {
      _controller.queryMoreHistoryMsg().then((value) => {
            if (value == 2)
              {
                _refreshController.loadComplete(),
              }
            else if (value == 1)
              {
                _isNoMoreData = true,
                _refreshController.loadComplete(),
              }
            else
              {
                _refreshController.loadComplete(),
              }
          });
    } else {
      _refreshController.loadComplete();
    }
  }

  _renderList() {
    return Obx(() => SmartRefresher(
          enablePullDown: false,
          enablePullUp: !_controller.isNoMoreData.value,
          // header: const MsgClassicHeader(),
          footer: const MsgClassicFooter(),
          // 配置默认底部指示器
          controller: _refreshController,
          // onRefresh: _onLoad(),
          onLoading: _onLoad(),
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 27),
            itemBuilder: (context, index) {
              var item = _controller.nimMessageList[index];
              return item.messageDirection == NIMMessageDirection.received
                  ? _receivedMsgItem(context, item)
                  : _sendMsgItem(context, item);
            },
            itemCount: _controller.nimMessageList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
          ),
        ));
  }

  Widget _receivedMsgItem(BuildContext context, NIMMessage item) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 0, 20),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //头像
              Obx(() => cardNetworkImage2(_controller.headerUrl.value, 40, 40,
                  errorWidget: Icon(
                    Icons.person,
                    size: 34,
                    color: Colors.white,
                  ))),
              //内容区域
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: contentWidth,
                        minHeight: 40,
                      ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(4.0, 7.0),
                              color: Color(0x04000000),
                              blurRadius: 10,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: EdgeInsets.only(left: 10, top: 4),
                      padding: EdgeInsets.all(10),
                      child: item.messageType == NIMMessageType.text
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${item.content}',
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            )
                          : _receiveVoiceItem(item),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///接收到的语音消息
  Widget _receiveVoiceItem(NIMMessage item) {
    NIMMessageAttachment? nimMessageAttachment = item.messageAttachment;
    if (item.messageType == NIMMessageType.audio) {
      // NIMCustomMessageAttachment nimCustomMessageAttachment =
      // NIMCustomMessageAttachment.fromMap(nimMessageAttachment!.toMap());
      // int mill = nimCustomMessageAttachment.data?['duration'] ?? 0;
      // File? file = nimCustomMessageAttachment.data?['file'] as File?;
      NIMAudioAttachment nimAudioAttachment =
          NIMAudioAttachment.fromMap(nimMessageAttachment!.toMap());
      int mill = nimAudioAttachment.duration ?? 0;
      int second = mill ~/ 1000;
      double width = second < 3
          ? contentWidth / 4
          : second < 6
              ? contentWidth / 3
              : contentWidth / 2;
      return InkWell(
          onTap: () {
            logger.i('播放语音');
            _controller.playVoice(
                item.messageId ?? "-2", nimAudioAttachment.path);
          },
          child: Container(
            width: width,
            child: Row(
              children: [
                Text(
                  '$second"',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Expanded(child: Align()),
                Image.asset(
                  'assets/images/audio_left.png',
                  height: 18,
                  color: _controller.curPlayAudioMsgId.value == item.messageId
                      ? Colors.black26
                      : Colors.black,
                ),
              ],
            ),
          ));
    } else {
      return Container();
    }
  }

  ///发出去的消息
  Widget _sendMsgItem(BuildContext context, NIMMessage item) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 20),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              //头像
              Obx(() =>
                  cardNetworkImage2(_controller.mineHeaderUrl.value, 40, 40,
                      margin: EdgeInsets.all(0),
                      errorWidget: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: contentWidth, minHeight: 40),
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(4.0, 7.0),
                                  color: Color(0x04000000),
                                  blurRadius: 10,
                                ),
                              ],
                              color: MyColor.mainColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.all(10),
                          child: item.messageType == NIMMessageType.text
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${item.content}',
                                      softWrap: true,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    )
                                  ],
                                )
                              : _sendVoiceItem(item),
                        ),
                      ),

                      ///发送消息状态
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
                          child: item.status == NIMMessageStatus.sending
                              ? item.messageType ==
                                      NIMMessageType.text //文字不需要加载图标
                                  ? Container()
                                  : ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: 10, maxHeight: 10),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey),
                                        ),
                                      ),
                                    )
                              : item.status == NIMMessageStatus.fail
                                  ? Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 11,
                                    )
                                  : Container()),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  /**
   * 发出去的语音
   */
  Widget _sendVoiceItem(NIMMessage item) {
    NIMMessageAttachment? nimMessageAttachment = item.messageAttachment;
    if (item.messageType == NIMMessageType.audio) {
      // NIMCustomMessageAttachment nimCustomMessageAttachment =
      // NIMCustomMessageAttachment.fromMap(nimMessageAttachment!.toMap());
      // int mill = nimCustomMessageAttachment.data?['duration'] ?? 0;
      // File? file = nimCustomMessageAttachment.data?['file'] as File?;
      NIMAudioAttachment nimAudioAttachment =
          NIMAudioAttachment.fromMap(nimMessageAttachment!.toMap());
      int mill = nimAudioAttachment.duration ?? 0;
      int second = mill ~/ 1000;
      double width = second < 3
          ? contentWidth / 4
          : second < 6
              ? contentWidth / 3
              : contentWidth / 2;
      return InkWell(
          onTap: () {
            logger.i('播放语音');
            _controller.playVoice(
                item.messageId ?? "-2", nimAudioAttachment.path);
          },
          child: Container(
            width: width,
            height: 20,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$second"',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Expanded(child: Align()),
                    Image.asset(
                      'assets/images/audio_right.png',
                      height: 18,
                      color:
                          _controller.curPlayAudioMsgId.value == item.messageId
                              ? Colors.black26
                              : Colors.black,
                    ),
                  ],
                )),
          ));
    } else {
      return Container();
    }
  }

  sendTxt() {
    String s = textEditingController.text.toString();
    if (s.isNotEmpty) {
      textEditingController.text = '';
      _controller.sendTextMessage(s);
    }
  }

  Widget _userCard() {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
          width: double.infinity,
          height:
              ScreenUtil().setHeight(_controller.trendsLength() > 0 ? ScreenUtil().setHeight(200) : ScreenUtil().setHeight(80)),
          decoration: BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(8)),
            //设置四周边框
            border: Border(),
          ),
          child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(8),
                left: ScreenUtil().setWidth(4),
                right: ScreenUtil().setWidth(10),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: _headImg(
                                _controller.hisBasic?.headImgUrl ?? ''),
                            onTap: () {
                              Get.to(UserHomePage(
                                uid: _controller.hisUid,
                                initialIndex: 2,
                              ));
                            },
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                singeLineText(
                                    '${_controller.hisBasic?.cname}',
                                    ScreenUtil().setWidth(90),
                                    TextStyle(
                                        color: MyColor.blackColor,
                                        fontSize: ScreenUtil().setSp(14))),
                                Padding(
                                    padding: EdgeInsets.only(top: 4, bottom: 6),
                                    child: _info2()), //信息
                                _info3(), //认证
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          focusWidget(),
                        ]),
                    Expanded(child: Align(alignment: Alignment.center,child: _info4(),)),
                    ///动态
                  ])),
        ));
  }

  Widget _info2() {
    String constellation = _controller.hisBasic?.constellation ?? "";
    return Row(
      children: [
        Text(
          '${_controller.hisBasic?.age}岁',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10)),
        ),
        constellation.isNotEmpty ? VDivider() : Container(),
        Text(
          constellation,
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10)),
        ),
        VDivider(),
        Text(
          '${_controller.hisBasic?.height}cm',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10)),
        ),
      ],
    );
  }

  Widget _headImg(String imaUrl) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(4)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: SizedBox(
          width: ScreenUtil().setWidth(60),
          height: ScreenUtil().setWidth(60),
          child: CachedNetworkImage(
            fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            imageUrl: imaUrl,
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/image_load_failed.png',
            ),
          )),
    );
  }

  ///认证
  Widget _info3() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Image.asset(_controller.hisBasic?.isCard == 1
              ? "assets/images/ic_card_ver.png"
              : "assets/images/ic_un_card_ver.png"),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Image.asset(_controller.hisBasic?.isHead == 1
              ? "assets/images/icon_verified_avatar.png"
              : "assets/images/icon_un_verified_avatar.png"),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Image.asset(_controller.hisBasic?.isVideo == 1
              ? "assets/images/ic_verified_person1.png"
              : "assets/images/ic_unverified_person.png"),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Image.asset("assets/images/icon_verified_phone.png"),
        ),
      ],
    );
  }

  Widget focusWidget() {
    return Obx(() => _controller.isFollow.value
        ? Container(
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setWidth(30),
            // 边框设置
            decoration: const BoxDecoration(
              //背景
              color: Color(0xffE6E6E6),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              //设置四周边框
              border: Border(),
            ),
            // 设置 child 居中
            alignment: const Alignment(0, 0),
            child: TextButton(
                style: ButtonStyle(
                    //去除点击效果
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                    visualDensity: VisualDensity.compact,
                    padding: MaterialStateProperty.all(EdgeInsets.zero),),
                onPressed: () {
                  showBottomCancelFocus(context, () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _controller.del();
                  });
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '已关注',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      color: MyColor.redFd4343,
                    ),
                  ),
                ])),
          )
        : Container(
            //关注按钮
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setWidth(30),

            // 边框设置
            decoration: const BoxDecoration(
              //背景
              color: Color(0xffE6E6E6),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              //设置四周边框
              border: Border(),
            ),
            // 设置 child 居中
            alignment: const Alignment(0, 0),
            child: TextButton(
                style: ButtonStyle(
                    //去除点击效果
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                    visualDensity: VisualDensity.compact,
                    padding: MaterialStateProperty.all(EdgeInsets.zero),),
                onPressed: () {
                  _controller.add();
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(6),
                        top: ScreenUtil().setWidth(6),
                        bottom: ScreenUtil().setWidth(6),
                        right: ScreenUtil().setWidth(4)),
                    child: Image(
                        color: MyColor.redFd4343,
                        width: ScreenUtil().setWidth(12),
                        height: ScreenUtil().setWidth(12),
                        image: const AssetImage("assets/images/add.png"),
                        fit: BoxFit.fill),
                  ),
                  Text(
                    '关注',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      color: MyColor.redFd4343,
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(right: ScreenUtil().setWidth(6))),
                ])),
          ));
  }

  ///动态图
  Widget _info4() {
    var list = _controller.hisBasic?.trendsList;
    List<Widget> listWidget = [];
    int length = _controller.trendsLength();
    if (length > 0) {
      for (int i = 0; i < length && i < 3; i++) {
        if (list![i]!.imgArr!.isNotEmpty) {
          String url = list[i]!.imgArr!.first ?? '';
          listWidget.add(_infoTrends(url));
        }
      }
    }
    return listWidget.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: singeLineText(
                    '最新个人动态',
                    ScreenUtil().screenWidth / 2,
                    TextStyle(
                        color: MyColor.grey8C8C8C,
                        fontSize: ScreenUtil().setSp(12))),
              ),
              SizedBox(height: 10),
              Row(

                crossAxisAlignment:CrossAxisAlignment.end,
                mainAxisAlignment: listWidget.length == 3
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: listWidget,
              )
            ],
          );
  }

  ///动态
  Widget _infoTrends(String url) {
    return url.isEmpty
        ? Container()
        : InkWell(
            child: cardNetworkImage(
                url, ScreenUtil().setWidth(ScreenUtil().setWidth(90)), ScreenUtil().setWidth(90),
                radius: 8),
            onTap: () {
              Get.to(UserHomePage(
                uid: _controller.hisUid,
              ));
            },
          );
  }
}
