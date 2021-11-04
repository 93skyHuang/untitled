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
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/page/chat/chat_page.dart';
import 'package:untitled/page/messages/messages_page_bean.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/utils/time_utils.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/dialog.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/my_text_widget.dart';
import 'package:untitled/widgets/null_list_widget.dart';

import 'messages_controller.dart';

//消息页面
class SystemMsgPage extends StatefulWidget {
  const SystemMsgPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SystemMsgPageState();
  }
}

class _SystemMsgPageState extends State<SystemMsgPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<NIMMessage> _list = [];

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
          leading: new IconButton(
              icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
              onPressed: () {
                Navigator.maybePop(context);
              }),
          elevation: 0.5,
          title: Text(
            '系统消息',
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
          onLoading: _onLoad,
          child: _getListView(),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  void _onRefresh() {
    logger.i("_onRefresh");
    queryHistoryMsg();
  }

  void _onLoad() {
    queryMoreHistoryMsg();
  }

  Widget _getListView() {
    int length = _list.length;
    List<Widget> listView = [];
    for (int i = 0; i < length; i++) {
      listView.add(_systemItem(_list[i]));
    }
    return ListView(
      children: listView,
    );
  }

  Widget _systemItem(NIMMessage nimMessage) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: ScreenUtil().screenWidth * 0.7),
                child: Text("${nimMessage.content}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: Text(TimeUtils.dateAndTimeToString(nimMessage.timestamp),
                    style: TextStyle(fontSize: 14, color: Color(0xff8C8C8C))),
              )),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            height: 1,
            color: MyColor.dividerColor2,
          )
        ],
      ),
    );
  }

  void queryHistoryMsg() async {
    final result = await NimNetworkManager.instance.queryHistoryMsg(sysUid);
    if (result.isSuccess) {
      _refreshController.refreshCompleted();
      List<NIMMessage> list = result.data ?? [];
      if (list.isNotEmpty) {
        _list.clear();
        list.sort((nim1, nim2) => nim2.timestamp.compareTo(nim1.timestamp));
        _list.addAll(list);
        setState(() {});
        NimNetworkManager.instance.sendMessageReceipt(sysUid, _list[0]);
      }
    } else {
      _refreshController.refreshFailed();
    }
  }

  void queryMoreHistoryMsg() async {
    final result = await NimNetworkManager.instance
        .queryMoreHistoryMsg(_list[_list.length]);
    if (result.isSuccess) {
      List<NIMMessage> list = result.data ?? [];
      if (list.isNotEmpty) {
        _refreshController.loadComplete();
        _list.addAll(list);
        setState(() {});
      } else {
        _refreshController.loadNoData();
      }
    } else {
      _refreshController.loadFailed();
    }
  }
}
