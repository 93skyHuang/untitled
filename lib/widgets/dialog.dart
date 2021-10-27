import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/page/mine/avatar/video_verified_page.dart';

showOpenSvipDialog(BuildContext context) {
  //设置按钮
  Widget cancelButton = TextButton(
    child: Text(
      "暂不开通",
      style: TextStyle(color: MyColor.grey8C8C8C),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    style: ButtonStyle(
      //去除点击效果
      // overlayColor: MaterialStateProperty.all(Colors.transparent),
        minimumSize: MaterialStateProperty.all(const Size(0, 0)),
        visualDensity: VisualDensity.compact,
        padding: MaterialStateProperty.all(EdgeInsets.only(left: 6,right: 6)),
        //圆角
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4))),
        //背景
        backgroundColor: MaterialStateProperty.all(MyColor.mainColor)),
    child: Text(
      "立即开通",
      style: TextStyle(
          fontSize: 16,
          color: Colors.white
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
      Get.to(VideoVerifiedPage());
      // Get.to();
    },
  );

  //设置对话框
  AlertDialog alert = AlertDialog(
    title: Text("开通SVIP"),
    content: Text("开通SVIP，成为其中的一员与同城附近异性互动"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  //显示对话框
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}