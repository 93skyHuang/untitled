import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/base_page_data.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/mine/nickname_page.dart';
import 'package:untitled/utils/image_picker_util.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:untitled/utils/picker_utils.dart';

///添加个人基本信息
class AddBasicInfoPage extends StatefulWidget {
  const AddBasicInfoPage();

  @override
  State<AddBasicInfoPage> createState() => _AddBasicInfoPageState();
}

class _AddBasicInfoPageState extends State<AddBasicInfoPage> {
  String birthday = '';
  int? height;

  //上传至oss返回的路径
  String? headerImgUrl;

  //本地选择的图片路径
  String? headerImgUrlLocal;

  String monthlyIncome = '';
  String nickName = '';
  String education = '';
  String province = '';
  String city = '';
  String autograph = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.5,
              title: Text("编辑资料",
                  style: TextStyle(fontSize: 17, color: Colors.black)),
              backgroundColor: Color(0xFFF5F5F5),
              centerTitle: true,
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      _commitInfo();
                    },
                    child: Text("下一步",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17, color: MyColor.grey8C8C8C))),
              ]),
          backgroundColor: Color(0xFFF5F5F5),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        _showBottomOpen(context);
                      },
                      style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          visualDensity: VisualDensity.compact,
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: ClipOval(
                          child: Container(
                            width: 110,
                            height: 110,
                            child: headerImgUrlLocal == null
                                ? Image.asset(
                                    'assets/images/user_icon.png',
                                  )
                                : Image.file(
                                    File('$headerImgUrlLocal'),
                                    fit: Platform.isIOS
                                        ? BoxFit.cover
                                        : BoxFit.fill,
                                  ),
                          ),
                        ),
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Text("个人头像",
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => NicknamePage());
                    },
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(0, 0)),
                        visualDensity: VisualDensity.compact,
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Container(
                      height: 50,
                      child: Row(
                        children: [
                          Text('昵称',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                          Expanded(
                              child: Text(nickName,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: MyColor.grey8C8C8C))),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFF8C8C8C),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 2.0,
                    color: Color(0xffE6E6E6),
                  ),
                  CustomText(
                    text: '介绍',
                    margin: EdgeInsets.only(top: 12, bottom: 10),
                  ),
                  textFieldInfo(),
                  SizedBox(
                    height: 10,
                  ),
                  _itemArrow(
                    '城市',
                    '$province $city',
                    () {
                      _choiceCity();
                    },
                  ),
                  _itemArrow(
                    '生日',
                    birthday,
                    () {
                      _choiceBirthday();
                    },
                  ),
                  _itemArrow(
                    '身高',
                    height == null ? '' : '${height}cm',
                    () {
                      _choiceHeight();
                    },
                  ),
                  _itemArrow(
                    '月收入',
                    monthlyIncome,
                    () {
                      _choiceMonthlyIncome();
                    },
                  ),
                  _itemArrow(
                    '学历',
                    education,
                    () {
                      _choiceEducation();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('完善的基本信息可提升交友成功率哦~',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.red)),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  final TextEditingController _controllerInfo = TextEditingController();

  Widget textFieldInfo() {
    return TextField(
      maxLines: 3,
      //最多多少行
      minLines: 3,
      //最多多少行
      style: TextStyle(
        fontSize: ScreenUtil().setSp(15),
        color: MyColor.blackColor,
      ),
      decoration: InputDecoration(
        filled: false,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1)),
        counterText: '',
        //此处控制最大字符是否显示
        alignLabelWithHint: true,
        hintText: '请您简介一下自己',
        hintStyle: TextStyle(
          fontSize: ScreenUtil().setSp(15),
          color: MyColor.grey8C8C8C,
        ),
      ),
      controller: _controllerInfo,
    );
  }

  Widget _itemArrow(String text, String des, VoidCallback onPressed) {
    return Column(
      children: [
        TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(0, 0)),
              visualDensity: VisualDensity.compact,
              padding: MaterialStateProperty.all(EdgeInsets.zero)),
          child: Container(
            height: 50,
            child: Row(
              children: [
                Text(text, style: TextStyle(fontSize: 15, color: Colors.black)),
                Expanded(
                    child: Text(des,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 15, color: MyColor.grey8C8C8C))),
                Icon(
                  Icons.chevron_right,
                  color: Color(0xFF8C8C8C),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 2.0,
          color: Color(0xffE6E6E6),
        ),
      ],
    );
  }

  void _showBottomOpen(BuildContext context) {
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
                        padding: EdgeInsets.only(bottom: 20.0, top: 16),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        child: Column(children: <Widget>[
                          CustomText(
                              text: "选择照片来源",
                              textAlign: Alignment.center,
                              padding: EdgeInsets.only(bottom: 16),
                              textStyle:
                                  TextStyle(fontSize: 17, color: Colors.black)),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _tokePhoto();
                              },
                              child: CustomText(
                                  text: "拍照",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Colors.black))),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _choicePicture();
                              },
                              child: CustomText(
                                  text: "从相册中选择",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Colors.black))),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "取消",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Color(0xffFD4343)))),
                        ]))
                  ]));
        });
  }

  void _choicePicture() async {
    XFile? f = await getImageFromGallery();
    headerImgUrlLocal = f?.path;
    setState(() {});
  }

  //拍照
  void _tokePhoto() async {
    XFile? f = await getPhoto();
    headerImgUrlLocal = f?.path;
    setState(() {});
  }

  void _choiceCity() async {
    final result = await CityPickers.showCityPicker(
      showType: ShowType.pc,
      context: context,
      cancelWidget:
          Text('取消', style: TextStyle(fontSize: 15, color: Colors.grey)),
      confirmWidget:
          Text('确定', style: TextStyle(fontSize: 15, color: Colors.red)),
    );
    if (result != null) {
      province = result.provinceName ?? "";
      city = result.cityName ?? "";
      setState(() {});
    }
  }

  void _choiceBirthday() async {
    showMyDataPicker(context,
        clickCallBack: (String selectDateStr, DateTime selectData) {
      logger.i('selectDateStr$selectDateStr selectData$selectData');
      birthday = selectDateStr;
      setState(() {});
    });
  }

  void _choiceHeight() async {
    showHeightPicker(context, choice: height ?? 170,
        clickCallBack: (int index, dynamic d) {
      height = d;
      setState(() {});
    });
  }

  void _choiceMonthlyIncome() async {
    showMonthlyIncomePicker(context, clickCallBack: (int index, dynamic d) {
      monthlyIncome = d;
      setState(() {});
    });
  }

  void _choiceEducation() async {
    showEducationPicker(context, clickCallBack: (int index, dynamic d) {
      education = d;
      setState(() {});
    });
  }

  void _commitInfo() async {
    if (headerImgUrlLocal != null) {
      BasePageData<String?> basePageData =
          await fileUpload(headerImgUrlLocal ?? '');
      if (basePageData.isOk()) {
        headerImgUrl = basePageData.data;
      }
    }
    BasePageData basePageData = await updateUserInfo(
        headImgUrl: headerImgUrl,
        cname: nickName,
        birthday: birthday,
        autograph: autograph,
        province: province,
        region: city,
        monthlyIncome: monthlyIncome,
        education: education,
        height: height);
    if (basePageData.isOk()) {}
  }
}
