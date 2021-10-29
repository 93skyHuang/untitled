import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_trend.dart';
import 'package:untitled/widget/item_video.dart';

import 'info_page.dart';
import 'my_home_controller.dart';

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
        Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ItemTrend(
                trends: _myHomeController.trends.value[index],
                onPressed: () {},
                onDelete: () {},
              );
            },
            itemCount: _myHomeController.trends.value.length,
          ),
        ),
        Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ItemVideo(
                trends: _myHomeController.videoTrends.value[index],
                onPressed: () {},
                onDelete: () {},
              );
            },
            itemCount: _myHomeController.videoTrends.value.length,
          ),
        ),
        InfoPage(_myHomeController),
      ],
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      labelColor: Color(0xffFD4343),
      labelStyle: TextStyle(fontSize: 14),
      unselectedLabelColor: MyColor.grey8C8C8C,
      unselectedLabelStyle: TextStyle(fontSize: 14),
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: MyColor.redFd4343,
      controller: tabController,
      padding: EdgeInsets.only(right: 120),
      tabs: <Widget>[
        new Tab(
          text: "动态",
        ),
        new Tab(
          text: "视频",
        ),
        new Tab(
          text: "个人资料",
        ),
      ],
    );
  }

  FlexibleSpaceBar buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
        background: Container(
      height: 415,
      child: Column(
        children: [
          Container(
            height: 365,
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                NetworkImage(
                  "${_myHomeController.userBasic.value.headImgUrl ?? ''}",
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
