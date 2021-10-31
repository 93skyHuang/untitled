import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/page/community/pull_dynamic_page.dart';
import 'package:untitled/page/home_controller.dart';
import 'community_tab_bar.dart';
import 'community_tab_bar_view.dart';

//社区页面
class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommunityPageState();
  }
}

class _CommunityPageState extends State<CommunityPage>
    with AutomaticKeepAliveClientMixin {
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    logger.i('CommunityPage');
    super.build(context);
    return Obx(() => DefaultTabController(
          length: _homeController.isSvip.value ? 3 : 1,
          child: Scaffold(
            backgroundColor: MyColor.pageBgColor,
            appBar: AppBar(
              backgroundColor: MyColor.pageBgColor,
              elevation: 0,
              title: Row(
                children: [
                  Expanded(
                    child: CommunityTabBar(
                      isSvip: _homeController.isSvip.value,
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(70),
                    height: ScreenUtil().setWidth(30),
                    // 边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      //设置四周边框
                      border: Border(),
                    ),
                    // 设置 child 居中
                    alignment: const Alignment(0, 0),
                    child: addBtn(),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(6),
                  )),
                ],
              ),
            ),
            body: CommunityTabBarView(isSvip: _homeController.isSvip.value,),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  Widget addBtn() {
    return GestureDetector(
        onTap: _pullDynamic,
        child: Row(children: [
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(10),
                right: ScreenUtil().setWidth(5)),
            child: Image(
                width: ScreenUtil().setWidth(12),
                height: ScreenUtil().setWidth(12),
                image: const AssetImage("assets/images/add.png"),
                fit: BoxFit.fill),
          ),
          Text(
            '发布',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(15), color: Colors.black),
          ),
        ]));
  }

  void _pullDynamic() {
    Get.to(PullDynamicPage());
  }
}
