//
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/discover_info.dart';
import 'package:untitled/network/http_manager.dart';

///发现页面列表页面 需要传入发现id
class MyFindListWidget extends StatefulWidget {
  int id;

  MyFindListWidget(this.id, {Key? key}) : super(key: key);

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

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
        header: const WaterDropHeader(),
        footer: const ClassicFooter(),
        // 配置默认底部指示器
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: GridView.count(
          //GridView内边距
          padding: EdgeInsets.all(ScreenUtil().setWidth(4)),
          //垂直子Widget之间间距
          mainAxisSpacing: ScreenUtil().setWidth(4),
          //一行的Widget数量
          crossAxisCount: 2,
          //子Widget宽高比例
          childAspectRatio: itemWidth / itemHeight,
          children: _getWidgets(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onRefresh() async {
    logger.i("_onRefresh");
    pageNo = 1;
    getData();
  }

  // 上拉加载更多
  void _onLoading() async {
    logger.i("_onLoading");
    pageNo++;
    getData(isLoad: true);
  }

  void getData({bool isLoad = false}) {
    getDiscoverList(pageNo, widget.id).then((value) => {
          if (value.isOk())
            {
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
                }
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
    setState(() {});
  }

  List<Widget> _getWidgets() {
    List<Widget> list = [];
    int length = _list.length;
    if (length == 0) {
      list.add(const Text('暂无数据'));
    } else {
      for (int i = 0; i < length; i++) {
        list.add(_item(_list[i]));
      }
    }
    return list;
  }

  Widget _item(DiscoverInfo discoverInfo) {
    return Container(
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
        ));
  }

  Widget _imageWrapper(DiscoverInfo discoverInfo) {
    logger.i(discoverInfo.headImgUrl);
    return SizedBox(
        width: itemWidth,
        height: itemWidth,
        child: CachedNetworkImage(
          fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
          imageUrl: discoverInfo.headImgUrl ?? '',
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/image_load_failed.png',
            fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
          ),
        ));
  }

  Widget _itemInfo(DiscoverInfo discoverInfo) {
    return Padding(
        padding: EdgeInsets.only(left:ScreenUtil().setWidth(2),right:ScreenUtil().setWidth(2),),
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
              const Flexible(
                  child: Align(alignment: Alignment.center, child: Text(''))),
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(2)),
                child: Image.asset(
                  'assets/images/ic_location.png',
                ),
              ),
              Text(
                '${discoverInfo.region}',
                style: TextStyle(
                    color: MyColor.grey8C8C8C,
                    fontSize: ScreenUtil().setSp(10)),
              ),
            ],
          )
        ]));
  }
}
