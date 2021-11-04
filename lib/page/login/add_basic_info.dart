import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/address.dart';
import 'package:untitled/network/bean/base_page_data.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/mine/nickname_page.dart';
import 'package:untitled/utils/image_picker_util.dart';
import 'package:untitled/utils/location_util.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:untitled/utils/picker_utils.dart';
import 'package:untitled/widgets/bottom_pupop.dart';
import 'package:untitled/widgets/toast.dart';

import '../../route_config.dart';

///添加个人基本信息
class AddBasicInfoPage extends StatefulWidget {
  const AddBasicInfoPage();

  @override
  State<AddBasicInfoPage> createState() => _AddBasicInfoPageState();
}

class _AddBasicInfoPageState extends State<AddBasicInfoPage> {
  String birthday = '';
  int? height;
  int sex = 1;

  //上传至oss返回的路径
  String? headerImgUrl;

  //本地选择的图片路径
  String? headerImgUrlLocal;

  String monthlyIncome = '';
  String education = '';
  String province = '';
  String city = '';
  String autograph = '';
  DateTime? _lastPressedAt; //上 次点击时间
  late double lat=0;
  late double lon=0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt ?? DateTime.now()) >
                  Duration(seconds: 2)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            MyToast.show('请先保持您的基本信息');
            return false;
          }
          return false;
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
                        showBottomImageSource(
                            context, _choicePicture, _tokePhoto);
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
                  _inputNickName(),
                  Divider(
                    height: 2.0,
                    color: Color(0xffE6E6E6),
                  ),
                  CustomText(
                    text: '介绍',
                    margin: EdgeInsets.only(top: 12, bottom: 10),
                  ),
                  _textFieldInfo(),
                  SizedBox(
                    height: 10,
                  ),
                  _itemArrow(
                    '城市',
                    '$province $city',
                    () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      getLocations();
                    },
                  ),
                  _itemArrow(
                    '性别',
                    '${sex==1?'男':'女'}',
                        () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _choiceSex();
                    },
                  ),
                  _itemArrow(
                    '生日',
                    birthday,
                    () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _choiceBirthday();
                    },
                  ),
                  _itemArrow(
                    '身高',
                    height == null ? '' : '${height}cm',
                    () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _choiceHeight();
                    },
                  ),
                  _itemArrow(
                    '月收入',
                    monthlyIncome,
                    () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _choiceMonthlyIncome();
                    },
                  ),
                  _itemArrow(
                    '学历',
                    education,
                    () {
                      FocusScope.of(context).requestFocus(FocusNode());
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

  Widget _textFieldInfo() {
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
        // 设置背景色
        fillColor: Colors.white,
        filled: true,
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

  final TextEditingController _controllerNickName = TextEditingController();

  Widget _inputNickName() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextField(
          textAlign: TextAlign.right,
          maxLength: 10,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(15),
            color: MyColor.blackColor,
          ),
          decoration: InputDecoration(
            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
            counterText: '',
            //此处控制最大字符是否显示
            alignLabelWithHint: true,
            hintText: '请输入昵称',
            hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              color: MyColor.grey8C8C8C,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0),
            ),
          ),
          onChanged: (value) {},
          controller: _controllerNickName,
        ),
        Text('昵称', style: TextStyle(fontSize: 15, color: Colors.black)),
      ],
    );
  }

  void _choicePicture() async {
    XFile? f = await getImageFromGallery();
    headerImgUrlLocal = f?.path;
    setState(() {});
  }

  void _choiceSex() async {
    showSexPicker(context, choice: sex-1,
        clickCallBack: (int index, dynamic d) {
          sex = index+1 ;
          setState(() {});
        });
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
    showEducationPicker(context,choice: education, clickCallBack: (int index, dynamic d) {
      education = d;
      setState(() {});
    });
  }

  bool isGetLocation=true;
  void getLocations() async {
    bool hasPermission = await checkAndRequestPermission();
    if (hasPermission) {
      isGetLocation=false;
      MyToast.show('正在获取您的位置...');
      Future.delayed(Duration(seconds: 2)).then((value) => {
        if(!isGetLocation){
          MyToast.show('定位失败'),
          _choiceCity(),
        }
      });
      Position position = await getPosition();
      isGetLocation=true;
      lon = position.longitude;
      lat = position.latitude;
      BasePageData<Address?> data = await getAddress(lon, lat);
      if (data.isOk()) {
        city = data.data?.region ?? '';
        setState(() {});
      }else{
        _choiceCity();
      }
    }else{
      _choiceCity();
    }
  }

  void _commitInfo() async {
    if (headerImgUrlLocal != null) {
      BasePageData<String?> basePageData =
          await fileUpload(headerImgUrlLocal ?? '');
      if (basePageData.isOk()) {
        headerImgUrl = basePageData.data;
      }
    }

    if (lon != null ||lon != 0|| lat != null|| lat != 0) {
      BasePageData basePageData = await updateUserInfo(
          headImgUrl: headerImgUrl,
          cname: _controllerNickName.text,
          birthday: birthday,
          autograph: autograph,
          longitude: lon,
          latitude: lat,
          sex: sex,
          monthlyIncome: monthlyIncome,
          education: education,
          height: height);
      if (basePageData.isOk()) {
        Get.offNamed(homePName);
      }
    }else{
      BasePageData basePageData = await updateUserInfo(
          headImgUrl: headerImgUrl,
          cname: _controllerNickName.text,
          birthday: birthday,
          autograph: autograph,
          province: province,
          region: city,
          sex: sex,
          monthlyIncome: monthlyIncome,
          education: education,
          height: height);
      if (basePageData.isOk()) {
        Get.offNamed(homePName);
      }
    }
  }
}
