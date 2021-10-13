import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/page/community/recommend_widget.dart';
import 'package:untitled/page/community/video_widget.dart';
import 'package:untitled/widgets/null_list_widget.dart';

import 'focus_on_widget.dart';


///社区页面content布局
class CommunityTabBarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('CommunityTabBarView');
    return TabBarView(children: _list());
  }

  List<Widget> _list() {
    List<Widget> list = [RecommendWidget(),VideoWidget(),FocusOnWidget()];
    return list;
  }
}
