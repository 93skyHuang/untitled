import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/comment_info.dart';
import 'package:untitled/network/bean/new_trends_info.dart';
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

class CommentPage extends StatefulWidget {
  NewTrendsInfo info;

  CommentPage(this.info);

  @override
  State<CommentPage> createState() => _CommentPageState(this.info);
}

class _CommentPageState extends State<CommentPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  NewTrendsInfo info;

  _CommentPageState(this.info);

  double contextWidth =
      ScreenUtil().screenWidth - ScreenUtil().setWidth(50 + 32 + 16);

  @override
  void initState() {
    super.initState();
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
              Text("??????", style: TextStyle(fontSize: 17, color: Colors.black)),
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
                                  info.headImgUrl ?? '',
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
                                      _itemName(info),
                                      const Flexible(child: Align()),
                                      FocusOnBtn(info),
                                    ],
                                  )),
                                  if (info.content != null)
                                    CustomText(
                                      text: "${info.content ?? ''}",
                                      margin: EdgeInsets.only(top: 5),
                                      textStyle: TextStyle(
                                          color: MyColor.grey8C8C8C,
                                          fontSize: ScreenUtil().setSp(14)),
                                    ),
                                  if (info.imgArr.isNotEmpty)
                                    TrendImg(
                                      imgs: info.imgArr,
                                      showAll: true,
                                      contextWidth: contextWidth,
                                      onClick: (int index) {
                                        Get.toNamed(photoViewPName, arguments: {
                                          'index': index,
                                          'photoList': info.imgArr
                                        });
                                      },
                                    ),
                                  _itemLable(info),
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
    addComment(info.trendsId, _controllerInfo.text).then((value) => {
          Loading.dismiss(context),
          if (value.isOk())
            {
              _controllerInfo.text = '',
              MyToast.show('?????????'),
              _onRefresh(),
              FocusScope.of(context).requestFocus(FocusNode()),
            }
          else if (value.code == 300)
            {
              showOpenSvipDialog(context, cancel: () {
                Get.back();
              }),
            }
          else
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

  int pageNo = 1;
  List<CommentInfo> comments = [];

  void getCommentsInfo({bool isLoad = false}) {
    getTrendsCommentList(pageNo, info.trendsId).then((value) => {
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
          else if (value.code == 300)
            {
              showOpenSvipDialog(context, cancel: () {
                Get.back();
              }),
            }
          else
            {
              MyToast.show(value.msg),
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
          else if (value.code == 300)
            {
              showOpenSvipDialog(context, cancel: () {
                Get.back();
              }),
            }
        });
  }

  Widget _itemName(NewTrendsInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${info.cname}',
          style: TextStyle(
              color: MyColor.blackColor, fontSize: ScreenUtil().setSp(14)),
        ),
        Text(
          '${info.time}',
          style: TextStyle(
              color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(12)),
        ),
      ],
    );
  }

  //??????
  Widget _itemLable(NewTrendsInfo info) {
    List<Widget> list = [];
    if (info.region != null) {
      list.add(Container(
          height: ScreenUtil().setHeight(23),
          // ????????????
          decoration: const BoxDecoration(
            //??????
            color: Color(0x1A5DB1DE),
            //?????????????????? ??????
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            //??????????????????
            border: Border(),
          ),
          // ?????? child ??????
          alignment: const Alignment(0, 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(6),
                  top: ScreenUtil().setWidth(6),
                  bottom: ScreenUtil().setWidth(6),
                  right: ScreenUtil().setWidth(4)),
              child: Image(
                  color: MyColor.blackColor,
                  image: const AssetImage("assets/images/ic_location.png"),
                  fit: BoxFit.fill),
            ),
            Text(
              '${info.region}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                color: MyColor.blackColor,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: ScreenUtil().setWidth(6))),
          ])));
      if (info.topicName != null) {
        list.add(
          Padding(padding: EdgeInsets.only(right: ScreenUtil().setWidth(10))),
        );
        list.add(radiusContainer(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(6),
                  top: ScreenUtil().setWidth(6),
                  bottom: ScreenUtil().setWidth(6),
                  right: ScreenUtil().setWidth(4)),
              child: Image(
                  color: MyColor.blackColor,
                  image: const AssetImage("assets/images/topic.png"),
                  fit: BoxFit.fill),
            ),
            Text(
              '${info.topicName}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                color: MyColor.blackColor,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: ScreenUtil().setWidth(6))),
          ]),
          c: Color(0xffE6E6E6),
          radius: 12,
          height: ScreenUtil().setHeight(23),
        ));
      }
    }
    return Container(
        child: Row(
      children: list,
    ));
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
