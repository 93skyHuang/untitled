import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'community_tab_bar.dart';
import 'community_tab_bar_view.dart';

//发布动态
class PullDynamicPage extends StatefulWidget {
  const PullDynamicPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PullDynamicPageState();
  }
}

class _PullDynamicPageState extends State<PullDynamicPage> {
  final TextEditingController _textFieldController = TextEditingController();

  bool icCanPull = false;
  int _type = 0; //type=1 picture type=2 video

  @override
  Widget build(BuildContext context) {
    logger.i('CommunityPage');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.5,
            leading: new IconButton(
                icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
                onPressed: () {
                  Navigator.maybePop(context);
                }),
            title: Text("我的动态",
                style: TextStyle(fontSize: 17, color: Colors.black)),
            backgroundColor: Color(0xFFF5F5F5),
            centerTitle: true,
            actions: <Widget>[
              Container(
                width: 62,
                alignment: const Alignment(0, 0),
                // 边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: Color(0xffE2E2E2),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  //设置四周边框
                  border: Border(),
                ),
                margin: const EdgeInsets.fromLTRB(5, 12, 16.0, 12),
                child: GestureDetector(
                  onTap: () {},
                  child: Text("发布",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: icCanPull
                              ? Color(0xFF000000)
                              : Color(0xFF8C8C8C))),
                ),
              ),
            ]),
        backgroundColor: Color(0xFFF5F5F5),
        body: _child(),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _child() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextField(
              onChanged: (text) {
                //输入框内容变化回调
              },
              controller: _textFieldController,
              maxLines: 8,
              minLines: 8,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0),
                ),
                fillColor: Color(0xffF5F5F5),
                filled: true,
                hintStyle: TextStyle(color: Color(0xFF8C8C8C), fontSize: 15),
                hintText: "说出你的心情～",
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              ),
            ),
          ),
          _gridView(),
          _action(),
        ],
      ),
    );
  }

  Widget _gridView() {
    return GridView.count(
      shrinkWrap: true,
      //为true可以解决子控件必须设置高度的问题
      physics: NeverScrollableScrollPhysics(),
      //禁用滑动事件
      //GridView内边距
      padding: EdgeInsets.all(ScreenUtil().setWidth(4)),
      //垂直子Widget之间间距
      mainAxisSpacing: ScreenUtil().setWidth(4),
      //一行的Widget数量
      crossAxisCount: 4,
      //子Widget宽高比例
      childAspectRatio: 1,
      children: _listView(),
    );
  }

  List<Widget> _listView() {
    List<Widget> list=[];
    if (_type == 2) { //video

    } else if (_type == 1) { //picture

    }
    return list;
  }

  Widget _action() {
    return Row(
      children: [
        _choicePicture(),
        _choiceVideo(),
        _location(),
        _choiceTopic(),
      ],
    );
  }

  Widget _choicePicture() {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 16),
      child: GestureDetector(
        onTap: () {
          updateUserData(expectAge: '18', hobby: ['444'], expectHeight: 172);
        },
        child: Column(
          children: [
            Image.asset(
              'assets/images/ic_picture.png',
              width: 22,
              height: 19,
            ),
            Text(
              '图片',
              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceVideo() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 16),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Image.asset(
              'assets/images/ic_video.png',
              width: 20,
              height: 20,
            ),
            Text(
              '视频',
              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _location() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 16),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Image.asset(
              'assets/images/ic_location.png',
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
              width: 18,
              height: 20,
            ),
            Text(
              '定位',
              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceTopic() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 16),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Image.asset(
              'assets/images/topic.png',
              color: Color(0xff8C8C8C),
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
              width: 20,
              height: 20,
            ),
            Text(
              '话题',
              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
