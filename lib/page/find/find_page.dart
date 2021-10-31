import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/find/my_tab_bar_view.dart';
import 'package:untitled/page/home_controller.dart';
import 'package:untitled/utils/image_picker_util.dart';

import 'find_controller.dart';
import 'my_find_list_widget.dart';
import 'my_tab_bar.dart';

//发现页面
class FindPage extends StatefulWidget {
  FindPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FindPageState();
  }
}

class _FindPageState extends State<FindPage>
    with AutomaticKeepAliveClientMixin ,SingleTickerProviderStateMixin{
  final FindController _findController = Get.put(FindController());
  final HomeController _homeController = Get.find();
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController=TabController(length: 4, vsync: this)..addListener(() {
        switch(_tabController.index){
          case 0:
            break;case 1:
            break;case 2:
            break;case 3:
            break;
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 105324
    logger.i('FindPage');
    return  Obx(()=>Scaffold(
      backgroundColor: MyColor.pageBgColor,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: TabBar(
                  controller: _tabController,
                  labelColor: MyColor.blackColor,
                  labelStyle: TextStyle(fontSize: ScreenUtil().setSp(20)),
                  unselectedLabelColor: MyColor.grey8C8C8C,
                  unselectedLabelStyle: TextStyle(fontSize: ScreenUtil().setSp(15)),
                  indicatorWeight: 4,
                  indicatorColor: MyColor.redFd4343,
                  isScrollable: true,
                  //多个按钮可以滑动
                  tabs: getTabs()),
            ),
          ],
        ),
        backgroundColor: MyColor.pageBgColor,
      ),
      body:  TabBarView(
          children: _list()),
    ));
  }

  List<Widget> getTabs() {
    List<Widget> list = [];
    if (_findController.findTabList.isNotEmpty) {
      int length =_findController.findTabList.length ;
      for (int i = 0; i < length; i++) {
        list.add(Tab(
          text: _findController.findTabList[i].title,
        ));
      }
    }
    return list;
  }

  List<Widget> _list() {
    List<Widget> list = [];
    if(_findController.findTabList.isNotEmpty){
      int length = _findController.findTabList.length;
      for (int i = 0; i < length; i++) {
        list.add(MyFindListWidget(
          _findController.findTabList[i].id,
          isSvip: _homeController.isSvip.value,
        ));
      }
    }
    return list;
  }

  @override
  bool get wantKeepAlive => true;
}
