import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/page/find/find_page.dart';

import 'community/community_page.dart';
import 'home_controller.dart';
import 'messages/messages_page.dart';
import 'mine/mine_page.dart';
import 'nearby/nearby_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  HomeController homeController = Get.put(HomeController());

  int _currentIndex = 0;
  final List<Widget> _pageList = [
    FindPage(),
    CommunityPage(),
    NearbyPage(),
    MessagesPage(),
    MinePage(),
  ];
  final List<BottomNavigationBarItem> _barItem = [
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/find_uncheck.png",
        ),
        activeIcon: Image.asset(
          "assets/images/find_checked.png",
        ),
        label: '发现'),
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/community_uncheck.png",
        ),
        activeIcon: Image.asset(
          "assets/images/community_checked.png",
        ),
        label: '社区'),
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/nearby_uncheck.png",
        ),
        activeIcon: Image.asset(
          "assets/images/nearby_checked.png",
        ),
        label: '附近'),
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/messages_uncheck.png",
        ),
        activeIcon: Image.asset(
          "assets/images/messages_checked.png",
        ),
        label: '消息'),
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/mine_uncheck.png",
        ),
        activeIcon: Image.asset(
          "assets/images/mine_checked.png",
        ),
        label: '我的'),
  ];

  void init(BuildContext context) {
    //设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(360, 690),
        orientation: Orientation.portrait);
  }

  @override
  Widget build(BuildContext context) {
    // init(context);
    return Scaffold(
      ///使用这个才能保证子页面持久化
      body: IndexedStack(
        index: _currentIndex,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        currentIndex: _currentIndex,
        items: _barItem,
        iconSize: ScreenUtil().setWidth(20),
        fixedColor: MyColor.redFd4343,
        selectedFontSize: ScreenUtil().setSp(10),
        unselectedFontSize: ScreenUtil().setSp(10),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
