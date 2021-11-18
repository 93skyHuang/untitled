import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/page/video_play_page.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_trend.dart';
import 'package:untitled/widget/item_video.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/toast.dart';

import '../../../route_config.dart';
import 'info_page.dart';
import 'my_home_controller.dart';
import 'my_trend_detail_page.dart';

//个人首页页面
class MyHomePage extends StatefulWidget {
  ///进来显示的信息 0动态、1、视频 2、个人信息
  int initIndex = 0;

  MyHomePage({Key? key, this.initIndex = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState(initIndex);
  }
}

class _MyHomePageState extends State with SingleTickerProviderStateMixin {
  final MyHomeController _myHomeController = Get.put(MyHomeController());
  int initIndex = 0;

  _MyHomePageState(this.initIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => buildNestedScrollView()),
    );
  }

  ///构建滑动布局
  NestedScrollView buildNestedScrollView() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool b) {
        return [
          SliverAppBar(
            ///true SliverAppBar 不会滑动
            pinned: true,
            leading: IconButton(
                icon: Icon(Icons.chevron_left, size: 38, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: CustomText(
              text: '${_myHomeController.userBasic.value.cname}',
              textAlign: Alignment.topLeft,
              textStyle: TextStyle(fontSize: 17, color: Colors.white),
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
            ),
            backgroundColor: Colors.white,
            elevation: 0,

            ///是否随着滑动隐藏标题
            floating: true,

            ///SliverAppBar展开的高度
            expandedHeight: 375,
            flexibleSpace: buildFlexibleSpaceBar(),
            bottom: buildTabBar(),
          ),
        ];
      },

      ///主体部分
      body: buildTabBarView(),
    );
  }

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        new TabController(length: 3, vsync: this, initialIndex: initIndex);
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        InfoPage(_myHomeController),
        Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              Trends trends = _myHomeController.trends[index];
              return ItemTrend(
                trends: trends,
                onPressed: () {
                  Get.to(MyTrendDetailPage(trends.id));
                },
                clickLike: () {},
                deleteTrend: () {
                  showOpenDelDialog(context, trends);
                },
              );
            },
            itemCount: _myHomeController.trends.length,
          ),
        ),
        Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              Trends trends = _myHomeController.videoTrends[index];
              return ItemVideo(
                trends: trends,
                onPressed: () {
                  Get.to(TrendVideoPlayPage(), arguments: {
                    "videoUrl": trends.video,
                    "trendsId": trends.id,
                  });
                },
                deleteTrend: () {
                  showOpenDelDialog(context, trends);
                },
              );
            },
            itemCount: _myHomeController.videoTrends.value.length,
          ),
        ),
        Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              Trends trends = _myHomeController.videoTrends[index];
              return ItemVideo(
                trends: trends,
                onPressed: () {
                  Get.to(TrendVideoPlayPage(), arguments: {
                    "videoUrl": trends.video,
                    "trendsId": trends.id,
                  });
                },
                deleteTrend: () {
                  showOpenDelDialog(context, trends);
                },
              );
            },
            itemCount: _myHomeController.videoTrends.value.length,
          ),
        ),
      ],
    );
  }

  PreferredSize buildTabBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Material(
            color: Colors.white,
            child: TabBar(
              labelColor: Color(0xff6385FF),
              labelStyle: TextStyle(fontSize: 20),
              unselectedLabelColor: Color(0xff7581A8),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Color(0xff6385FF),
              controller: tabController,
              // padding: EdgeInsets.only(right: ScreenUtil().setWidth(100)),
              tabs: <Widget>[
                new Tab(
                  text: "个人资料",
                ),
                new Tab(
                  text: "动态",
                ),
                new Tab(
                  text: "视频",
                ),
                new Tab(
                  text: "相册",
                ),
              ],
            )));
  }

  FlexibleSpaceBar buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
        background: Container(
      height: ScreenUtil().setHeight(317),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          cardNetworkImage('${_myHomeController.userBasic.value.headImgUrl}',
              double.infinity, ScreenUtil().setHeight(317),
              radius: 0, margin: EdgeInsets.all(0), fit: BoxFit.cover),
          Container(
            color: Colors.black12,
            height: ScreenUtil().setHeight(317),
            width: double.infinity,
          ),
          Column(
            children: [
              ClipOval(
                  child: GestureDetector(
                      onTap: () {
                        Get.toNamed(photoViewPName, arguments: {
                          'index': 1,
                          'photoList': [
                            _myHomeController.userBasic.value.headImgUrl ?? ''
                          ]
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        child: cardNetworkImage(
                            '${_myHomeController.userBasic.value.headImgUrl}',
                            double.infinity,
                            ScreenUtil().setHeight(317),
                            radius: 0,
                            margin: EdgeInsets.all(0),
                            fit: BoxFit.cover),
                      ))),
              Text(
                '${_myHomeController.userBasic.value.cname}',
                style: TextStyle(color: Color(0xffFFF9F9), fontSize: 20),
              ),
              Text(
                '${_myHomeController.userBasic.value.autograph}',
                style: TextStyle(color: Color(0xffF5F5F5), fontSize: 14),
              ),
              SizedBox(
                height: 34,
              )
            ],
          ),
        ],
      ),
    ));
  }

  showOpenDelDialog(BuildContext context, Trends trends) {
    //设置按钮
    Widget cancelButton = TextButton(
      child: Text(
        "取消",
        style: TextStyle(color: MyColor.grey8C8C8C),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      style: ButtonStyle(
          //去除点击效果
          // overlayColor: MaterialStateProperty.all(Colors.transparent),
          minimumSize: MaterialStateProperty.all(const Size(0, 0)),
          visualDensity: VisualDensity.compact,
          padding:
              MaterialStateProperty.all(EdgeInsets.only(left: 6, right: 6)),
          //圆角
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
          //背景
          backgroundColor: MaterialStateProperty.all(MyColor.mainColor)),
      child: Text(
        "确定",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
        // Get.to();
        del(trends);
      },
    );

    //设置对话框
    AlertDialog alert = AlertDialog(
      title: Text("删除动态"),
      content: Text("您确定要删除这条动态？删除后将无法恢复相关信息。"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    //显示对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void del(Trends trends) async {
    final result = await delTrends(trends.id);
    if (result.isOk()) {
      if (trends.type == 2) {
        _myHomeController.videoTrends.value.remove(trends);
      } else {
        _myHomeController.trends.value.remove(trends);
      }
      setState(() {});
    } else {
      MyToast.show(result.msg);
    }
  }
}
