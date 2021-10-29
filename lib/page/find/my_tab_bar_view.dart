import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:untitled/basic/include.dart';

import 'find_controller.dart';
import 'my_find_list_widget.dart';

///发现页面content布局
class MyTabBarView extends GetView<FindController> {
  bool isSvip;

  MyTabBarView({Key? key, this.isSvip = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('MyTabBarView');
    return TabBarView(children: _list());
  }

  List<Widget> _list() {
    List<Widget> list = [];
    if(controller.findTabList.isNotEmpty){
      int length = isSvip ? controller.findTabList.length : 1;
      for (int i = 0; i < length; i++) {
        list.add(MyFindListWidget(
          controller.findTabList[i].id,
          isSvip: isSvip,
        ));
      }
    }
    return list;
  }
}
