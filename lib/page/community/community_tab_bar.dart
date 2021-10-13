//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';

class CommunityTabBar extends StatelessWidget {
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
        tabs: const [
          Tab(
            text: '推荐',
          ),
          Tab(
            text: '视频',
          ),
          Tab(
            text: '关注',
          ),
        ]);
  }
}
