//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:untitled/basic/include.dart';

import 'find_controller.dart';

/**
 * 发现页面列表页面 需要传入发现id
 */
class MyImageListView extends GetView<FindController>{
  int id;

  MyImageListView(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i(id);
    return ListView(
      children: [
        ListTile(
          title: Text("第一个tab"),
        ),
        ListTile(
          title: Text("第一个tab"),
        ),
      ],
    );
  }
}
