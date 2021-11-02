import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/network/bean/comment_info.dart';
import 'package:untitled/network/bean/new_trends_info.dart';
import 'package:untitled/network/bean/trends_details.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/community/recommend_item_widget.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_comment.dart';
import 'package:untitled/widget/loading.dart';
import 'package:untitled/widget/trend_img.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/toast.dart';

import '../../../route_config.dart';

class MyTrendDetailPage extends StatefulWidget {
  int trendsId;

  MyTrendDetailPage(this.trendsId);

  @override
  State<MyTrendDetailPage> createState() => _MyTrendDetailPageState(this.trendsId);
}

class _MyTrendDetailPageState extends State<MyTrendDetailPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int trendsId;

  _MyTrendDetailPageState(this.trendsId);

  double contextWidth =
      ScreenUtil().screenWidth - ScreenUtil().setWidth(50 + 32 + 16);

  @override
  void initState() {
    super.initState();
    getDtails();
    getCommentsInfo();
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
        title: Text("动态详情", style: TextStyle(fontSize: 17, color: Colors.black)),
        backgroundColor: Color(0xFFF5F5F5),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          RefreshConfiguration(
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cardNetworkImage(
                              '${trendsInfo.headImgUrl}',
                              ScreenUtil().setWidth(44),
                              ScreenUtil().setWidth(44),
                              margin: EdgeInsets.only(right: 16)),
                          Expanded(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _itemName(),
                                  const Flexible(child: Align()),
                                  // FocusOnBtn(info),
                                ],
                              )),
                              if (trendsInfo.content != null&&trendsInfo.content != '')
                                CustomText(
                                  text: "${trendsInfo.content??''}",
                                  margin: EdgeInsets.only(top: 5),
                                  textStyle: TextStyle(
                                      color: MyColor.grey8C8C8C,
                                      fontSize: ScreenUtil().setSp(14)),
                                ),
                              if (trendsInfo.imgArr.isNotEmpty)
                                TrendImg(
                                  imgs: trendsInfo.imgArr,
                                  showAll: true,
                                  contextWidth: contextWidth,
                                  onClick: (int index) {
                                    Get.toNamed(photoViewPName, arguments: {
                                      'index': index,
                                      'photoList': trendsInfo.imgArr
                                    });
                                  },
                                ),
                              // _itemLable(),
                            ],
                          )),
                        ],
                      ),
                    ),
                    HDivider(
                      height: 8,
                    ),
                    getComments(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget getComments() {
    List<Widget> list = [];
    if (comments.isNotEmpty) {
      for (int i = 0; i < comments.length; i++) {
        CommentInfo commentBean = comments[i];
        list.add(ItemComment(
          onPressed: () {
            if (commentBean.isFabulous == 1) {
              delCommentFab(commentBean.id ?? 0, i);
            } else {
              addCommentFab(commentBean.id ?? 0, i);
            }
          },
          comment: commentBean,
        ));
      }
    }
    return Column(
      children: list,
    );
  }

  void _onRefresh() async {
    pageNo = 1;
    getCommentsInfo();
  }

  // 上拉加载更多
  void _onLoading() async {
    pageNo++;
    getCommentsInfo(isLoad: true);
  }

  late TrendsDetails trendsInfo=new TrendsDetails();

  void getDtails() {
    trendsDetails(trendsId).then((value) => {
          if (value.isOk())
            {
              trendsInfo = value.data!,
              setState(() {}),
            }
        });
  }

  int pageNo = 1;
  List<CommentInfo> comments = [];

  void getCommentsInfo({bool isLoad = false}) {
    getTrendsCommentList(pageNo, trendsId).then((value) => {
          if (value.isOk())
            {
              if (isLoad)
                {
                  _refreshController.loadComplete(),
                  comments.addAll(value.data ?? []),
                  setState(() {}),
                }
              else
                {
                  _refreshController.refreshCompleted(),
                  comments = value.data ?? [],
                  setState(() {}),
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

  void addCommentFab(int commentId, int index) {
    Loading.show(context);
    addCommentFabulous(commentId).then((value) => {
          Loading.dismiss(context),
          if (value.isOk())
            {
              comments[index].isFabulous = 1,
              comments[index].fabulousSum = (comments[index].fabulousSum! + 1),
              setState(() {}),
            }
        });
  }

  void delCommentFab(int commentId, int index) {
    Loading.show(context);
    deleteCommentFabulous(commentId).then((value) => {
          Loading.dismiss(context),
          if (value.isOk())
            {
              comments[index].isFabulous = 0,
              comments[index].fabulousSum = (comments[index].fabulousSum! - 1),
              setState(() {}),
            }
        });
  }

  Widget _itemName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${trendsInfo.cname}',
          style: TextStyle(
              color: MyColor.blackColor, fontSize: ScreenUtil().setSp(14)),
        ),
        Text(
          '${trendsInfo.time}',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(12)),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
