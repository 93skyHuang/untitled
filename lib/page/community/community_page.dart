import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/logger.dart';
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
  @override
  Widget build(BuildContext context) {
    logger.i('CommunityPage');
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: MyColor.pageBgColor,
        appBar: AppBar(
          backgroundColor: MyColor.pageBgColor,
          elevation: 0,
          title: Row(
            children: [
              Expanded(
                child: CommunityTabBar(),
              ),
              Container(
                width: ScreenUtil().setWidth(70),
                height: ScreenUtil().setWidth(26),
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
              )
            ],
          ),
        ),
        body: CommunityTabBarView(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget addBtn() {
    return InkWell(
        onTap: pullDymaic,
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

  void pullDymaic() {
    logger.i('发布动态');
  }
}
