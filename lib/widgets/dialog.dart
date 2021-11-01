import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/page/login/login_page.dart';
import 'package:untitled/page/mine/avatar/video_verified_page.dart';
import 'package:untitled/page/mine/vip/vip_page.dart';
import 'package:untitled/route_config.dart';

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
  Widget continueButton =
  TextButton(
    child: Text(
      "立即开通",
      style: TextStyle(color: MyColor.grey8C8C8C),
    ),
    onPressed: () {
      Navigator.pop(context);
      Get.to(VipPage());
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

showKickOutByOtherClientDialog(BuildContext context) {
  Widget continueButton =
  TextButton(
    child: Text(
      "重新登录",
      style: TextStyle(color: MyColor.grey8C8C8C),
    ),
    onPressed: () {
      NimNetworkManager.instance.logout();
      Get.offAllNamed(loginPName);
    },
  );
  //设置对话框
  AlertDialog alert = AlertDialog(
    title: Text("下线通知"),
    content: Text("您的账号已在其他手机登录，如需继续使用请重新登录"),
    actions: [
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

