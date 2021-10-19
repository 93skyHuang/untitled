import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/custom_text_15radius.dart';
import 'package:untitled/widget/item_arrow.dart';

import '../edit_basic_info.dart';
import '../hobby_page.dart';


class EditUser extends StatefulWidget {
  const EditUser();

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.5,
          leading: new IconButton(
              icon: Icon(Icons.chevron_left,
                  size: 38, color: Colors.black),
              onPressed: () {
                Navigator.maybePop(context);
              }),
          title:
              Text("编辑资料", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {},
                child: Text("保存",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Color(0xFFFD4343))),
              ),
            ),
          ]),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 30, bottom: 20),
                child: ClipOval(
                  child: Image(
                    image: AssetImage("assets/images/user_icon.png"),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text("个人头像",
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
              ItemArrow(
                onPressed: () {
                  Get.to(() =>EditBasicInfoPage());
                },
                text: '基本资料',
                showDivider: false,
                padding: EdgeInsets.only(left: 16,right: 16),
              ),
              CustomText(
                text: '昵称：小飞象  城市：成都市  性别：女',
                textStyle: TextStyle(fontSize: 14, color: Color(0xff8C8C8C)),
                margin: EdgeInsets.only(left:16, bottom: 16),
              ),
              Container(
                height:8.0,
                color: Color(0xffE6E6E6),
              ),
              CustomText(
                text: '择偶要求',
                margin: EdgeInsets.only(top: 16,left: 16),
              ),
              ItemArrow(
                onPressed: () {},
                text: '城市',
                padding: EdgeInsets.only(left: 16,right: 16),
              ),
              ItemArrow(
                onPressed: () {},
                text: '身高',
                padding: EdgeInsets.only(left: 16,right: 16),
              ),
              ItemArrow(
                onPressed: () {},
                text: '年龄',
                padding: EdgeInsets.only(left: 16,right: 16),
              ),
              ItemArrow(
                onPressed: () {},
                text: '生肖',
                padding: EdgeInsets.only(left: 16,right: 16),
              ),
              ItemArrow(
                onPressed: () {},
                text: '星座',
                padding: EdgeInsets.only(left: 16,right: 16),
              ),
              Container(
                height:8.0,
                color: Color(0xffE6E6E6),
                padding: EdgeInsets.only(left: 16,right: 16),
              ),
              ItemArrow(
                onPressed: () {
                  Get.to(()=>HobbyPage());
                },
                text: '兴趣爱好',
                showDivider: false,
                padding: EdgeInsets.only(left: 16,right: 16),
              ),
              CustomTextRadius(
                text: '游泳',)
            ],
          ),
        ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
