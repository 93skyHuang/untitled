import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/common_config.dart';

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
    Future.delayed(Duration(milliseconds: 1000))
        .then((value) => Get.toNamed(homePName));
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
            color: MyColor.MainColor,
          ),
          // ConstrainedBox(
          //   constraints: const BoxConstraints.expand(),
          //   child: Image.asset(
          //     Platform.isIOS
          //         ? "assets/images/splash_ios.png"
          //         : "assets/images/splash.png",
          //     fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
          //   ),
          // ),
          // Align(
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: EdgeInsets.only(
          //             top: ScreenUtil.getInstance().getAdapterSize(50)),
          //         child: Platform.isIOS
          //             ? Text('')
          //             : Image(
          //           image: AssetImage('assets/images/splash_logo.png'),
          //         ),
          //       ),
          //       Padding(
          //           padding: EdgeInsets.only(top: Platform.isIOS ? 50 : 15),
          //           child: Text(
          //             S.of(context).splash_bg_title,
          //             style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize:
          //                 ScreenUtil.getInstance().getAdapterSize(14)),
          //           )),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
