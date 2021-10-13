import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/find/my_tab_bar_view.dart';
import 'package:untitled/utils/image_picker_util.dart';

import 'find_controller.dart';
import 'my_tab_bar.dart';

//发现页面
class FindPage extends StatefulWidget {
  FindPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FindPageState();
  }
}

class _FindPageState extends State<FindPage> with AutomaticKeepAliveClientMixin{
  final FindController _findController = Get.put(FindController());

  @override
  Widget build(BuildContext context) {
    // 105324
    logger.i('FindPage');
    return Obx(() => DefaultTabController(
          length: _findController.findTabList.length,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Row(
                children: [
                  Expanded(
                    child: MyTabBar(),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
            ),
            body: MyTabBarView(),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
