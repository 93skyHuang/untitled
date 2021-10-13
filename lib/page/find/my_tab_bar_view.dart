import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:untitled/basic/include.dart';

import 'find_controller.dart';
import 'my_find_list_widget.dart';

///发现页面content布局
class MyTabBarView extends GetView<FindController> {
  @override
  Widget build(BuildContext context) {
    logger.i('MyTabBarView');
    return TabBarView(children: _list());
  }

  List<Widget> _list() {
    List<Widget> list = [];
    int length = controller.findTabList.length;
    for (int i = 0; i < length; i++) {
      list.add(MyFindListWidget(controller.findTabList[i].id));
    }
    return list;
  }
}
