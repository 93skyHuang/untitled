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
import 'package:untitled/widgets/dialog.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/toast.dart';

import '../../route_config.dart';

class TrendDetailPage extends StatefulWidget {
  int trendsId;

  TrendDetailPage(this.trendsId);

  @override
  State<TrendDetailPage> createState() => _TrendDetailPageState(this.trendsId);
}

class _TrendDetailPageState extends State<TrendDetailPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int trendsId;

  _TrendDetailPageState(this.trendsId);

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
          title:
              Text("????????????", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        body: GestureDetector(
          onTap: () => hideKeyboard(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              RefreshConfiguration(
                // Viewport???????????????,??????????????????????????????,????????????????????????????????????????????????????????????????????????????????????????????????????????????0
                hideFooterWhenNotFull: true,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: const MyClassicHeader(),
                  footer: const MyClassicFooter(),
                  // ???????????????????????????
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _itemName(),
                                      const Flexible(child: Align()),
                                      // FocusOnBtn(info),
                                    ],
                                  )),
                                  if (trendsInfo.content != null &&
                                      trendsInfo.content != '')
                                    CustomText(
                                      text: "${trendsInfo.content ?? ''}",
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
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    padding:
                        EdgeInsets.only(left: 16, right: 16, bottom: 6, top: 6),
                    color: Color(0xffF0F0F0),
                    child: Row(
                      children: [
                        Expanded(child: _textField()),
                        GestureDetector(
                          onTap: () {
                            sendComment();
                          },
                          child: Container(
                              height: 40,
                              width: 80,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 16),
                              decoration: new BoxDecoration(
                                color: Color(0xffF3CD8E),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              child: Text(
                                "??????",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

  void sendComment() {
    Loading.show(context);
    addComment(trendsId, _controllerInfo.text).then((value) => {
          Loading.dismiss(context),
          if (value.isOk())
            {
              _controllerInfo.text = '',
              MyToast.show('?????????'),
              _onRefresh(),
              FocusScope.of(context).requestFocus(FocusNode()),
            }
          else if (value.msg.isNotEmpty)
            {
              MyToast.show(value.msg),
            }
        });
  }

  final TextEditingController _controllerInfo = TextEditingController();

  Widget _textField() {
    return TextField(
      maxLength: 100,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(15),
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
        counterText: '',
        //????????????????????????????????????
        alignLabelWithHint: true,
        hintText: '??????????????????',
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
      controller: _controllerInfo,
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

  // ??????????????????
  void _onLoading() async {
    pageNo++;
    getCommentsInfo(isLoad: true);
  }

  late TrendsDetails trendsInfo = new TrendsDetails();

  void getDtails() {
    trendsDetails(trendsId).then((value) => {
          if (value.isOk())
            {
              trendsInfo = value.data!,
              setState(() {}),
            } else if (value.code == 300)
            {
              showOpenSvipDialog(getApplication()!, cancel: () {
                Get.back();
              }),
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

  /// ??????????????????????????????
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
