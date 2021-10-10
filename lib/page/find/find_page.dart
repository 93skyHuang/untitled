import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/http_manager.dart';

import 'find_controller.dart';

//发现页面
class FindPage extends StatefulWidget {
  final FindController _findController = Get.put(FindController());
   FindPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FindPageState();
  }
}

class _FindPageState extends State<FindPage> {

  @override
  Widget build(BuildContext context) {
    getFindTab();
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
          title: Row(
            children:  [
              Expanded(
                child: TabBar(
                    labelColor:MyColor.blackColor,
                    labelStyle: TextStyle(fontSize: ScreenUtil().setSp(20)),
                    unselectedLabelColor:MyColor.grey8C8C8C,
                    unselectedLabelStyle: TextStyle(fontSize: ScreenUtil().setSp(15)),
                    indicatorWeight:4,
                    indicatorColor: MyColor.redFd4343,
                    isScrollable: true,//多个按钮可以滑动
                    tabs: <Widget>[
                      Tab(text: "热门1"),
                      Tab(text: "推荐2"),
                      Tab(text: "热门3"),
                      Tab(text: "推荐4"),
                      Tab(text: "热门5"),
                      Tab(text: "推荐6"),
                      Tab(text: "热门7"),
                      Tab(text: "推荐8"),
                    ]),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          children: <Widget>[
            ListView(
              children: [
                ListTile(
                  title: Text("第一个tab"),
                ),
                ListTile(
                  title: Text("第一个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第二个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第三个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第四个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第五个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第6个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ), ListView(
              children: [
                ListTile(
                  title: Text("第7个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第8个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
