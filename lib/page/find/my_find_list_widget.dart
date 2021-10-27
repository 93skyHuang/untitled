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
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/null_list_widget.dart';

///发现页面列表页面 需要传入发现id
class MyFindListWidget extends StatefulWidget {
  int id;
  bool isNeedSvip;

  MyFindListWidget(this.id, {Key? key, this.isNeedSvip = true})
      : super(key: key);

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

  final HomeController _homeController = Get.find();

  @override
  void initState() {
    logger.i('initState');
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      logger.i('addPostFrameCallback');
      isCanRefreshPage = true;
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.i(widget.id);
    super.build(context);
    return RefreshConfiguration(
      // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
      hideFooterWhenNotFull: true,
      child: Obx(() => !_homeController.isSvip.value && widget.isNeedSvip
          ? Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize:MainAxisSize.min,
                  children: [
                    Text(
                      '开通SVIP，成为其中的一员与同城附近异性互动',
                      style: TextStyle(fontSize: 22, color: MyColor.grey8C8C8C),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                        style: ButtonStyle(
                            //去除点击效果
                            // overlayColor: MaterialStateProperty.all(Colors.transparent),
                            minimumSize:
                                MaterialStateProperty.all(const Size(0, 0)),
                            visualDensity: VisualDensity.compact,
                            padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                            //圆角
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            //背景
                            backgroundColor:
                                MaterialStateProperty.all(MyColor.mainColor)),
                        onPressed: () {},
                        child: Text('立即开通',
                            style:
                                TextStyle(fontSize: 24, color: Colors.white)))
                  ],
                ),
              ),
            )
          : SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: const MyClassicHeader(),
              footer: const MyClassicFooter(),
              // 配置默认底部指示器
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: _gridView(),
            )),
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
                _refreshController.loadComplete(),
                _list.addAll(value.data ?? []),
                updatePage(),
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
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
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
}
