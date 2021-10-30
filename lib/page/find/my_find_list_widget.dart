//
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/discover_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/home_controller.dart';
import 'package:untitled/page/mine/verify_center_page.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widgets/dialog.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/null_list_widget.dart';

///发现页面列表页面 需要传入发现id
class MyFindListWidget extends StatefulWidget {
  int id;
  bool isSvip;

  MyFindListWidget(this.id, {Key? key, this.isSvip = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyFindListWidgetState();
  }
}

class _MyFindListWidgetState extends State<MyFindListWidget>
    with AutomaticKeepAliveClientMixin {
  List<DiscoverInfo> _list = [];
  int pageNo = 1;
  double itemWidth = ScreenUtil().setWidth(182);
  double itemHeight = ScreenUtil().setWidth(237);
  bool isCanRefreshPage = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    logger.i('initState');
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      logger.i('addPostFrameCallback');
      isCanRefreshPage = true;
      getData();
      Future.delayed(const Duration(seconds: 3)).then((value) => {
            if (GetStorageUtils.getIsShowVerifiedTipsInHomePage())
              {
                GetStorageUtils.saveIsShowVerifiedTipsInHomePage(false),
                showBottomOpen(context),
              }
            else if (!widget.isSvip)
              {showOpenSvipDialog(context)}
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.i(widget.id);
    super.build(context);
    return RefreshConfiguration(
      // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
      hideFooterWhenNotFull: true,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MyClassicHeader(),
        footer: const MyClassicFooter(),
        // 配置默认底部指示器
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _gridView(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    logger.i('dispose');
    isCanRefreshPage = false;
  }

  void _onRefresh() async {
    logger.i("_onRefresh");
    isCanRefreshPage = true;
    pageNo = 1;
    getData();
  }

  // 上拉加载更多
  void _onLoading() async {
    logger.i("_onLoading");
    isCanRefreshPage = true;
    pageNo++;
    getData(isLoad: true);
  }

  void getData({bool isLoad = false}) {
    getDiscoverList(pageNo, widget.id).then((value) => {
          logger.i(value),
          if (value.isOk())
            if (isLoad)
              {
                if (value.data == null)
                  {
                    _refreshController.loadNoData(),
                  }
                else
                  {
                    _refreshController.loadComplete(),
                    _list.addAll(value.data ?? []),
                    updatePage(),
                  }
              }
            else
              {
                _refreshController.refreshCompleted(),
                _list = value.data ?? [],
                updatePage(),
              }
          else
            {
              isLoad
                  ? _refreshController.loadFailed()
                  : _refreshController.refreshFailed()
            }
        });
  }

  void updatePage() {
    logger.i('updatePage');
    if (isCanRefreshPage) {
      setState(() {});
    }
  }

  Widget _gridView() {
    int length = _list.length;
    if (length == 0) {
      return NullListWidget();
    } else {
      return GridView.count(
        //GridView内边距
        padding: EdgeInsets.all(ScreenUtil().setWidth(4)),
        //垂直子Widget之间间距
        mainAxisSpacing: ScreenUtil().setWidth(4),
        //一行的Widget数量
        crossAxisCount: 2,
        //子Widget宽高比例
        childAspectRatio: itemWidth / itemHeight,
        children: _getWidgets(),
      );
    }
  }

  List<Widget> _getWidgets() {
    List<Widget> list = [];
    int length = _list.length;
    for (int i = 0; i < length; i++) {
      list.add(_item(_list[i]));
    }
    return list;
  }

  Widget _item(DiscoverInfo discoverInfo) {
    return GestureDetector(
      onTap: () {
        logger.i(discoverInfo);
      },
      child: Container(
          width: itemWidth,
          height: itemHeight,
          //边框设置
          // decoration: const BoxDecoration(
          //   //背景
          //   color: Colors.white,
          //   //设置四周圆角 角度
          //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //   //设置四周边框
          //   border:  Border(),
          // ),
          //设置 child 居中
          alignment: const Alignment(0, 0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(4)),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: Column(
              children: [
                _imageWrapper(discoverInfo),
                _itemInfo(discoverInfo),
              ],
            ),
          )),
    );
  }

  Widget _imageWrapper(DiscoverInfo discoverInfo) {
    return InkWell(
        onTap: () {
          check(discoverInfo);
        },
        child: Stack(
          children: [
            SizedBox(
                width: itemWidth,
                height: itemWidth,
                child: CachedNetworkImage(
                  fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
                  imageUrl: discoverInfo.headImgUrl ?? '',
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/image_load_failed.png',
                    fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
                  ),
                )),
            Container(
              width: itemWidth,
              height: itemWidth,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(9)),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.black38,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(8),
                        ScreenUtil().setWidth(2),
                        ScreenUtil().setWidth(8),
                        ScreenUtil().setWidth(2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(3),
                            height: ScreenUtil().setWidth(3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            right: ScreenUtil().setWidth(5),
                          )),
                          Text(
                            discoverInfo.loginTime,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(9)),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ));
  }

  void check(DiscoverInfo discoverInfo) {
    logger.i('${discoverInfo.cname}');
    Get.to(UserHomePage(uid: discoverInfo.uid));
  }

  Widget _itemInfo(DiscoverInfo discoverInfo) {
    return Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(4),
          right: ScreenUtil().setWidth(4),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            '${discoverInfo.cname}',
            style: TextStyle(
                color: MyColor.blackColor, fontSize: ScreenUtil().setSp(12)),
          ),
          Row(
            children: [
              Text(
                '${discoverInfo.age}·${discoverInfo.constellation}',
                style: TextStyle(
                    color: MyColor.grey8C8C8C,
                    fontSize: ScreenUtil().setSp(10)),
              ),

              ///占位
              const Flexible(
                  child: Align(alignment: Alignment.center, child: Text(''))),
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(3)),
                child: Image.asset(
                  'assets/images/ic_location.png',
                ),
              ),
              Text(
                discoverInfo.region ?? '中国',
                style: TextStyle(
                    color: MyColor.grey8C8C8C,
                    fontSize: ScreenUtil().setSp(10)),
              ),
            ],
          )
        ]));
  }

  void showBottomOpen(BuildContext context) {
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
                      padding: EdgeInsets.only(
                          bottom: 20.0, left: 40, right: 40, top: 191),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/verified_tips_bg.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: Column(children: <Widget>[
                        CustomText(
                            text: "欢迎加入",
                            textStyle: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        CustomText(
                            text: "完善认证信息拿奖励，超多特权等你来。",
                            padding: EdgeInsets.only(top: 4, bottom: 20),
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        CustomText(
                            text: "1.您可以直接跟您喜欢的人聊天，对方都可以回复您",
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        CustomText(
                            text: "2.列表越上面的用户活跃度更好哦",
                            padding: EdgeInsets.only(top: 11, bottom: 11),
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        CustomText(
                            text: "3.每天多发一些动态，让更多的人关注您",
                            padding: EdgeInsets.only(top: 4, bottom: 11),
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        CustomText(
                            text: "4.完成认证您将解锁所有的权限",
                            padding: EdgeInsets.only(top: 4, bottom: 40),
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffE6E6E6))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _widgetIconAndText(
                                "assets/images/verified_tips_ic1.png", "身份标识"),
                            _widgetIconAndText(
                                "assets/images/verified_tips_ic2.png", "优先推荐"),
                            _widgetIconAndText(
                                "assets/images/verified_tips_ic3.png", "动态曝光"),
                            _widgetIconAndText(
                                "assets/images/verified_tips_ic4.png", "无限畅聊"),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Get.to(() => VerifyCenterPage());
                          },
                          child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              width: 214,
                              margin: EdgeInsets.only(top: 30),
                              decoration: new BoxDecoration(
                                color: Color(0xffF3CD8E),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: Text(
                                "立即认证",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: CustomText(
                              textAlign: Alignment.center,
                              text: "知道了",
                              padding: EdgeInsets.only(top: 20),
                              textStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff8C8C8C))),
                        ),
                      ]))
                ],
              ));
        });
  }

  Widget _widgetIconAndText(String img, String text) {
    return Column(children: [
      Image.asset(
        img,
      ),
      SizedBox(
        height: 12,
      ),
      CustomText(
          text: text,
          padding: EdgeInsets.only(top: 4, bottom: 20),
          textStyle: TextStyle(fontSize: 12, color: Color(0xffffffff))),
    ]);
  }
}
