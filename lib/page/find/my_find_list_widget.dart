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
import 'package:untitled/page/global_controller.dart';
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
  double itemHeight = ScreenUtil().setWidth(238);
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
    });
  }

  @override
  Widget build(BuildContext context) {
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
    if (GetStorageUtils.getSvip()) {
      isCanRefreshPage = true;
      pageNo++;
      getData(isLoad: true);
    } else {
      _refreshController.loadFailed();
      showOpenSvipDialog(context);
    }
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
      list.add(_item(_list[i], i));
    }
    return list;
  }

  Widget _item(DiscoverInfo discoverInfo, int index) {
    return GestureDetector(
      onTap: () {
        logger.i(discoverInfo);
      },
      child: Container(
          width: itemWidth,
          height: itemHeight,
          alignment: const Alignment(0, 0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(4)),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: Stack(
              children: [
                _imageWrapper(discoverInfo),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: _itemInfo(discoverInfo),
                ),
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
                    child: Text(
                      discoverInfo.loginTime,
                      style: TextStyle(
                          color: Colors.white, fontSize: ScreenUtil().setSp(9)),
                    ),
                  ),
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
    String constellation = '';
    String education = '';
    if (discoverInfo.constellation != null &&
        discoverInfo.constellation != '') {
      constellation = '·' + discoverInfo.constellation.toString();
    }
    if (discoverInfo.education != null && discoverInfo.education != '') {
      education = '.' + discoverInfo.education.toString();
    }
    return Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(4),
          right: ScreenUtil().setWidth(4),
          top: ScreenUtil().setHeight(4),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            '${discoverInfo.cname}',
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(16)),
          ),
          Row(
            children: [
              Text(
                '${discoverInfo.age ?? ''}$constellation$education',
                style: TextStyle(
                    color: Color(0xffF5F5F5),
                    fontSize: ScreenUtil().setSp(12)),
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
                    color: Color(0xffF5F5F5),
                    fontSize: ScreenUtil().setSp(12)),
              ),
            ],
          )
        ]));
  }
}
