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

class InfoPage extends StatefulWidget {
  int uid;

  InfoPage(this.uid);

  @override
  State<StatefulWidget> createState() {
    return _InfoPageState(uid);
  }
}

class _InfoPageState extends State with SingleTickerProviderStateMixin {
  _InfoPageState(this.uid);

  int uid;
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
  List<String> hobbies = [];

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
                text: 'ID： ${uid}\n${region??''}｜${sex == 1 ? '男' : '女'}｜${age}岁',
                textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                margin: EdgeInsets.only(left: 18, top: 20, bottom: 10),
              ),
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
                text: '${autograph??'暂无个人介绍'}',
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
          if (expects.isNotEmpty)
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 16),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: expects,
              ),
            ),
            Container(
              height: 0.5,
              margin: EdgeInsets.only(top: 18),
              color: Color(0xffE6E6E6),
            ),
            CustomText(
              text: '兴趣爱好',
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              margin: EdgeInsets.only(left: 16, top: 5),
            ),
          if (hobbies.isNotEmpty)
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 16, top: 10),
              child: Wrap(
                  children: List.generate(hobbies.length, (index) {
                return CustomTextRadius(
                  margin: EdgeInsets.only(right: 16, bottom: 16),
                  text: '${hobbies[index]}',
                );
              })),
            )
        ],
      ),
    ));
  }

  void getInfo() {
    UserInfo userInfo;
    getOtherUserInfo(uid).then((value) => {
          if (value.isOk()) {userInfo = value.data!, setInfo(userInfo)}
        });
  }

  void setInfo(UserInfo userInfo) {
    expects.clear();
    details.clear();
    hobbies.clear();
    verify.clear();
    icons.clear();
    if (userInfo.hobby!.isNotEmpty) {
      if (userInfo.hobby!.length == 1 && userInfo.hobby![0] == '') {
      } else {
        hobbies = userInfo.hobby!;
      }
    }
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
    if (height != null&&height != 0) {
      details.add(CustomTextRadius(
        text: '身高：${height}cm',
      ));
    }
    constellation = userInfo.constellation;
    if (constellation != null&&constellation != '') {
      details.add(CustomTextRadius(
        text: '星座：${constellation}',
      ));
    }
    region = userInfo.region;
    if (region != null&&region != '') {
      details.add(CustomTextRadius(
        text: '城市：${region}',
      ));
    }
    autograph = userInfo.autograph;
    birthday = userInfo.birthday;
    if (birthday != null&&birthday != '') {
      details.add(CustomTextRadius(
        text: '生日：${birthday}',
      ));
    }
    monthlyIncome = userInfo.monthlyIncome;
    if (monthlyIncome != null&&monthlyIncome != '') {
      details.add(CustomTextRadius(
        text: '月收入：${monthlyIncome}',
      ));
    }
    education = userInfo.education;
    if (education != null&&education != '') {
      details.add(CustomTextRadius(
        text: '学历：${education}',
      ));
    }
    backgroundImage = userInfo.backgroundImage;
    isVideo = userInfo.isVideo;
    isHead = userInfo.isHead;
    expectAge = userInfo.expectAge;
    if (expectAge != null&&expectAge != '') {
      expects.add(CustomTextRadius(
        text: '年龄：${expectAge}',
      ));
    }
    expectHeight = userInfo.expectHeight;
    if (expectHeight != null&&expectHeight != '' ) {
      expects.add(CustomTextRadius(
        text: '身高：${expectHeight}',
      ));
    }
    expectConstellation = userInfo.expectConstellation;
    if (expectConstellation != null&&expectConstellation != '') {
      expects.add(CustomTextRadius(
        text: '星座：${expectConstellation}',
      ));
    }
    expectType = userInfo.expectType;
    if (expectType != null&&expectType != '') {
      expects.add(CustomTextRadius(
        text: '目标：${expectType}',
      ));
    }
    expectRegion = userInfo.expectRegion;
    if (expectRegion != null&&expectRegion != '') {
      expects.add(CustomTextRadius(
        text: '城市：${expectRegion}',
      ));
    }
      //0-否，1-是]
      verify.add('头像认证');
      icons.add(isHead == 1
          ? "assets/images/icon_verified_avatar.png"
          : "assets/images/icon_un_verified_avatar.png");
      //0-否，1-是]
      verify.add('真人认证');
      icons.add(isVideo == 1
          ?  "assets/images/ic_verified_person1.png":
      "assets/images/ic_unverified_person.png");
    //0-否，1-是]
    verify.add('手机认证');
    icons.add("assets/images/icon_verified_phone.png");
    setState(() {});
  }
}
