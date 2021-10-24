import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/network/bean/nearby_info.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/widgets/bottom_pupop.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/my_text_widget.dart';
import 'package:untitled/widgets/null_list_widget.dart';

import '../messages/messages_controller.dart';
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

  @override
  void initState() {
    super.initState();
    //聊天用户的uid
    UserBasic userBasic = Get.arguments as UserBasic;
    _controller.setUserBasic(userBasic);
  }

  @override
  Widget build(BuildContext context) {
    logger.i('MessagesPage');
    return Scaffold(
        backgroundColor: MyColor.pageBgColor,
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  _controller.sendTextMessage('合同健康会2');
                },
                child: Text('test'))
          ],
          elevation: 0.5,
          leading: new IconButton(
              icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
              onPressed: () {
                Navigator.maybePop(context);
              }),
          centerTitle: true,
          backgroundColor: MyColor.pageBgColor,
          title: Text(
            '${_controller.userBasic.cname}',
            style: TextStyle(
                color: MyColor.blackColor, fontSize: ScreenUtil().setSp(18)),
          ),
        ),
        body: Stack(
          children: [
            _userCard(),
            // SmartRefresher(
            //   enablePullDown: true,
            //   enablePullUp: true,
            //   header: const MyClassicHeader(),
            //   footer: const MyClassicFooter(),
            //   // 配置默认底部指示器
            //   controller: _refreshController,
            //   onRefresh: _onRefresh,
            //   onLoading: _onLoading,
            //   child: _getListView(),
            // )
          ],
        ));
  }

  Widget _userCard() {
    return Container(
      margin: EdgeInsets.all(4),
      width: double.infinity,
      height: ScreenUtil().setHeight(_controller.treadLength() > 0 ? 235 : 130),
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
            top: ScreenUtil().setWidth(10),
            left: ScreenUtil().setWidth(4),
            right: ScreenUtil().setWidth(10),
            bottom: ScreenUtil().setWidth(10),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              GestureDetector(
                child: _headImg(_controller.userBasic.headImgUrl ?? ''),
                onTap: () {
                  logger.i('点击头像');
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    singeLineText(
                        '${_controller.userBasic.cname}',
                        ScreenUtil().setWidth(90),
                        TextStyle(
                            color: MyColor.blackColor,
                            fontSize: ScreenUtil().setSp(14))),
                    _info2(), //信息
                    _info3(), //认证
                  ],
                ),
              ),
              Expanded(child: Container()),
              focusWidget(),
            ]),
            SizedBox(height: 10),

            ///动态
            _info4(),
          ])),
    );
  }

  Widget _info2() {
    return Row(
      children: [
        Text(
          '${_controller.userBasic.age}岁',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10)),
        ),
        '${_controller.userBasic.constellation}'.isNotEmpty
            ? VDivider()
            : Container(),
        Text(
          '${_controller.userBasic.constellation}',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10)),
        ),
        VDivider(),
        Text(
          '${_controller.userBasic.height}cm',
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
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/image_load_failed.png',
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            ),
          )),
    );
  }

  ///认证
  Widget _info3() {
    return Row(
      children: [
        _controller.userBasic.isVideo == 1
            ? Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset('assets/images/icon_verified_person.png'),
              )
            : Container(),
        _controller.userBasic.isHead == 1
            ? Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset('assets/images/icon_verified_avatar.png'),
              )
            : Container(),
        _controller.userBasic.isCard == 1
            ? Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset('assets/images/icon_verified_name'),
              )
            : Container(),
        Image.asset('assets/images/icon_verified_phone.png')
      ],
    );
  }

  Widget focusWidget() {
    if (_controller.userBasic.isFollow == 1) {
      return Container(
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
        child: InkWell(
            onTap: () {
              showBottomCancelFocus(context, () {
                _controller.del();
              });
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '已关注',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(12),
                  color: MyColor.redFd4343,
                ),
              ),
            ])),
      );
    } else {
      //关注按钮
      return Container(
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
        child: InkWell(
            onTap: () {
              _controller.add();
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(6))),
            ])),
      );
    }
  }

  ///动态图
  Widget _info4() {
    var list = _controller.userBasic.trendsList;
    List<Widget> listWidget = [];
    int length = _controller.treadLength();
    if (length > 0) {
      for (int i = 0; i < length && i < 3; i++) {
        listWidget.add(_infoTrends(list![i]));
      }
    }
    return length == 0
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              singeLineText(
                  '最新个人动态',
                  ScreenUtil().screenWidth / 2,
                  TextStyle(
                      color: MyColor.grey8C8C8C,
                      fontSize: ScreenUtil().setSp(12))),
              SizedBox(height: 16),
              Row(
                children: listWidget,
              )
            ],
          );
  }

  ///动态
  Widget _infoTrends(Trends? trendsImg) {
    String url = trendsImg?.imgArr?.first ?? '';
    return url.isEmpty
        ? Container()
        : GestureDetector(
            child: cardNetworkImage(
                url, ScreenUtil().setWidth(100), ScreenUtil().setWidth(100),
                radius: 8),
            onTap: () {
              logger.i(trendsImg);
            },
          );
  }
}
