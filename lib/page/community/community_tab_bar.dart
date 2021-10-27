//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/page/home_controller.dart';

class CommunityTabBar extends StatelessWidget {
  bool isSvip;

  CommunityTabBar({Key? key, this.isSvip = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('CommunityTabBar');
    return TabBar(
        labelColor: MyColor.blackColor,
        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(20)),
        unselectedLabelColor: MyColor.grey8C8C8C,
        unselectedLabelStyle: TextStyle(fontSize: ScreenUtil().setSp(15)),
        indicatorWeight: 4,
        indicatorColor: MyColor.redFd4343,
        isScrollable: true,
        //多个按钮可以滑动
        tabs: isSvip
            ? const [
                Tab(
                  text: '推荐',
                ),
                Tab(
                  text: '视频',
                ),
                Tab(
                  text: '关注',
                ),
              ]
            : [
                Tab(
                  text: '推荐',
                )
              ]);
  }
}
