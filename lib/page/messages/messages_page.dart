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
import 'package:untitled/page/chat/chat_page.dart';
import 'package:untitled/page/global_controller.dart';
import 'package:untitled/page/messages/messages_page_bean.dart';
import 'package:untitled/page/messages/system_msg_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/dialog.dart';
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
  List<MsgPageBean> _list = [];
  final double _textContextWidth =
      ScreenUtil().screenWidth - ScreenUtil().setWidth(180);

  @override
  void initState() {
    logger.i('initState');
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _onRefresh();
      _controller.pageChangeListener((listBean) {
        _list = listBean;
        setState(() {});
      });
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
          title: Text(
            '消息',
            style: TextStyle(
                color: MyColor.blackColor, fontSize: ScreenUtil().setSp(18)),
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: const MyClassicHeader(),
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
    setState(() {});
    _list = await _controller.getNewInfo();
    setState(() {});
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
          Get.to(SystemMsgPage(_controller.systemAvatar.value));
        },
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setHeight(70),
              child: Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(12), ScreenUtil().setHeight(8), ScreenUtil().setWidth(16), ScreenUtil().setHeight(8)),
                child: Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(6), right: ScreenUtil().setWidth(6)),
                          child: cardNetworkImage(
                            _controller.systemAvatar.value,
                            ScreenUtil().setWidth(44),
                            ScreenUtil().setWidth(44),
                            margin:EdgeInsets.all(0),
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
                    SizedBox(
                      width: 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        singeLineText(
                            _controller.systemName.value,
                            _textContextWidth,
                            TextStyle(
                                color: Color(0xff000014),
                                fontSize: ScreenUtil().setSp(14))),
                        SizedBox(
                          height: 5,
                        ),
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

  Widget _chatItemView(MsgPageBean info) {
    return TextButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(0, 0)),
            visualDensity: VisualDensity.compact,
            padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: () {
          bool isSvip = GetStorageUtils.getSvip();
          if (!isSvip) {
            showOpenSvipDialog(context);
          } else {
            _goToChatPage(info.getUid());
          }
        },
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setHeight(66),
              child: Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(12), ScreenUtil().setHeight(8), ScreenUtil().setWidth(16), ScreenUtil().setHeight(8)),
                child: Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(6), right: ScreenUtil().setWidth(6)),
                          child: cardNetworkImage(
                              info.heardUrl,
                              ScreenUtil().setWidth(44),
                              ScreenUtil().setWidth(44),
                              margin:EdgeInsets.all(0),
                              errorImagesUrl: 'assets/images/user_icon.png'),
                        ),
                        info.unreadMsgNum > 0
                            ? Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(14),
                                height: ScreenUtil().setWidth(14),
                                child: Text(
                                    '${info.unreadMsgNum > 99 ? 99 : info.unreadMsgNum}',
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
                    SizedBox(
                      width: 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        singeLineText(
                            '${info.nickName}',
                            _textContextWidth,
                            TextStyle(
                                color: Color(0xff000014),
                                fontSize: ScreenUtil().setSp(14))),
                        SizedBox(
                          height: 5,
                        ),
                        singeLineText(
                            '${info.getInfo()}',
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
                        Obx(() => Get.find<GlobalController>().isSvip.value
                            ? Text('')
                            : Image.asset('assets/images/lock.png')),
                        singeLineText(
                            info.time,
                            _textContextWidth,
                            TextStyle(
                                color: Color(0xff8C8C8C),
                                fontSize: ScreenUtil().setSp(12))),
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

  void _goToChatPage(int uid) async {
    Get.to(ChatPage(), arguments: {'uid': uid})?.then((value) => {

    });
  }
}
