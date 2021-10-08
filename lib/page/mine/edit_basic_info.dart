import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_arrow.dart';

import 'nickname_page.dart';

class EditBasicInfoPage extends StatefulWidget {
  const EditBasicInfoPage();

  @override
  State<EditBasicInfoPage> createState() => _EditBasicInfoPageState();
}

class _EditBasicInfoPageState extends State<EditBasicInfoPage> {
  final TextEditingController contactTextFieldController =
      TextEditingController();

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
              Text("基本资料", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NicknamePage()),
                );},
                child: Text("下一步",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Color(0xFF8C8C8C))),
              ),
            ),
          ]),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 40, right: 40),
          child: Column(
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
                  Get.to(() =>NicknamePage());
                },
                text: '昵称',
                value: '默认昵称',
              ),
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                child: Text("介绍",
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: TextField(
                  controller: contactTextFieldController,
                  maxLines: 12,
                  minLines: 3,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffa9b3bb), width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffa9b3bb), width: 0.5),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle:
                        TextStyle(color: Color(0xFFA9B3BB), fontSize: 15),
                    hintText: "这里是个人介绍",
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    iconSize: 100,
                    icon: Image.asset('assets/images/male_unselect.png'),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 100,
                    icon: Image.asset('assets/images/female_select.png'),
                    onPressed: () {},
                  )
                ],
              ),
              ItemArrow(
                onPressed: () {},
                text: '城市',
              ),
              ItemArrow(
                onPressed: () {},
                text: '年龄',
              ),
              ItemArrow(
                onPressed: () {},
                text: '身高',
              ),
              ItemArrow(
                onPressed: () {},
                text: '月收入',
              ),
              ItemArrow(
                onPressed: () {},
                text: '学历',
              ),
              CustomText(
                text: '完善的基本资料可提升交友成功率哦～',
                textStyle: TextStyle(fontSize: 10, color: Color(0xffFD4343)),
                textAlign: Alignment.center,
                margin: EdgeInsets.only(top: 30, bottom: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
