import 'dart:io';

import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/network/bean/pay_list.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/page/mine/vip/failed_order_bean.dart';
import 'package:untitled/page/mine/vip/vip_controller.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/loading.dart';
import 'package:untitled/widgets/card_image.dart';

import '../../../route_config.dart';

class VipPage extends StatefulWidget {
  VipPage();

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  final VipController _vipController = Get.put(VipController());
  TapGestureRecognizer _registProtocolRecognizer = TapGestureRecognizer();
  TapGestureRecognizer _privacyProtocolRecognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          leading: new IconButton(
              icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
              onPressed: () {
                Navigator.maybePop(context);
              }),
          title:
              Text("超级会员", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF3CD8E),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/vip_bg.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        Obx(() => cardNetworkImage(
                              _vipController.imgurl.value,
                              60,
                              60,
                              radius: 8,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => CustomText(
                                  text: _vipController.name.value,
                                  textAlign: Alignment.center,
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                )),
                            Obx(() => Container(
                              decoration: BoxDecoration(
                                //背景
                                color: _vipController.svip.value==1
                                    ? Colors.redAccent
                                    : Colors.grey,
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6)),
                                //设置四周边框
                                border: Border(),
                              ),
                              width: ScreenUtil().setWidth(28),
                              height: ScreenUtil().setHeight(12),
                              child:
                              Align(alignment: Alignment.center,child:Text(
                                'SVIP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(10), color: Colors.white) ,),
                              ),
                            )),
                          ],
                        ),
                        Text("尊享10项专属特权，提高交友成功率",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 20),
                    child: Text("超级会员充值",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff8C8C8C))),
                  ),
                  Obx(() => Container(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _list(_vipController.monthlyCardList),
                        ),
                      )),
                  Container(
                    height: 8.0,
                    margin: EdgeInsets.only(top: 20),
                  ),
                  CustomText(
                    text: '超级会员特权',
                    textStyle:
                        TextStyle(fontSize: 15, color: Color(0xff8C8C8C)),
                    margin: EdgeInsets.only(left: 16, bottom: 13),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_icon.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("会员身份标识",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("专属SVIP展示尊贵身份",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_chat.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("无限畅聊",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("解锁所有未读消息，畅所欲言，更多缘分更多机会",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_recommond.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("推荐不受限制",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("推荐给异性展示不再受限",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_foot.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("揭秘来访者",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("谁又来偷偷看我了？",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_like.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("谁喜欢我",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("看看喜欢我的TA",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_eye.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("查看全部专区",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("解锁所有专区，快人一步发现缘分",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_arrow.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("超级曝光",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("让更多人优先滑到你",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_face.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("有趣的灵魂",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("不限相册、视频、心情发布",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_card.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("动态打卡",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("不限回复动态评论",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  ListTile(
                    dense: true,
                    leading: Image(
                      image: AssetImage("assets/images/vip_heart.png"),
                    ),
                    contentPadding: EdgeInsets.only(left: 16),
                    title: Text("缘分搭讪",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                    subtitle: Text("解锁距离我最近的TA",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
                  ),
                  Container(
                    height: 1.0,
                    color: Color(0xff212121),
                    margin: EdgeInsets.only(top: 0),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              margin: EdgeInsets.only(
                                  left: 16, bottom: 10, top: 30),
                              decoration: new BoxDecoration(
                                color: Color(0xff212121),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0)),
                              ),
                              child: Obx(() => Text(
                                    _vipController.money.value,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xffF3CD8E),
                                    ),
                                  )))),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Loading.show(getApplication()!,isAutoDismiss:false);
                          _vipController.pay();
                        },
                        child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(right: 16, bottom: 10, top: 30),
                            decoration: new BoxDecoration(
                              color: Color(0xffF3CD8E),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0)),
                            ),
                            child: Text(
                              "立即开通",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            )),
                      )),
                    ],
                  ),
                  Container(
                    height: Platform.isIOS ? 20 : 0,
                  )
                ],
              ),
            ),
          ],
        ));
  }

  List<Widget> _list(List<MonthlyCard> list) {
    List<Widget> w = [];
    for (int i = 0; i < list.length; i++) {
      w.add(vipCard(list[i], i));
    }
    return w;
  }

  Widget vipCard(MonthlyCard card, int index) {
    return GestureDetector(
      onTap: () {
        _vipController.setSelectedCard(index);
      },
      child: Obx(() => Container(
            margin: EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(6)),
              //设置四周边框
              border: new Border.all(
                  color: _vipController.selectedIndex.value == index
                      ? MyColor.mainColor
                      : Color(0x4df3cd8e),
                  width: 1),
            ),
            width: 100,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${card.describe}',
                  style: TextStyle(color: Color(0xff8c8c8c), fontSize: 12),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${card.text3}',
                  style: TextStyle(color: Color(0xffF3CD8E), fontSize: 26),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          )),
    );
  }
}
