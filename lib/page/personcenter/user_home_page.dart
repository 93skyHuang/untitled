import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/chat/chat_page.dart';
import 'package:untitled/page/personcenter/user_home_controller.dart';
import 'package:untitled/page/video_play_page.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_trend.dart';
import 'package:untitled/widget/item_video.dart';
import 'package:untitled/widgets/toast.dart';

import 'info_page.dart';

//他人首页页面
class UserHomePage extends StatefulWidget {
  int uid;
  int initialIndex;

  UserHomePage({required this.uid, Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserHomePageState(this.uid, this.initialIndex);
  }
}

class _UserHomePageState extends State with SingleTickerProviderStateMixin {
  _UserHomePageState(this.uid, this.initialIndex);

  final UserHomeController _userHomeController = Get.put(UserHomeController());
  int uid;
  int initialIndex;

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
              text: '${_userHomeController.userBasic.value.cname}',
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
    _userHomeController.getInfo(uid);
    tabController =
        new TabController(length: 3, vsync: this, initialIndex: initialIndex);
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ItemTrend(
                trends: _userHomeController.trends.value[index],
                onPressed: () {},
                clickLike: () {
                  clickLike(_userHomeController.trends.value[index]);
                },
                deleteTrend: null,
              );
            },
            itemCount: _userHomeController.trends.value.length,
          ),
        ),
        Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ItemVideo(
                trends: _userHomeController.videoTrends.value[index],
                onPressed: () {
                  Get.to(TrendVideoPlayPage(), arguments: {
                    'videoTrendsInfo':
                        _userHomeController.videoTrends.value[index]
                  });
                },
              );
            },
            itemCount: _userHomeController.videoTrends.value.length,
          ),
        ),
        InfoPage(uid),
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

  void clickLike(Trends trends) {
    if (trends.beClickedSum == 0) {
      trends.beClickedSum = 1;
      trends.fabulousSum++;
      addTrendsFabulous(trends.id).then((value) => {
            if (value.isOk())
              {}
            else
              {
                trends.beClickedSum = 0,
                trends.fabulousSum--,
              }
          });
    } else {
      trends.beClickedSum = 0;
      trends.fabulousSum--;
      deleteTrendsFabulous(trends.id).then((value) => {
            if (!value.isOk())
              {
                MyToast.show(value.msg),
                trends.beClickedSum = 1,
                trends.fabulousSum++,
              }
          });
    }
  }

  FlexibleSpaceBar buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
        background: Container(
      height: 415,
      child: Column(
        children: [
          Container(
            height: 365,
            alignment: Alignment.bottomRight,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "${_userHomeController.userBasic.value.headImgUrl ?? ''}",
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    child: GestureDetector(
                      onTap: () {
                        if (_userHomeController.userBasic.value.isFollow == 0) {
                          _userHomeController.add();
                        } else {
                          showBottomOpen(context);
                        }
                      },
                      child: Row(
                        children: [
                          if (_userHomeController.userBasic.value.isFollow == 0)
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          CustomText(
                            text:
                                _userHomeController.userBasic.value.isFollow ==
                                        0
                                    ? '关注'
                                    : '已关注',
                            textAlign: Alignment.center,
                            margin: EdgeInsets.only(left: 3),
                            textStyle:
                                TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 20),
                    height: 35,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(23.0)),
                      color: Color(0xff9943FD),
                    )),
                Container(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(ChatPage());
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_outlined,
                            color: Colors.black,
                            size: 18,
                          ),
                          CustomText(
                            text: '私聊',
                            textAlign: Alignment.center,
                            margin: EdgeInsets.only(left: 3),
                            textStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
                    height: 35,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(23.0)),
                      color: Color(0xffF3CD8E),
                    )),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void showBottomOpen(BuildContext context) {
    showModalBottomSheet(
        enableDrag: false,
        elevation: 0,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                    ),
                    Container(
                        padding: EdgeInsets.only(bottom: 20.0, top: 16),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        child: Column(children: <Widget>[
                          CustomText(
                              text: "操作",
                              textAlign: Alignment.center,
                              padding: EdgeInsets.only(bottom: 16),
                              textStyle:
                                  TextStyle(fontSize: 17, color: Colors.black)),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                _userHomeController.del();
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "取消关注",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Colors.black))),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "取消",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Color(0xffFD4343)))),
                        ]))
                  ]));
        });
  }
}
