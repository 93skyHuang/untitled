import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/page/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: CommonColor.BottomRed,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.asset(
              "assets/images/login_bg.png",
              width: double.infinity,
              height: double.infinity,
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            ),
          ),
          Align(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().radius(30),
                        ScreenUtil().radius(50),
                        ScreenUtil().radius(30),
                        ScreenUtil().radius(65)),
                    child: Column(
                      children: [
                        Text('手机号登录/注册'),
                        TextField(
                          controller: _controllerPhone,
                        ),
                        TextField(
                          controller: _controllerCode,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.find<LoginController>()
                                  .getSmsCode(_controllerPhone.text);
                            },
                            child: Text('获取验证码')),
                        TextButton(
                            onPressed: () {
                              Get.find<LoginController>()
                                  .getSmsCode(_controllerPhone.text);
                            },
                            child: Text('获取验证码')),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
