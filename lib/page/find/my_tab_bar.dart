//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/page/home_controller.dart';

import 'find_controller.dart';

class MyTabBar extends GetView<FindController> {
  MyTabBar({Key? key, this.isSvip = false}) : super(key: key);
  bool isSvip;

  @override
  Widget build(BuildContext context) {
    logger.i('MyTabBar $isSvip');
    return TabBar(
        labelColor: MyColor.blackColor,
        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(20)),
        unselectedLabelColor: MyColor.grey8C8C8C,
        unselectedLabelStyle: TextStyle(fontSize: ScreenUtil().setSp(15)),
        indicatorWeight: 4,
        indicatorColor: MyColor.redFd4343,
        isScrollable: true,
        //多个按钮可以滑动
        tabs: getTabs());
  }

  List<Widget> getTabs() {
    List<Widget> list = [];
    if (controller.findTabList.isNotEmpty) {
      int length = isSvip ? controller.findTabList.length : 1;
      for (int i = 0; i < length; i++) {
        list.add(Tab(
          text: controller.findTabList[i].title,
        ));
      }
    }
    return list;
  }
}
