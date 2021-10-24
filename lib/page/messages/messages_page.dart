import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/network/bean/nearby_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/my_text_widget.dart';
import 'package:untitled/widgets/null_list_widget.dart';

import 'messages_controller.dart';

//消息页面
class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MessagesPageState();
  }
}

class _MessagesPageState extends State<MessagesPage>
    with AutomaticKeepAliveClientMixin {
  final MessagesController _controller = Get.put(MessagesController());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<NIMSession> _list = [];
  final double _textContextWidth =
      ScreenUtil().screenWidth - ScreenUtil().setWidth(180);

  @override
  void initState() {
    logger.i('initState');
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _onRefresh();
    });

  }

  @override
  Widget build(BuildContext context) {
    logger.i('MessagesPage');
    super.build(context);
    return Scaffold(
        backgroundColor: MyColor.pageBgColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColor.pageBgColor,
          elevation: 0.5,
          actions: [
            TextButton(
                onPressed: () {
                  _controller.querySystemMsg();
                },
                child: Text('test')),
            TextButton(
                onPressed: () {
                  _controller.querySessionList();
                },
                child: Text('test2'))
          ],
          title: Text(
            '消息',
            style: TextStyle(
                color: MyColor.blackColor, fontSize: ScreenUtil().setSp(18)),
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const MyClassicHeader(),
          footer: const MyClassicFooter(),
          // 配置默认底部指示器
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: _getListView(),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  void _onRefresh() async {
    logger.i("_onRefresh");
    _list = await _controller.querySessionList();
    _refreshController.refreshCompleted();
  }

  Widget _getListView() {
    int length = _list.length;
    List<Widget> listView = [_systemItem()];
    for (int i = 0; i < length; i++) {
      listView.add(_chatItemView(_list[i]));
    }
    return ListView(
      children: listView,
    );
  }

  Widget _systemItem() {
    return TextButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(0, 0)),
            visualDensity: VisualDensity.compact,
            padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: () {
          logger.i("itemclick");
          getUserInfo();
        },
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setHeight(76),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 16, 16, 16),
                child: Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4, right: 2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              "assets/images/ic_launcher.png",
                              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
                              width: ScreenUtil().setWidth(44),
                              height: ScreenUtil().setWidth(44),
                            ),
                          ),
                        ),
                        Obx(() => _controller.unReadSystemMsg > 0
                            ? Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(14),
                                height: ScreenUtil().setWidth(14),
                                child: Text('${_controller.unReadSystemMsg}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(8))),
                                decoration: BoxDecoration(
                                    color: Color(0xffFD4343),
                                    borderRadius: BorderRadius.circular(8)))
                            : Container()),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        singeLineText(
                            '官方小助手',
                            _textContextWidth,
                            TextStyle(
                                color: Color(0xff000014),
                                fontSize: ScreenUtil().setSp(14))),
                        Obx(() => singeLineText(
                            _controller.newSystemMsg.value,
                            _textContextWidth,
                            TextStyle(
                                color: Color(0xff8C8C8C),
                                fontSize: ScreenUtil().setSp(12)))),
                      ],
                    ),
                    Expanded(child: Align()),
                    Obx(() => singeLineText(
                        _controller.newSystemMsgTime.value,
                        _textContextWidth,
                        TextStyle(
                            color: Color(0xff8C8C8C),
                            fontSize: ScreenUtil().setSp(12)))),
                  ],
                ),
              ),
            ),
            HDivider(
              padding: EdgeInsets.only(left: 16),
              width: double.infinity,
              height: 1,
            ),
          ],
        ));
  }

  Widget _chatItemView(NIMSession session) {
    return TextButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(0, 0)),
            visualDensity: VisualDensity.compact,
            padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: () {
          logger.i("itemclick");
        },
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setHeight(76),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 16, 16, 16),
                child: Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4, right: 2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              "assets/images/ic_launcher.png",
                              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
                              width: ScreenUtil().setWidth(44),
                              height: ScreenUtil().setWidth(44),
                            ),
                          ),
                        ),
                        session.unreadCount > 0
                            ? Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(14),
                                height: ScreenUtil().setWidth(14),
                                child: Text(
                                    '${session.unreadCount > 99 ? 99 : session.unreadCount}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(8))),
                                decoration: BoxDecoration(
                                    color: Color(0xffFD4343),
                                    borderRadius: BorderRadius.circular(8)))
                            : Container()
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        singeLineText(
                            '${session.senderNickname}',
                            _textContextWidth,
                            TextStyle(
                                color: Color(0xff000014),
                                fontSize: ScreenUtil().setSp(14))),
                        singeLineText(
                            '信息',
                            _textContextWidth,
                            TextStyle(
                                color: Color(0xff8C8C8C),
                                fontSize: ScreenUtil().setSp(12))),
                      ],
                    ),
                    Expanded(child: Align()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => _controller.isCanChat.value
                            ? Image.asset('assets/images/lock.png')
                            : Text('')),
                        Obx(() => singeLineText(
                            _controller.newSystemMsgTime.value,
                            _textContextWidth,
                            TextStyle(
                                color: Color(0xff8C8C8C),
                                fontSize: ScreenUtil().setSp(12)))),
                      ],
                    )
                  ],
                ),
              ),
            ),
            HDivider(
              padding: EdgeInsets.only(left: 16),
              width: double.infinity,
              height: 1,
            ),
          ],
        ));
  }

  Widget headImg(String imaUrl) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(4)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: SizedBox(
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setWidth(114),
          child: CachedNetworkImage(
            fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            imageUrl: imaUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/image_load_failed.png',
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            ),
          )),
    );
  }
}
