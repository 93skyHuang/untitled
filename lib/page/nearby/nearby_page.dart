import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/nearby_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/dialog.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/my_text_widget.dart';
import 'package:untitled/widgets/null_list_widget.dart';
import 'package:untitled/widgets/card_image.dart';

//附近页面主体
class NearbyPage extends StatefulWidget {
  const NearbyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NearbyPageState();
  }
}

class _NearbyPageState extends State<NearbyPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int pageNo = 1;
  List<NearbyInfo> _list = [];

  //中间text 占的宽度
  final double _textContextWidth =
      ScreenUtil().screenWidth - ScreenUtil().setWidth(100 + 50);

  @override
  void initState() {
    logger.i('initState');
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('CommunityPage');
    super.build(context);
    return Scaffold(
        backgroundColor: MyColor.pageBgColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColor.pageBgColor,
          elevation: 0,
          title: Text(
            '附近',
            style: TextStyle(
                color: MyColor.blackColor, fontSize: ScreenUtil().setSp(18)),
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const MyClassicHeader(),
          footer: const MyClassicFooter(),
          // 配置默认底部指示器
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: _getListView(),
        ));
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
    if (GetStorageUtils.getSvip()) {
      pageNo++;
      getData(isLoad: true);
    } else {
      _refreshController.loadFailed();
      showOpenSvipDialog(context);
    }
  }

  void getData({bool isLoad = false}) {
    getNearbyList(pageNo).then((value) => {
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
    setState(() {});
  }

  Widget _getListView() {
    int length = _list.length;
    if (length == 0) {
      return NullListWidget();
    } else {
      List<Widget> listView = [];
      for (int i = 0; i < length; i++) {
        listView.add(_itemView(_list[i]));
      }
      return ListView(
        children: listView,
      );
    }
  }

  Widget _itemView(NearbyInfo info) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setWidth(130),
      child: Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(4),
            right: ScreenUtil().setWidth(6),
            bottom: ScreenUtil().setWidth(16),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              child: headImg(info.headImgUrl ?? ''),
              onTap: () {
                logger.i('点击大头像');
                bool isSvip = GetStorageUtils.getSvip();
                if (!isSvip) {
                  showOpenSvipDialog(context);
                }else {
                  Get.to(() => UserHomePage(uid:info.uid,initialIndex: 2,));
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _info1(info),
                  _info2(info),
                  singeLineText(
                      '${info.autograph}',
                      ScreenUtil().setWidth(130),
                      TextStyle(
                          color: MyColor.grey8C8C8C,
                          fontSize: ScreenUtil().setSp(12))),
                  _info3(info),
                ],
              ),
            ),
            const Flexible(child: Align()),
            _chat(info),
          ])),
    );
  }

  Widget headImg(String imaUrl) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(4)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: SizedBox(
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setWidth(114),
          child: CachedNetworkImage(
            fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            imageUrl: imaUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/image_load_failed.png',
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            ),
          )),
    );
  }

  Widget _info1(NearbyInfo info) {
    return Row(
      children: [
        singeLineText(
            '${info.cname}',
            ScreenUtil().setWidth(90),
            TextStyle(
                color: MyColor.blackColor, fontSize: ScreenUtil().setSp(14))),
        singeLineText(
            '${info.loginTime}',
            ScreenUtil().setWidth(60),
            TextStyle(
                color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10))),
      ],
    );
  }

  Widget _info2(NearbyInfo info) {
    return Row(
      children: [
        Text(
          '${info.distance}',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10)),
        ),
        VDivider(),
        Text(
          '${info.age}',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10)),
        ),
        VDivider(),
        Text(
          '${info.height}cm',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(10)),
        ),
        info.education == null ? Text('') : VDivider(),
        info.education == null
            ? Text('')
            : Text(
                '${info.education}',
                style: TextStyle(
                    color: MyColor.grey8C8C8C,
                    fontSize: ScreenUtil().setSp(10)),
              ),
      ],
    );
  }

  ///动态图
  Widget _info3(NearbyInfo info) {
    List<TrendsImg?> list = info.trendsImg;
    List<Widget> listWidget = [];
    int length = list.length;
    if (length > 0) {
      for (int i = 0; i < length && i < 3; i++) {
        listWidget.add(_infoTrends(list[i] ?? TrendsImg(-1, -1)));
      }
    }
    return Row(
      children: listWidget,
    );
  }

  //动态
  Widget _infoTrends(TrendsImg trendsImg) {
    return GestureDetector(
      child: cardNetworkImage(trendsImg.imgArr, ScreenUtil().setWidth(45),
          ScreenUtil().setWidth(45),
          radius: 8),
      onTap: () {
        logger.i(trendsImg);
        bool isSvip = GetStorageUtils.getSvip();
        if (!isSvip) {
          showOpenSvipDialog(context);
        }else{
          // Get.to(() => UserHomePage(uid:info.uid,initialIndex: 2,));
        }
      },
    );
  }

  ///搭讪
  Widget _chat(NearbyInfo info) {
    return Column(
      children: [
        const Flexible(child: Align()),
        TextButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(0, 0)),
            visualDensity: VisualDensity.compact,
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          onPressed: () {
            logger.i(info.cname);
          },
          child: Image.asset('assets/images/nearby_chat.png'),
        ),
        Text(
          '搭讪',
          style: TextStyle(
              color: MyColor.blackColor, fontSize: ScreenUtil().setSp(10)),
        ),
        const Flexible(child: Align()),
      ],
    );
  }
}
