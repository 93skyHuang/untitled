import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/network/bean/chat_user_info.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/bean/user_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/mine/info/edit_user_info.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/custom_text_15radius.dart';
import 'package:untitled/widget/item_menu.dart';

import 'info_controller.dart';
import 'my_home_controller.dart';

class InfoPage extends StatefulWidget {
  final MyHomeController _myHomeController;

  InfoPage(this._myHomeController);

  @override
  State<StatefulWidget> createState() {
    return _InfoPageState(_myHomeController);
  }
}

class _InfoPageState extends State with SingleTickerProviderStateMixin {
  _InfoPageState(this._myHomeController);

  MyHomeController _myHomeController;

  int uid = 0;
  int? height = 0;

  String? constellation = '';
  int? age = 0;
  int? sex = 1;
  String? region = '';
  String? autograph = '';
  String? birthday = '';
  String? backgroundImage = '';
  String? monthlyIncome = '';
  String? education = '';
  int? isVideo;
  int? isHead;
  String? expectAge = '';
  String? expectHeight = '';
  String? expectConstellation = '';
  String? expectType = '';
  String? expectRegion = '';
  List<String> verify = [];
  List<String> icons = [];
  List<Widget> details = [];
  List<Widget> expects = [];

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: '陌声ID： ${uid}\n${region}｜${sex == 1 ? '男' : '女'}｜${age}岁',
                textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                margin: EdgeInsets.only(left: 18, top: 20, bottom: 10),
              ),
              Container(
                  margin: EdgeInsets.only(right: 18, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => EditUser())!.then((value) {
                        getInfo();
                        _myHomeController.getInfo();
                      });
                    },
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage("assets/images/icon_edit.png"),
                        ),
                        CustomText(
                          text: '编辑资料',
                          margin: EdgeInsets.only(left: 3),
                          textStyle:
                              TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                        ),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.only(left: 6, right: 6, bottom: 2),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: new Border.all(width: 1, color: Color(0xff8C8C8C)),
                  ))
            ],
          ),
          Divider(
            color: Color(0xffE6E6E6),
          ),
          CustomText(
            text: '我的介绍',
            textStyle: TextStyle(fontSize: 14, color: Colors.black),
            margin: EdgeInsets.only(left: 16, top: 5),
          ),
          Container(
              margin: EdgeInsets.all(16),
              child: CustomText(
                text: '${autograph}',
                textStyle: TextStyle(fontSize: 12, color: Colors.black),
              ),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 9, top: 9),
              decoration: new BoxDecoration(
                color: Color(0xffE6E6E6),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              )),
          if (verify.length > 0)
            Divider(
              color: Color(0xffE6E6E6),
            ),
          if (verify.length > 0)
            CustomText(
              text: '个人认证',
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              margin: EdgeInsets.only(left: 16, top: 5),
            ),
          if (verify.length > 0)
            Container(
              height: 75,
              padding: EdgeInsets.only(left: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return new ItemMenu(
                    margin: EdgeInsets.only(right: 30),
                    text: verify[index],
                    img: icons[index],
                    onPressed: () {},
                  );
                },
                itemCount: verify.length,
              ),
            ),
          Divider(
            color: Color(0xffE6E6E6),
          ),
          CustomText(
            text: '基本资料',
            textStyle: TextStyle(fontSize: 14, color: Colors.black),
            margin: EdgeInsets.only(left: 16, top: 5),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: details,
            ),
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(top: 18),
            color: Color(0xffE6E6E6),
          ),
          CustomText(
            text: '择偶要求',
            textStyle: TextStyle(fontSize: 14, color: Colors.black),
            margin: EdgeInsets.only(left: 16, top: 5),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: expects,
            ),
          )
        ],
      ),
    ));
  }

  void getInfo() {
    UserInfo userInfo;
    getUserInfo().then((value) => {userInfo = value.data!, setInfo(userInfo)});
  }

  void setInfo(UserInfo userInfo) {
    expects.clear();
    details.clear();
    uid = userInfo.uid;
    sex = userInfo.sex;
    details.add(CustomTextRadius(
      text: '性别：${sex == 1 ? '男' : '女'}',
    ));
    age = userInfo.age;
    details.add(CustomTextRadius(
      text: '年龄：${age}',
    ));
    height = userInfo.height;
    if (height != 0) {
      details.add(CustomTextRadius(
        text: '身高：${height}cm',
      ));
    }
    constellation = userInfo.constellation;
    if (constellation != '') {
      details.add(CustomTextRadius(
        text: '星座：${constellation}',
      ));
    }
    region = userInfo.region;
    if (region != null) {
      details.add(CustomTextRadius(
        text: '城市：${region}',
      ));
    }
    autograph = userInfo.autograph;
    birthday = userInfo.birthday;
    if (birthday != '') {
      details.add(CustomTextRadius(
        text: '生日：${birthday}',
      ));
    }
    monthlyIncome = userInfo.monthlyIncome;
    if (monthlyIncome != '') {
      details.add(CustomTextRadius(
        text: '月收入：${monthlyIncome}',
      ));
    }
    education = userInfo.education;
    if (education != '') {
      details.add(CustomTextRadius(
        text: '学历：${education}',
      ));
    }
    backgroundImage = userInfo.backgroundImage;
    isVideo = userInfo.isVideo;
    isHead = userInfo.isHead;
    expectAge = userInfo.expectAge;
    if (expectAge != '') {
      expects.add(CustomTextRadius(
        text: '年龄：${expectAge}',
      ));
    }
    expectHeight = userInfo.expectHeight;
    if (expectHeight != '') {
      expects.add(CustomTextRadius(
        text: '身高：${expectHeight}',
      ));
    }
    expectConstellation = userInfo.expectConstellation;
    if (expectConstellation != '') {
      expects.add(CustomTextRadius(
        text: '星座：${expectConstellation}',
      ));
    }
    expectType = userInfo.expectType;
    if (expectType != '') {
      expects.add(CustomTextRadius(
        text: '目标：${expectType}',
      ));
    }
    expectRegion = userInfo.expectRegion;
    if (expectRegion != '') {
      expects.add(CustomTextRadius(
        text: '城市：${expectRegion}',
      ));
    }
    if (isHead == 1) {
      //0-否，1-是]
      verify.add('头像认证');
      icons.add("assets/images/icon_verified_avatar.png");
    }
    if (isVideo == 1) {
      //0-否，1-是]
      verify.add('视频认证');
      icons.add("assets/images/icon_verified_person.png");
    }

    setState(() {});
  }
}
