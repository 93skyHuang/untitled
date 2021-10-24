import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_trend.dart';

import 'info_page.dart';
import 'my_home_controller.dart';

//个人首页页面
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State with SingleTickerProviderStateMixin {
  final MyHomeController _myHomeController = Get.put(MyHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:   Obx(() =>buildNestedScrollView()),
    );
  }
  ///构建滑动布局
  NestedScrollView buildNestedScrollView() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool b) {
        return [
          SliverAppBar(
            ///true SliverAppBar 不会滑动
            pinned: true,
            leading: Text(''),
            backgroundColor: Colors.white,
            elevation: 0,

            ///是否随着滑动隐藏标题
            floating: true,

            ///SliverAppBar展开的高度
            expandedHeight: 375,
            flexibleSpace: buildFlexibleSpaceBar(),
            bottom: buildTabBar(),
          ),
        ];
      },

      ///主体部分
      body: buildTabBarView(),
    );
  }

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        Container(
          child:
          ListView.builder(
            itemBuilder: (context, index) {
              return new ItemTrend(
              );
            },
            itemCount: _myHomeController.userBasic.value.trendsList!.length,
          ),
        ),
        Text(
          "这是第二个页面",
          style: TextStyle(color: Colors.blue),
        ),
        InfoPage(_myHomeController),
      ],
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      labelColor: Color(0xffFD4343),
      labelStyle: TextStyle(fontSize: 14),
      unselectedLabelColor: MyColor.grey8C8C8C,
      unselectedLabelStyle: TextStyle(fontSize: 14),
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: MyColor.redFd4343,
      controller: tabController,
      padding: EdgeInsets.only(right: 120),
      tabs: <Widget>[
        new Tab(
          text: "动态",
        ),
        new Tab(
          text: "视频",
        ),
        new Tab(
          text: "个人资料",
        ),
      ],
    );
  }

  FlexibleSpaceBar buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
        background: Container(
      height: 415,
      child: Column(
        children: [
          Container(
            height: 365,
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("${_myHomeController.userBasic.value.headImgUrl??''}",
                ),
                fit: BoxFit.fill,
              ),
            ) ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon:
                        Icon(Icons.chevron_left, size: 38, color: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                CustomText(
                  text: '${_myHomeController.userBasic.value.cname}',
                  textAlign: Alignment.topLeft,
                  textStyle: TextStyle(fontSize: 17, color: Colors.white),
                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
