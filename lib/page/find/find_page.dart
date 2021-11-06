import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/page/global_controller.dart';
import 'package:untitled/page/mine/verify_center_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widgets/dialog.dart';

import 'find_controller.dart';
import 'my_find_list_widget.dart';

//发现页面
class FindPage extends StatefulWidget {
  FindPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FindPageState();
  }
}

class _FindPageState extends State<FindPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final FindController _findController = Get.put(FindController());
  final GlobalController _globalController = Get.find();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      logger.i('addPostFrameCallback');
      Future.delayed(const Duration(seconds: 3)).then((value) => {
            if (GetStorageUtils.getIsShowVerifiedTipsInHomePage())
              {
                GetStorageUtils.saveIsShowVerifiedTipsInHomePage(false),
                showBottomOpen(context),
              }
          });
    });
    _tabController =
        TabController(length: _findController.findTabList.length, vsync: this)
          ..addListener(() {
            logger.i(_tabController.index);
            switch (_tabController.index) {
              case 0:
                break;
              case 1:
              case 2:
              case 3:
                if (!GetStorageUtils.getSvip()) {
                  _tabController.index = 0;
                  Future.delayed(Duration(milliseconds: 100))
                      .then((value) => showOpenSvipDialog(context));
                }
                break;
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    // 105324
    logger.i('FindPage');
    return Obx(() => Scaffold(
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
                      unselectedLabelStyle:
                          TextStyle(fontSize: ScreenUtil().setSp(15)),
                      indicatorWeight: 4,
                      indicatorColor: MyColor.redFd4343,
                      isScrollable: true,
                      physics: _globalController.isSvip.value
                          ? ScrollPhysics()
                          : NeverScrollableScrollPhysics(),
                      //多个按钮可以滑动
                      tabs: getTabs()),
                ),
              ],
            ),
            backgroundColor: MyColor.pageBgColor,
          ),
          body: TabBarView(
              controller: _tabController,
              children: _list(),
              physics: _globalController.isSvip.value
                  ? ScrollPhysics()
                  : NeverScrollableScrollPhysics()),
        ));
  }

  List<Widget> getTabs() {
    List<Widget> list = [];
    if (_findController.findTabList.isNotEmpty) {
      int length = _findController.findTabList.length;
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
    if (_findController.findTabList.isNotEmpty) {
      int length = _findController.findTabList.length;
      for (int i = 0; i < length; i++) {
        list.add(MyFindListWidget(
          _findController.findTabList[i].id,
          isSvip: _globalController.isSvip.value,
        ));
      }
    }
    return list;
  }

  @override
  bool get wantKeepAlive => true;

  void showBottomOpen(BuildContext context) {
    showModalBottomSheet(
        enableDrag: false,
        elevation: 0,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          bottom: 20.0, left: 40, right: 40, top: 191),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/verified_tips_bg.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: Column(children: <Widget>[
                        CustomText(
                            text: "欢迎加入",
                            textStyle: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        CustomText(
                            text: "完善认证信息拿奖励，超多特权等你来。",
                            padding: EdgeInsets.only(top: 4, bottom: 20),
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        CustomText(
                            text: "1.您可以直接跟您喜欢的人聊天，对方都可以回复您",
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        CustomText(
                            text: "2.列表越上面的用户活跃度更好哦",
                            padding: EdgeInsets.only(top: 11, bottom: 11),
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        CustomText(
                            text: "3.每天多发一些动态，让更多的人关注您",
                            padding: EdgeInsets.only(top: 4, bottom: 11),
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        CustomText(
                            text: "4.完成认证您将解锁所有的权限",
                            padding: EdgeInsets.only(top: 4, bottom: 40),
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _widgetIconAndText(
                                "assets/images/verified_tips_ic1.png", "身份标识"),
                            _widgetIconAndText(
                                "assets/images/verified_tips_ic2.png", "优先推荐"),
                            _widgetIconAndText(
                                "assets/images/verified_tips_ic3.png", "动态曝光"),
                            _widgetIconAndText(
                                "assets/images/verified_tips_ic4.png", "无限畅聊"),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Get.to(() => VerifyCenterPage());
                          },
                          child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              width: 214,
                              margin: EdgeInsets.only(top: 30),
                              decoration: new BoxDecoration(
                                color: Color(0xffF3CD8E),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: Text(
                                "立即认证",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: CustomText(
                              textAlign: Alignment.center,
                              text: "知道了",
                              padding: EdgeInsets.only(top: 20),
                              textStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff8C8C8C))),
                        ),
                      ]))
                ],
              ));
        });
  }

  Widget _widgetIconAndText(String img, String text) {
    return Column(children: [
      Image.asset(
        img,
      ),
      SizedBox(
        height: 12,
      ),
      CustomText(
          text: text,
          padding: EdgeInsets.only(top: 4, bottom: 20),
          textStyle: TextStyle(fontSize: 12, color: Color(0xffffffff))),
    ]);
  }
}
