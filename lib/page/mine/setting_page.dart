import 'package:flutter/material.dart';
import 'package:untitled/widget/item_arrow.dart';

class SettingPage extends StatefulWidget {
  const SettingPage();

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: new IconButton(
              icon: Icon(Icons.chevron_left,
                  size: 38, color: Colors.black),
              onPressed: () {
                Navigator.maybePop(context);
              }),
          title:
          Text("设置", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height:8.0,
              color: Color(0xffE6E6E6),
            ),
            ItemArrow(
              onPressed: () {},
              text: '清理缓存',
              value: '48M',
              padding: EdgeInsets.only(left: 16,right: 16),
            ),
            ItemArrow(
              onPressed: () {},
              text: '用户协议',
              padding: EdgeInsets.only(left: 16,right: 16),
            ),
            ItemArrow(
              onPressed: () {},
              text: '隐私条款',
              showDivider: false,
              padding: EdgeInsets.only(left: 16,right: 16),
            ),
            Container(
              height:8.0,
              color: Color(0xffE6E6E6),
            ),
            ItemArrow(
              onPressed: () {},
              text: '关于我们',
              padding: EdgeInsets.only(left: 16,right: 16),
            ),
            ItemArrow(
              onPressed: () {},
              text: '软件版本',
              value: 'V0.1',
              showArrow: false,
              padding: EdgeInsets.only(left: 16,right: 16),
            ),
            Container(
              width: 214,
              height: 40,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 45),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white
              ),
              child: GestureDetector(
                onTap: () {},
                child: Text('退出',
                    style: TextStyle(color: Color(0xffFD4343), fontSize: 17)),
              ),
            )
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
