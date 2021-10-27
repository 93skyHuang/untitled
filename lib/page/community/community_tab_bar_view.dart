import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/page/community/recommend_page.dart';
import 'package:untitled/page/community/video_page.dart';
import 'package:untitled/page/home_controller.dart';
import 'package:untitled/widgets/null_list_widget.dart';

import 'focus_on_widget.dart';

///社区页面content布局
class CommunityTabBarView extends StatelessWidget {
  bool isSvip;

  CommunityTabBarView({Key? key, this.isSvip = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('CommunityTabBarView');
    return TabBarView(children: _list());
  }

  List<Widget> _list() {
    List<Widget> list = isSvip
        ? [RecommendWidget(), VideoListPage(), FocusOnPage()]
        : [RecommendWidget()];
    return list;
  }
}
