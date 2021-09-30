import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/common_config.dart';

/**
 * 闪屏页面
 */
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  void init() {
    Future.delayed(Duration(milliseconds: 1000)).then((value) => Get.toNamed("/home"));
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: CommonColor.MainColor,
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
