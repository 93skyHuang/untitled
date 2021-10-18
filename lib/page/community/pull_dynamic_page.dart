import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';
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
        body: Column(
          children: [
            SizedBox(height: 30,),
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
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
