import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/page/mine/avatar/video_verified_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_menu.dart';

import 'avatar/avatar_verified_page.dart';

class VerifyCenterPage extends StatelessWidget {
  bool isHead=GetStorageUtils.getIsHead();
  bool isVideo=GetStorageUtils.getIsVideo();
  VerifyCenterPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
            onPressed: () {
              Navigator.maybePop(context);
            }),
        title:
            Text("认证中心", style: TextStyle(fontSize: 17, color: Colors.black)),
        backgroundColor: Color(0xFFF5F5F5),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 220,
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('头像认证',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    CustomText(
                      text: '迅速提升吸引力，更容易被人喜欢',
                      textStyle:
                          TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
                      textAlign: Alignment.center,
                      margin: EdgeInsets.only(top: 2, bottom: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ItemMenu(
                          text: '认证标识',
                          img: "assets/images/icon_verified_name.png",
                          onPressed: () {},
                        ),
                        ItemMenu(
                          text: '提升推荐',
                          img: "assets/images/verify_center_recommond.png",
                          onPressed: () {},
                        ),
                        ItemMenu(
                          text: '加速曝光',
                          img: "assets/images/verify_center_arrow.png",
                          onPressed: () {},
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(()=>AvatarVerifiedPage());
                      },
                      child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          width: 214,
                          margin: EdgeInsets.only(top: 20),
                          decoration: new BoxDecoration(
                            color: Color(0xffF3CD8E),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: Text(
                            "立即认证",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          )),
                    )
                  ],
                )),
            Container(
                height: 220,
                alignment: Alignment.center,
                margin:
                EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('视频认证',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    CustomText(
                      text: '迅速提升吸引力，更容易被人喜欢',
                      textStyle:
                      TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
                      textAlign: Alignment.center,
                      margin: EdgeInsets.only(top: 2, bottom: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ItemMenu(
                          text: '认证标识',
                          img: "assets/images/icon_verified_name.png",
                          onPressed: () {},
                        ),
                        ItemMenu(
                          text: '提升推荐',
                          img: "assets/images/verify_center_recommond.png",
                          onPressed: () {},
                        ),
                        ItemMenu(
                          text: '加速曝光',
                          img: "assets/images/verify_center_arrow.png",
                          onPressed: () {},
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(()=>VideoVerifiedPage());
                        showBottomOpen(context);
                      },
                      child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          width: 214,
                          margin: EdgeInsets.only(top: 20),
                          decoration: new BoxDecoration(
                            color: Color(0xffF3CD8E),
                            borderRadius:
                            BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: Text(
                            "立即认证",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          )),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void showBottomOpen(BuildContext context) {
    showModalBottomSheet(
        enableDrag: false,
        elevation: 0,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            bottom: 20.0, left: 40, right: 40, top: 191),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/verify_bg.png",
                            ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        child: Column(children: <Widget>[
                          CustomText(
                              text: "真人认证",
                              textStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          CustomText(
                              text: "提交真实信息，助你快速脱单。",
                              padding: EdgeInsets.only(top: 4, bottom: 20),
                              textStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff8C8C8C))),
                          CustomText(
                              text: "1.请露出正脸和上半身，拍摄3秒以上15秒以内的视频",
                              textStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff8C8C8C))),
                          CustomText(
                              text: "2.请保证头像与真人认证为同一人",
                              padding: EdgeInsets.only(top: 11, bottom: 11),
                              textStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff8C8C8C))),
                          CustomText(
                              text: "3.视频仅用于官方认证，不会对用户展示",
                              padding: EdgeInsets.only(top: 4, bottom: 20),
                              textStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff8C8C8C))),
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              showCamera(context);
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              width: 214,
                              margin: EdgeInsets.only(top: 20),
                              decoration: new BoxDecoration(
                                color: Color(0xffF3CD8E),
                                borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: Text(
                                "开始认证",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ))
                            ,),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                              textAlign: Alignment.center,
                                text: "知道了",
                                padding: EdgeInsets.only(top:20),
                                textStyle: TextStyle(
                                    fontSize: 12, color: Color(0xff8C8C8C))),
                          ),
                        ]))
                  ]));
        });
  }
  void showCamera(BuildContext context) {
    showModalBottomSheet(
        enableDrag: false,
        elevation: 0,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            bottom: 20.0, left: 40, right: 40, top: 101),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        child: Column(children: <Widget>[
                          Image(
                            image:
                            AssetImage("assets/images/icon_circle.png"),
                          ),
                          CustomText(
                              text: "把脸移入圈内",
                              textAlign: Alignment.center,
                              margin: EdgeInsets.only(top: 30),
                              textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          CustomText(
                              text: "拍摄真实信息，获取“真人”标签",
                              margin: EdgeInsets.only(top: 20, bottom: 50),
                              textAlign: Alignment.center,
                              textStyle: TextStyle(
                                  fontSize: 15, color: Colors.white)),
                          Container(
                              height: 40,
                              alignment: Alignment.center,
                              width: 214,
                              decoration: new BoxDecoration(
                                color: Color(0xffF3CD8E),
                                borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: Text(
                                "立即认证",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              )),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                                textAlign: Alignment.center,
                                text: "取消认证",
                                padding: EdgeInsets.only(top:20),
                                textStyle: TextStyle(
                                    fontSize: 12, color: Color(0xff8C8C8C))),
                          ),
                        ]))
                  ]));
        });
  }
}
