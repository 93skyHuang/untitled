import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/page/mine/setting_page.dart';
import 'package:untitled/page/mine/verify_center_page.dart';
import 'package:untitled/page/mine/vip/vip_page.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_menu.dart';

import 'edit_user_info.dart';

class MinePage extends StatefulWidget {
  const MinePage();

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final List<Widget> _menuItem = [

  ItemMenu(
  text: '我的动态',
  img: "assets/images/mine_move.png",
  textStyle: TextStyle(fontSize: 12, color: Colors.black),
  onPressed: () {},
  ),
    ItemMenu(
      text: '认证中心',
      img: "assets/images/mine_verify.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {
        Get.to(()=>VerifyCenterPage());
      },
    ),
    ItemMenu(
      text: '我的访客',
      img: "assets/images/mine_visitor.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {},
    ),
    ItemMenu(
      text: '我喜欢的',
      img: "assets/images/mine_like.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {},
    ),
    ItemMenu(
      text: '我的粉丝',
      img: "assets/images/mine_fans.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {},
    ),
    ItemMenu(
      text: '我的关注',
      img: "assets/images/mine_focus.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {},
    ),
    ItemMenu(
      text: '我的足迹',
      img: "assets/images/mine_history.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {},
    ),
    ItemMenu(
      text: '喜欢我的',
      img: "assets/images/mine_follows.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {},
    ),
    ItemMenu(
      text: '安全中心',
      img: "assets/images/mine_safe.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {},
    ),
    ItemMenu(
      text: '设置',
      img: "assets/images/mine_setting.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {
        Get.to(() =>SettingPage());
      },
    ),
    ItemMenu(
      text: '我的主页',
      img: "assets/images/mine_page.png",
      textStyle: TextStyle(fontSize: 12, color: Colors.black),
      onPressed: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: SafeArea(
          top: true,
          child: Offstage(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg",
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: '这里是昵称',
                              margin: EdgeInsets.only(left: 10, right: 10),
                            ),
                            Image(
                              image: AssetImage("assets/images/icon_vip.png"),
                            ),
                          ],
                        ),
                        CustomText(
                          text: '资料完整度32%',
                          textStyle:
                              TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                          margin: EdgeInsets.only(left: 10),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditUser()),
                          );
                        },
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/images/icon_edit.png"),
                            ),
                            CustomText(
                              text: '编辑资料',
                              margin: EdgeInsets.only(left: 3),
                              textStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff8C8C8C)),
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.only(left: 6, right: 6, bottom: 2),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        //设置四周边框
                        border:
                            new Border.all(width: 1, color: Color(0xff8C8C8C)),
                      ))
                ],
              ),
            ),
            Row(
              children: [
                CustomText(
                  text: '动态 ',
                  textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                  margin: EdgeInsets.only(left: 16),
                ),
                CustomText(
                  text: '2',
                  textStyle: TextStyle(fontSize: 15, color: Colors.black),
                ),
                CustomText(
                  text: '访客 ',
                  textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                  margin: EdgeInsets.only(left: 30),
                ),
                CustomText(
                  text: '31',
                  textStyle: TextStyle(fontSize: 15, color: Colors.black),
                ),
                CustomText(
                  text: '喜欢 ',
                  textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                  margin: EdgeInsets.only(left: 30),
                ),
                CustomText(
                  text: '44',
                  textStyle: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
            Container(
              color: Color(0xff5DB1DE),
              margin: EdgeInsets.only(top: 16, bottom: 16),
              padding: EdgeInsets.only(left: 16, right: 18),
              height: 51,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: '完善基本资料',
                        textStyle: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      CustomText(
                        text: '详细的个人资料才能得到更多关注哟',
                        textStyle: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          left: 12, right: 12, bottom: 5, top: 3),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Text(
                        "去完善",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff5DB1DE),
                        ),
                      ))
                ],
              ),
            ),
            CustomText(
              text: '认证信息',
              textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
              margin: EdgeInsets.only(left: 16),
            ),
            Container(
                height: 84,
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ItemMenu(
                      text: '实名认证',
                      img: "assets/images/icon_verified_name.png",
                      onPressed: () {},
                    ),
                    ItemMenu(
                      text: '头像认证',
                      img: "assets/images/icon_verified_avatar.png",
                      onPressed: () {},
                    ),
                    ItemMenu(
                      text: '真人认证',
                      img: "assets/images/icon_verified_person.png",
                      onPressed: () {},
                    ),
                    ItemMenu(
                      text: '手机认证',
                      img: "assets/images/icon_verified_phone.png",
                      onPressed: () {},
                    ),
                  ],
                )),
            Container(
              height: 70,
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 16),
              decoration: new BoxDecoration(
                color: Color(0xff3E321E),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: '开通SVIP会员',
                        textStyle:
                            TextStyle(fontSize: 15, color: Color(0xffF3CD8E)),
                      ),
                      CustomText(
                        text: '尊享10项专属特权，提高交友成功率',
                        textStyle:
                            TextStyle(fontSize: 10, color: Color(0xffE6E6E6)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=>VipPage());
                    },
                    child:
                    Container(
                        padding: EdgeInsets.only(
                            left: 12, right: 12, bottom: 5, top: 3),
                        decoration: new BoxDecoration(
                          color: Color(0xffF3CD8E),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        child: Text(
                          "立即开通",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ))
                    ,
                  )
                ],
              ),
            ),
            CustomText(
              text: '更多服务',
              textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
              margin: EdgeInsets.only(left: 16),
            ),
            Container(
              height: 240,
              margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: GridView.count(
                crossAxisCount: 4,
                // 设置每子元素的大小（宽高比）
                childAspectRatio: 1.2,
                physics: const NeverScrollableScrollPhysics(),
                children: _menuItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
