import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/utils/picker_utils.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/custom_text_15radius.dart';
import 'package:untitled/widget/item_arrow.dart';
import '../edit_basic_info.dart';
import 'edit_user_info_controller.dart';

class EditUser extends StatefulWidget {
  const EditUser();

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final EditUserInfoController _editUserInfoController =
      Get.put(EditUserInfoController());
  String province = '';
  String city = '';
  int? heightStart;
  int? heightEnd;
  int? ageStart;
  int? ageEnd;
  String constellation = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.5,
            leading: new IconButton(
                icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
                onPressed: () {
                  Navigator.maybePop(context);
                }),
            title: Text("编辑资料",
                style: TextStyle(fontSize: 17, color: Colors.black)),
            backgroundColor: Color(0xFFF5F5F5),
            centerTitle: true,
            actions: <Widget>[
              Container(
                child: TextButton(
                  onPressed: () {
                    _editUserInfoController.setUser();
                  },
                  child: Text("保存",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, color: Color(0xFFFD4343))),
                ),
              ),
            ]),
        backgroundColor: Color(0xFFF5F5F5),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 30, bottom: 20),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage("assets/images/user_icon.png"),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("个人头像",
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                ),
                ItemArrow(
                  onPressed: () {
                    Get.to(() => EditBasicInfoPage());
                  },
                  text: '基本资料',
                  showDivider: false,
                  padding: EdgeInsets.only(left: 16, right: 16),
                ),
                CustomText(
                  text: '昵称：小飞象  城市：成都市  性别：女',
                  textStyle: TextStyle(fontSize: 14, color: Color(0xff8C8C8C)),
                  margin: EdgeInsets.only(left: 16, bottom: 16),
                ),
                Container(
                  height: 8.0,
                  color: Color(0xffE6E6E6),
                ),
                CustomText(
                  text: '择偶要求',
                  margin: EdgeInsets.only(top: 16, left: 16),
                ),
                ItemArrow(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _choiceCity();
                  },
                  text: '城市',
                  value:
                      '${_editUserInfoController.userInfo.value.expectRegion}',
                  padding: EdgeInsets.only(left: 16, right: 16),
                ),
                ItemArrow(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _choiceHeight();
                  },
                  text: '身高',
                  value:
                      '${_editUserInfoController.userInfo.value.expectHeight}',
                  padding: EdgeInsets.only(left: 16, right: 16),
                ),
                ItemArrow(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _choiceAge();
                  },
                  text: '年龄',
                  value: '${_editUserInfoController.userInfo.value.expectAge}',
                  padding: EdgeInsets.only(left: 16, right: 16),
                ),
                ItemArrow(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _choiceConstellation();
                  },
                  text: '星座',
                  value:
                      '${_editUserInfoController.userInfo.value.expectConstellation}',
                  padding: EdgeInsets.only(left: 16, right: 16),
                ),
                Container(
                  height: 8.0,
                  color: Color(0xffE6E6E6),
                  padding: EdgeInsets.only(left: 16, right: 16),
                ),
                ItemArrow(
                  onPressed: () {
                    showHobby(context);
                  },
                  text: '兴趣爱好',
                  showDivider: false,
                  padding: EdgeInsets.only(left: 16, right: 16),
                ),
                Wrap(
                    children: List.generate(
                        _editUserInfoController.userInfo.value.hobby!.length,
                        (index) {
                  return CustomTextRadius(
                    margin: EdgeInsets.only(left: 16, bottom: 16),
                    text:
                        '${_editUserInfoController.userInfo.value.hobby![index]}',
                  );
                })),
              ],
            ),
          ),
