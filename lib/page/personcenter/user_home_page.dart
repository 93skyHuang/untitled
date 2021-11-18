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
import 'package:untitled/page/chat/chat_page.dart';
import 'package:untitled/page/mine/myhome/album_list_page.dart';
import 'package:untitled/page/personcenter/trend_detail_page.dart';
import 'package:untitled/page/personcenter/user_home_controller.dart';
import 'package:untitled/page/report/report_page.dart';
import 'package:untitled/page/video_play_page.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_trend.dart';
import 'package:untitled/widget/item_video.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/toast.dart';

import '../../route_config.dart';
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
      backgroundColor: Color(0xff242932),
      body: buildNestedScrollView(),
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
            backgroundColor: Color(0xff242932),
            elevation: 0,
            actions: [
              IconButton(
                  icon: Icon(Icons.more_vert, size: 28, color: Colors.white),
                  onPressed: () {
                    showMore(context, uid);
                  }),
            ],

            ///是否随着滑动隐藏标题
            floating: true,

            ///SliverAppBar展开的高度
            expandedHeight: ScreenUtil().setHeight(378),
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
        new TabController(length: 4, vsync: this, initialIndex: initialIndex);
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        InfoPage(uid),
        Obx(
          () => Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ItemTrend(
                  trends: _userHomeController.trends.value[index],
                  onPressed: () {
                    Get.to(TrendDetailPage(
                        _userHomeController.trends.value[index].id));
                  },
                  clickLike: () {
                    clickLike(_userHomeController.trends.value[index]);
                  },
                  deleteTrend: null,
                );
              },
              itemCount: _userHomeController.trends.value.length,
            ),
          ),
        ),
        Obx(
          () => Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Trends trends = _userHomeController.videoTrends.value[index];
                return ItemVideo(
                  trends: trends,
                  onPressed: () {
                    Get.to(TrendVideoPlayPage(), arguments: {
                      'videoUrl': trends.video,
                      'trendsId': trends.id
                    });
                  },
                );
              },
              itemCount: _userHomeController.videoTrends.value.length,
            ),
          ),
        ),
        AlbumListPage(uid),
      ],
    );
  }

  PreferredSize buildTabBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
            color: Color(0xff242932),
            child: TabBar(
              labelColor: Color(0xff6385FF),
              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(17)),
              labelPadding: EdgeInsets.zero,
              unselectedLabelColor: Color(0xff7581A8),
              unselectedLabelStyle: TextStyle(fontSize: ScreenUtil().setSp(13)),
              indicatorWeight: 3,
              // indicatorPadding: EdgeInsets.only(left: 14, right: 14),
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

  void clickLike(Trends trends) {
    if (trends.isTrendsFabulous == 0) {
      addTrendsFabulous(trends.id).then((value) => {
            if (value.isOk())
              {
                _userHomeController.getInfo(uid),
              }
          });
    } else {
      deleteTrendsFabulous(trends.id).then((value) => {
            if (value.isOk())
              {
                _userHomeController.getInfo(uid),
              }
          });
    }
  }

  FlexibleSpaceBar buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
        background: Container(
      height: ScreenUtil().setHeight(378),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(
              onTap: () {
                Get.toNamed(photoViewPName, arguments: {
                  'index': 1,
                  'photoList': [_userHomeController.imgUrl.value]
                });
              },
              child: Obx(() => cardNetworkImage(
                  _userHomeController.imgUrl.value,
                  double.infinity,
                  ScreenUtil().setHeight(378),
                  radius: 0,
                  margin: EdgeInsets.all(0),
                  fit: BoxFit.cover))),
          Container(
            color: Color(0x40707070),
            height: ScreenUtil().setHeight(378),
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight + 55),
                Obx(() => ClipOval(
                    child: GestureDetector(
                        onTap: () {
                          Get.toNamed(photoViewPName, arguments: {
                            'index': 1,
                            'photoList': [_userHomeController.imgUrl.value]
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          child: cardNetworkImage(
                              _userHomeController.imgUrl.value,
                              double.infinity,
                              ScreenUtil().setHeight(317),
                              radius: 0,
                              margin: EdgeInsets.all(0),
                              fit: BoxFit.cover),
                        )))),
                Obx(() => Padding(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                    child: Text(
                      '${_userHomeController.cname.value}',
                      style: TextStyle(color: Color(0xffFFF9F9), fontSize: 20),
                    ))),
                Obx(() => Padding(
                      padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: Text(
                        '${_userHomeController.autograph.value}',
                        style:
                            TextStyle(color: Color(0xffF5F5F5), fontSize: 14),
                      ),
                    )),
              ],
            ),
          ),
          Obx(() => Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 70),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          child: GestureDetector(
                            onTap: () {
                              if (_userHomeController
                                      .userBasic.value.isFollow ==
                                  0) {
                                _userHomeController.add();
                              } else {
                                showBottomOpen(context);
                              }
                            },
                            child: Row(
                              children: [
                                if (_userHomeController
                                        .userBasic.value.isFollow ==
                                    0)
                                  Image(
                                    width: 18,
                                    height: 18,
                                    image:
                                        AssetImage("assets/images/ic_like.png"),
                                  ),
                                CustomText(
                                  text: _userHomeController
                                              .userBasic.value.isFollow ==
                                          0
                                      ? '关注'
                                      : '已关注',
                                  textAlign: Alignment.center,
                                  margin: EdgeInsets.only(left: 3),
                                  textStyle: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          height: 35,
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          decoration: new BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(23.0)),
                            color: Color(0xffFF8B00),
                          )),
                      Container(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(ChatPage(), arguments: {
                                'uid': _userHomeController.userBasic.value.uid
                              });
                            },
                            child: Row(
                              children: [
                                Image(
                                  width: 18,
                                  height: 18,
                                  image:
                                      AssetImage("assets/images/ic_chat.png"),
                                ),
                                CustomText(
                                  text: '私聊',
                                  textAlign: Alignment.center,
                                  margin: EdgeInsets.only(left: 3),
                                  textStyle: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.only(left: 50, right: 16),
                          height: 35,
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          decoration: new BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(23.0)),
                            color: Color(0xff9943FD),
                          )),
                    ],
                  ),
                ),
              ))
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

  void showMore(BuildContext context, int uid) {
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
                                Get.to(ReportPage(uid))!
                                    .then((value) => Navigator.pop(context));
                              },
                              child: CustomText(
                                  text: "举报",
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
                                addBlack(uid);
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "拉黑",
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
                                  padding: EdgeInsets.only(top: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Color(0xffFD4343)))),
                        ]))
                  ]));
        });
  }

  void addBlack(int userId) {
    addPullBlack(userId).then((value) => {
          if (value.isOk()) {MyToast.show('拉黑成功'), Navigator.pop(context)}
        });
  }
}
