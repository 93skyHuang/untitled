import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/page/community/pull_dynamic_page.dart';
import 'package:untitled/page/global_controller.dart';
import 'package:untitled/page/login/add_basic_info.dart';
import 'package:untitled/page/mine/setting_page.dart';
import 'package:untitled/page/mine/verify_center_page.dart';
import 'package:untitled/page/mine/vip/vip_page.dart';
import 'package:untitled/page/mine/visitor/visitor_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_menu.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/dialog.dart';
import 'beliked/beliked_page.dart';
import 'black_page.dart';
import 'edit_basic_info.dart';
import 'fans/fan_page.dart';
import 'follow/follow_page.dart';
import 'history/history_page.dart';
import 'info/edit_user_info.dart';
import 'like/like_page.dart';
import 'mine_controller.dart';
import 'myhome/my_home_page.dart';

class MinePage extends StatefulWidget {
  MinePage();

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final MineController _mineController = Get.put(MineController());
  final GlobalController _globalController = Get.find<GlobalController>();
  List<Widget> _menuItem = [];

  @override
  Widget build(BuildContext context) {
    logger.i('MinePage');
    return Scaffold(
      backgroundColor: Color(0xFF1D222A),
      body: SingleChildScrollView(
          child: Obx(() => Column(children: [
                Stack(children: [
                  Obx(() => cardNetworkImage(_mineController.headerImgUrl.value,
                      double.infinity, ScreenUtil().setHeight(270),
                      radius: 0, margin: EdgeInsets.all(0), fit: BoxFit.cover)),
                  Container(
                    color: Color(0xC4252C36),
                    height: ScreenUtil().setHeight(317),
                    width: double.infinity,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().statusBarHeight + 14, right: 16),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            child: Text(
                              '个人资料',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      _editInfoWidget(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipOval(
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: cardNetworkImage(
                                        _mineController.headerImgUrl.value,
                                        90,
                                        90,
                                        radius: 0,
                                        margin: EdgeInsets.all(0),
                                        fit: BoxFit.cover),
                                  ))),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  CustomText(
                                    text:
                                        '${_mineController.userBasic.value.cname}',
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(25),
                                        color: Colors.white),
                                  ),
                                  CustomText(
                                    text:
                                        '资料完整度${_mineController.userBasic.value.dataPerfection}%',
                                    textStyle: TextStyle(
                                        fontSize: 12, color: Color(0xff57688A)),
                                    margin: EdgeInsets.only(left: 10),
                                  ),
                                ],
                              ),
                              Expanded(child: Align()),
                              Column(
                                children: [
                                  CustomText(
                                    textAlign: Alignment.center,
                                    text:
                                        '${_mineController.userBasic.value.trendsList?.length}',
                                    textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(25),
                                      color: Color(0xffFF8B00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  CustomText(
                                    textAlign: Alignment.center,
                                    text: '动态 ',
                                    textStyle: TextStyle(
                                        fontSize: 14, color: Color(0xffE5E5E5)),
                                    margin: EdgeInsets.only(left: 16),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  CustomText(
                                    textAlign: Alignment.center,
                                    text:
                                        '${_mineController.userBasic.value.pasDaySum} ',
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        color: Color(0xffFF8B00),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  CustomText(
                                    textAlign: Alignment.center,
                                    text: '访客 ',
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xffE5E5E5),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  CustomText(
                                    textAlign: Alignment.center,
                                    text:
                                        '${_mineController.userBasic.value.followSum}',
                                    textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(25),
                                      color: Color(0xffFF8B00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  CustomText(
                                    textAlign: Alignment.center,
                                    text: '喜欢 ',
                                    textStyle: TextStyle(
                                        fontSize: 14, color: Color(0xffE5E5E5)),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                      ///认证
                      _ver(),
                      SizedBox(
                        width: 16,
                      ),
                      _item1Widget(),

                      ///
                      _svipWidget(),
                      Container(
                        height: ScreenUtil().setHeight(181),
                        margin: EdgeInsets.only(
                            left: 16, right: 16, top: 10, bottom: 16),
                        decoration: new BoxDecoration(
                          color: Color(0xff242932),
                          borderRadius:
                          BorderRadius.all(Radius.circular(4.0)),
                        ),
                        child: GridView.count(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10)),
                          crossAxisCount: 4,
                          // 设置每子元素的大小（宽高比）
                          mainAxisSpacing: ScreenUtil().setHeight(14),
                          childAspectRatio: 1.2,
                          physics: const NeverScrollableScrollPhysics(),
                          children: _getMenuItem(),
                        ),
                      ),
                    ],
                  )
                ]),
              ]))),
    );
  }

  Widget _editInfoWidget(){
    return            Container(
      height: ScreenUtil().setHeight(50),
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          left: 16, right: 16, top: 10, bottom: 16),
      decoration: new BoxDecoration(
        color: Color(0xff242932),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      padding: EdgeInsets.only(left: 16, right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: _mineController
                    .userBasic.value.dataPerfection ==
                    100
                    ? '如约而至'
                    : '完善基本资料',
                textStyle: TextStyle(
                    fontSize: 14, color: Colors.white),
              ),
              CustomText(
                text: _mineController
                    .userBasic.value.dataPerfection ==
                    100
                    ? '凡所际遇，绝非偶然，愿第一时间与你分享有趣的事'
                    : '详细的个人资料才能得到更多关注哟',
                textStyle: TextStyle(
                    fontSize: 12, color: Colors.white),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (_mineController
                  .userBasic.value.dataPerfection ==
                  100) {
                Get.to(PullDynamicPage());
              } else {
                Get.to(EditBasicInfoPage())!.then(
                        (value) => _mineController.getInfo());
              }
            },
            child: Container(
                padding: EdgeInsets.only(
                    left: 12, right: 12, bottom: 5, top: 3),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Text(
                  _mineController.userBasic.value
                      .dataPerfection ==
                      100
                      ? '立即前往'
                      : "去完善",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff5DB1DE),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _ver() {
    return Container(
        height: ScreenUtil().setHeight(58),
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
        decoration: new BoxDecoration(
          color: Color(0xff242932),
          // color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Row(
          children: [
            CustomText(
              textAlign: Alignment.center,
              text: '认证',
              textStyle: TextStyle(fontSize: 14, color: Colors.white),
              margin: EdgeInsets.only(left: 10, right: 10),
            ),
            _mineController.userBasic.value.isCard == 0
                ? card("assets/images/ic_ver_card.png", "实名", Color(0xff6385FF))
                : Container(),
            _mineController.userBasic.value.isHead == 0
                ? card(
                    "assets/images/ic_ver_avatar.png", "头像", Color(0xffFF8B00))
                : Container(),
            _mineController.userBasic.value.isVideo == 0
                ? card(
                    "assets/images/ic_video_ver.png", "真人", Color(0xff7581A8))
                : Container(),
            card("assets/images/ic_phone_ver.png", "手机", Color(0xffEE6F00)),
          ],
        ));
  }

  Widget _item1Widget() {
    return Container(
      height: ScreenUtil().setHeight(80),
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
      decoration: new BoxDecoration(
        color: Color(0xff242932),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 5,
        // 设置每子元素的大小（宽高比）
        childAspectRatio: 1.2,
        physics: const NeverScrollableScrollPhysics(),
        children: _getMenuItem1(),
      ),
    );
  }

  Widget _svipWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/mine_svip_bg.png',
          width: double.infinity,
          height: ScreenUtil().setHeight(90),
          fit: BoxFit.fill,
        ),
        Container(
          height: ScreenUtil().setHeight(80),
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _globalController.isSvip.value
                  ? CustomText(
                      textAlign: Alignment.center,
                      text: '会员有效期：${_mineController.svipEndTime.value}',
                      textStyle:
                          TextStyle(fontSize: 18, color: Color(0xffF3CD8E)),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: '开通SVIP会员',
                          textStyle:
                              TextStyle(fontSize: 15, color: Color(0xff2B313E)),
                        ),
                        CustomText(
                          text: '尊享10项专属特权，提高交友成功率',
                          textStyle:
                              TextStyle(fontSize: 10, color: Color(0xff2B313E)),
                        ),
                      ],
                    ),
              GestureDetector(
                onTap: () {
                  Get.to(() => VipPage())
                      ?.then((value) => _mineController.getPTime());
                },
                child: Container(
                    padding:
                        EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 3),
                    decoration: new BoxDecoration(
                      color: Color(0xff9FDFF0),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Obx(() => Text(
                          _globalController.isSvip.value ? "继续购买" : "立即开通",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff2B313E),
                          ),
                        ))),
              )
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _getMenuItem1() {
    return [
      ItemMenu(
        text: '认证中心',
        img: "assets/images/mine_verify.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          Get.to(() => VerifyCenterPage());
        },
      ),
      ItemMenu(
        text: '我的动态',
        img: "assets/images/mine_move.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          Get.to(() => MyHomePage());
        },
      ),
      ItemMenu(
        text: '上传相册',
        img: "assets/images/mine_album.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        margin: EdgeInsets.only(top: 8),
        onPressed: () {
          Get.to(() => MyHomePage(
                initIndex: 2,
              ));
        },
      ),
      ItemMenu(
        text: '我的主页',
        img: "assets/images/mine_page.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          Get.to(() => MyHomePage(
                initIndex: 2,
              ));
        },
      ),
      ItemMenu(
        text: '安全中心',
        img: "assets/images/mine_safe.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          Get.toNamed(webViewPName, arguments: {
            'url': 'http://www.sancun.vip/index/index/securityCenter',
            'title': '安全中心'
          });
        },
      ),
    ];
  }

  List<Widget> _getMenuItem() {
    // if (_menuItem.isEmpty) {
    _menuItem = [
      ItemMenu(
        text: '我的粉丝',
        img: "assets/images/mine_fans.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          bool isSvip = GetStorageUtils.getSvip();
          if (!isSvip) {
            showOpenSvipDialog(context);
          } else {
            Get.to(() => FanPage());
          }
        },
      ),
      ItemMenu(
        text: '我的关注',
        img: "assets/images/mine_focus.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          bool isSvip = GetStorageUtils.getSvip();
          if (!isSvip) {
            showOpenSvipDialog(context);
          } else {
            Get.to(() => FollowPage());
          }
        },
      ),
      ItemMenu(
        text: '我喜欢的',
        img: "assets/images/mine_like.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          bool isSvip = GetStorageUtils.getSvip();
          if (!isSvip) {
            showOpenSvipDialog(context);
          } else {
            Get.to(() => LikePage());
          }
        },
      ),
      ItemMenu(
        text: '喜欢我的',
        img: "assets/images/mine_follows.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          bool isSvip = GetStorageUtils.getSvip();
          if (!isSvip) {
            showOpenSvipDialog(context);
          } else {
            Get.to(() => BelikedPage());
          }
        },
      ),
      ItemMenu(
        text: '我的足迹',
        img: "assets/images/mine_history.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          bool isSvip = GetStorageUtils.getSvip();
          if (!isSvip) {
            showOpenSvipDialog(context);
          } else {
            Get.to(() => HistoryPage());
          }
        },
      ),
      ItemMenu(
        text: '我的访客',
        img: "assets/images/mine_visitor.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          bool isSvip = GetStorageUtils.getSvip();
          if (!isSvip) {
            showOpenSvipDialog(context);
          } else {
            Get.to(() => VisitorPage());
          }
        },
      ),
      ItemMenu(
        text: '设置',
        img: "assets/images/mine_setting.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          Get.to(() => SettingPage());
        },
      ),
      ItemMenu(
        text: '黑名单',
        img: "assets/images/black.png",
        textStyle: TextStyle(fontSize: 12, color: Color(0xffE5E5E5)),
        onPressed: () {
          Get.to(() => BlackPage());
        },
      ),
    ];
    // }
    return _menuItem;
  }

  Widget card(String img, String text, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: new BoxDecoration(
        //设置四周圆角 角度
        border: Border.all(color: color),
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
          width: ScreenUtil().setWidth(60),
          height: ScreenUtil().setHeight(25),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              img,
              width: 16,
              height: 16,
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              text,
              style: TextStyle(color: Color(0xffF5F5F5), fontSize: 14),
            )
          ])),
    );
  }
}
