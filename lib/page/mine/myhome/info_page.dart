import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/basic/common_config.dart';
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
    return _InfoPageState();
  }
}

class _InfoPageState extends State with AutomaticKeepAliveClientMixin {

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
  int? isCard;
  String? expectAge = '';
  String? expectHeight = '';
  String? expectConstellation = '';
  String? expectType = '';
  String? expectRegion = '';
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
    return Container(
        color: MyColor.pageBgColor,
        child: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  CustomText(
                    text: '认证',
                    textStyle: TextStyle(fontSize: 14, color: Colors.white),
                    margin: EdgeInsets.only(left: 16, right: 12),
                  ),
                  isCard == 1
                      ? card("assets/images/ic_ver_card.png", "实名",
                          Color(0xff6385FF))
                      : Container(),
                  isHead == 1
                      ? card("assets/images/ic_ver_avatar.png", "头像",
                          Color(0xffFF8B00))
                      : Container(),
                  isVideo == 1
                      ? card("assets/images/ic_video_ver.png", "真人",
                          Color(0xff7581A8))
                      : Container(),
                  card("assets/images/ic_phone_ver.png", "手机",
                      Color(0xffEE6F00)),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: '资料',
                    textStyle: TextStyle(fontSize: 14, color: Colors.white),
                    margin: EdgeInsets.only(left: 16, right: 16),
                  ),
                  Container(
                    width: ScreenUtil().screenWidth * 0.3,
                    child: Column(
                      children: [
                        CustomText(
                          text: 'ID: ${uid}\n'
                              '性别: ${sex == 2 ? "女" : "男"}\n'
                              '身高: ${height}cm\n'
                              '年龄: ${age}\n'
                              '学历: ${education}\n',
                          textStyle:
                              TextStyle(fontSize: 14, color: Color(0xfff5f5f5)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ScreenUtil().screenWidth * 0.4,
                    child: Column(
                      children: [
                        CustomText(
                          text: '城市: ${region}\n'
                              '生日: ${birthday}\n'
                              '月收入: ${monthlyIncome}\n',
                          textStyle:
                              TextStyle(fontSize: 14, color: Color(0xfff5f5f5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              if (hobbies.isNotEmpty)
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 16, top: 10),
                  child: Wrap(children: _hobbiesWidget()),
                )
            ],
          ),
        )));
  }

  List<Widget> _hobbiesWidget() {
    List<Widget> h = [];
    h.add(Text(
      '兴趣',
      style: TextStyle(fontSize: 14, color: Colors.white),
    ));
    h.add(SizedBox(
      width: 16,
    ));
    for (int i = 0; i < hobbies.length; i++) {
      h.add(CustomTextRadius(
        bgColor: Color(0xff7581A8),
        margin: EdgeInsets.only(right: 6, bottom: 10,top: 4),
        text: '${hobbies[i]}',
      ));
    }
    return h;
  }

  Widget card(String img, String text, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: new BoxDecoration(
        //设置四周圆角 角度
        border: Border.all(color: color),
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
          width: ScreenUtil().setWidth(60),
          height: ScreenUtil().setHeight(25),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              img,
              width: 15,
              height: 15,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              text,
              style: TextStyle(color: Color(0xffF5F5F5), fontSize: 14),
            )
          ])),
    );
  }

  void getInfo() {
    UserInfo userInfo;
    getUserInfo().then((value) => {
          if (value.isOk()) {userInfo = value.data!, setInfo(userInfo)}
        });
  }

  void setInfo(UserInfo userInfo) {
    expects.clear();
    details.clear();
    hobbies.clear();
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
    if (height != null && height != 0) {
      details.add(CustomTextRadius(
        text: '身高：${height}cm',
      ));
    }
    constellation = userInfo.constellation;
    if (constellation != null && constellation != '') {
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
    if (birthday != null && birthday != '') {
      details.add(CustomTextRadius(
        text: '生日：${birthday}',
      ));
    }
    monthlyIncome = userInfo.monthlyIncome;
    if (monthlyIncome != null && monthlyIncome != '') {
      details.add(CustomTextRadius(
        text: '月收入：${monthlyIncome}',
      ));
    }
    education = userInfo.education;
    if (education != null && education != '') {
      details.add(CustomTextRadius(
        text: '学历：${education}',
      ));
    }
    backgroundImage = userInfo.backgroundImage;
    isVideo = userInfo.isVideo;
    isHead = userInfo.isHead;
    isCard = userInfo.isCard;
    expectAge = userInfo.expectAge;
    if (expectAge != null && expectAge != '') {
      expects.add(CustomTextRadius(
        text: '年龄：${expectAge}',
      ));
    }
    expectHeight = userInfo.expectHeight;
    if (expectHeight != null && expectHeight != '') {
      expects.add(CustomTextRadius(
        text: '身高：${expectHeight}',
      ));
    }
    expectConstellation = userInfo.expectConstellation;
    if (expectConstellation != null && expectConstellation != '') {
      expects.add(CustomTextRadius(
        text: '星座：${expectConstellation}',
      ));
    }
    expectType = userInfo.expectType;
    if (expectType != null && expectType != '') {
      expects.add(CustomTextRadius(
        text: '目标：${expectType}',
      ));
    }
    expectRegion = userInfo.expectRegion;
    if (expectRegion != null && expectRegion != '') {
      expects.add(CustomTextRadius(
        text: '城市：${expectRegion}',
      ));
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
