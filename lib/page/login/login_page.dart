import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:untitled/basic/include.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/page/login/login_controller.dart';
import 'package:untitled/widgets/click_specitied_string_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final LoginController _loginController = Get.put(LoginController());

  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                        ScreenUtil().radius(94),
                        ScreenUtil().radius(30),
                        ScreenUtil().radius(65)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '手机号登录/注册',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.whiteFFFFFF,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30))),
                        textFieldPhone(),
                        Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(20))),
                        textFieldCode(),
                        Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30))),
                        textButtonLogin(),
                      ],
                    )),
                //占位
                const Flexible(
                    child: Align(alignment: Alignment.center, child: Text(''))),
                bottomText(),
                Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(55)))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget textFieldPhone() {
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(15),
        color: MyColor.whiteFFFFFF,
      ),
      maxLength: 11,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      decoration: InputDecoration(
        filled: false,
        // enabledBorder:const OutlineInputBorder(
        //     borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1)),
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        counterText: '',
        //此处控制最大字符是否显示
        alignLabelWithHint: true,
        hintText: '请输入手机号',
        hintStyle: TextStyle(
          fontSize: ScreenUtil().setSp(15),
          color: MyColor.grey8C8C8C,
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1)),
      ),
      controller: _controllerPhone,
    );
  }

  Widget textFieldCode() {
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(15),
        color: MyColor.whiteFFFFFF,
      ),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      decoration: InputDecoration(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        counterText: '',
        //此处控制最大字符是否显示
        alignLabelWithHint: true,
        hintText: '请输入验证码',
        hintStyle: TextStyle(
          fontSize: ScreenUtil().setSp(15),
          color: MyColor.grey8C8C8C,
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1)),
        suffix: Obx(
          () => TextButton(
            onPressed: () {
              if (_loginController.isSendSmsCode.isFalse) {
                String phone = _controllerPhone.value.text;
                if (phone.isNotEmpty) {
                  _loginController.getSmsCode(phone);
                }
              }
            },
            child: Text(
              _loginController.isSendSmsCode.isTrue ? '验证码已发送' : '获取验证码',
              style: TextStyle(
                  color: MyColor.whiteFFFFFF, fontSize: ScreenUtil().setSp(14)),
            ),
          ),
        ),
      ),
      onChanged: (value) {},
      controller: _controllerCode,
    );
  }

  Widget textButtonLogin() {
    return TextButton(
        onPressed: () {
          _login();
        },
        child: Text(
          '登录',
          style: TextStyle(
              color: MyColor.TextBlackColor, fontSize: ScreenUtil().setSp(16)),
        ),
        style: ButtonStyle(
            enableFeedback: false,
            backgroundColor: MaterialStateProperty.all(MyColor.BtnNormalColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                // side: BorderSide(
                //   width: 0.5,
                //   color: MyColor.BtnNormalColor,
                // ),
                borderRadius: BorderRadius.circular(30),
              ),
            )));
  }

  Widget bottomText() {
    return ClickSpecifiedStringText(
      originalStr: const ['注册/登录即表示同意', '和'],
      clickStr: const ['《用户协议》', '《隐私条款》'],
      onTaps: [
        TapGestureRecognizer()
          ..onTap = () {
            _clickProtocol();
          },
        TapGestureRecognizer()
          ..onTap = () {
            _clickPrivacy();
          },
      ],
    );
  }

  void _login() {
    String phone = _controllerPhone.value.text;
    String code = _controllerCode.value.text;
    if (phone.isNotEmpty && code.isNotEmpty) {
      _loginController.login(phone, code);
    }
  }

  void _clickProtocol() {
    logger.i('o_clickProtocol');
  }

  void _clickPrivacy() {
    logger.i('_clickPrivacy');
  }
}
