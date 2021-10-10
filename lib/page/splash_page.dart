import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/persistent/sp_util.dart';

import '../route_config.dart';

/**
 * 闪屏页面
 */
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  void init(BuildContext context) {
    //设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(360, 690),
        orientation: Orientation.portrait);
    pageJump();
  }

  void pageJump() {
    SPUtils.getUid().then((value) => {
          if (value == -1)
            autoLogin(value).then((value) => {
                  if (value.isOk())
                    {Get.offNamed(homePName)}
                  else
                    {Get.offNamed(loginPName)}
                })
          else
            Get.offNamed(loginPName)
        });
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColor.mainColor,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.asset(
              "assets/images/launch_image.png",
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