// This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  void showHobby(BuildContext context) {
    showModalBottomSheet(
        enableDrag: false,
        elevation: 0,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context1, state) {
            return Container(
                alignment: Alignment.bottomCenter,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                        Widget>[
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
                          text: '兴趣爱好',
                          margin: EdgeInsets.only(top: 8, left: 16, bottom: 16),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 11, right: 11),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 2.4,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _editUserInfoController.hobby.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              bool isChoose = _editUserInfoController
                                  .userInfo.value.hobby!
                                  .contains(
                                      _editUserInfoController.hobby[index]);
                              return ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        if (isChoose) {
                                          _editUserInfoController
                                              .userInfo.value.hobby!
                                              .remove(_editUserInfoController
                                                  .hobby[index]);
                                        } else {
                                          _editUserInfoController
                                              .userInfo.value.hobby!
                                              .add(_editUserInfoController
                                                  .hobby[index]);
                                        }
                                        state(() {});
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: isChoose
                                              ? Colors.black
                                              : Color(0xFFE2E2E2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                        ),
                                        alignment: Alignment.center,
                                        height: 30,
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Text(
                                          _editUserInfoController.hobby[index],
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: isChoose
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      )),
                                ],
                              );
                            },
                          ),
                        ),
                      ]))
                ]));
          });
        });
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
      _editUserInfoController.userInfo.value.region = city;
    }
  }

  final List<int> _heightStart = [];
  final List<int> _heightEnd = [];
  final List<List<int>> heightLists = [];

  void _choiceHeight() async {
    List<String> height =
        _editUserInfoController.userInfo.value.expectHeight!.split('-');
    try {
      if (height != null && height.length == 2) {
        heightStart = int.parse(height[0]);
        heightEnd = int.parse(height[1]);
      }
    } catch (e) {
      heightStart = 160;
      heightEnd = 170;
    }
    if (heightLists.isEmpty) {
      for (int i = 50; i < 220; i++) {
        _heightStart.add(i);
        _heightEnd.add(i);
      }
      heightLists.add(_heightStart);
      heightLists.add(_heightEnd);
    }
    showArrayPicker<int>(context, data: heightLists, title: '身高范围',
        clickCallBack: (List<int> index) {
      if (_heightStart[index[0]] > _heightEnd[index[1]]) {
        heightStart = _heightEnd[index[1]];
        heightEnd = _heightStart[index[0]];
      } else {
        heightEnd = _heightEnd[index[1]];
        heightStart = _heightStart[index[0]];
      }
      _editUserInfoController.userInfo.value.expectHeight =
          heightStart.toString() + '-' + heightEnd.toString();
    }, normalIndex: [
      _heightStart.indexOf(heightStart ?? 160),
      _heightEnd.indexOf(heightEnd ?? 170)
    ]);
  }

  final List<int> _ageStart = [];
  final List<int> _ageEnd = [];
  final List<List<int>> lists = [];

  void _choiceAge() async {
    List<String> age =
        _editUserInfoController.userInfo.value.expectAge!.split('-');
    try {
      if (age != null && age.length == 2) {
        ageStart = int.parse(age[0]);
        ageEnd = int.parse(age[1]);
      }
    } catch (e) {
      ageStart = 20;
      ageEnd = 25;
    }
    if (lists.isEmpty) {
      for (int i = 18; i < 80; i++) {
        _ageStart.add(i);
        _ageEnd.add(i);
      }
      lists.add(_ageStart);
      lists.add(_ageEnd);
    }
    showArrayPicker<int>(context, data: lists, title: '年龄范围',
        clickCallBack: (List<int> index) {
      if (_ageStart[index[0]] > _ageEnd[index[1]]) {
        ageStart = _ageEnd[index[1]];
        ageEnd = _ageStart[index[0]];
      } else {
        ageEnd = _ageEnd[index[1]];
        ageStart = _ageStart[index[0]];
      }
      _editUserInfoController.userInfo.value.expectAge =
          ageStart.toString() + '-' + ageEnd.toString();
    }, normalIndex: [
      _ageStart.indexOf(ageStart ?? 20),
      _ageEnd.indexOf(ageEnd ?? 25)
    ]);
  }

  void _choiceConstellation() async {
    constellation = _editUserInfoController.userInfo.value.expectConstellation!;
    showConstellationsPicker(context,
        choice: constellation == '' ? '水瓶座' : constellation,
        clickCallBack: (int index, dynamic d) {
      constellation = d;
      _editUserInfoController.userInfo.value.expectConstellation =
          constellation;
    });
  }
}
