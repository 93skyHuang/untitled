import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/page/community/pull_dynamic_page.dart';
import 'package:untitled/page/community/recommend_page.dart';
import 'package:untitled/page/community/video_page.dart';
import 'package:untitled/page/global_controller.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/dialog.dart';
import 'focus_on_page.dart';

//社区页面
class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommunityPageState();
  }
}

class _CommunityPageState extends State<CommunityPage>
    with AutomaticKeepAliveClientMixin , SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length:3, vsync: this)
      ..addListener(() {
        switch (_tabController.index) {
          case 0:
            break;
          case 1:
          case 2:
            if (!GetStorageUtils.getSvip()) {
              _tabController.index = 0;
              showOpenSvipDialog(context);
            }
            break;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    logger.i('CommunityPage');
    super.build(context);
    return   Scaffold(
            backgroundColor: MyColor.pageBgColor,
            appBar: AppBar(
              backgroundColor: MyColor.pageBgColor,
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
                        ]),
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
            body:TabBarView(
                controller: _tabController,
                children: _list()),
        );
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

  List<Widget> _list() {
    return  [RecommendWidget(), VideoListPage(), FocusOnPage()];
  }

  void _pullDynamic() {
    Get.to(PullDynamicPage());
  }
}
