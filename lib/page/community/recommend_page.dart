import 'dart:io';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/new_trends_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/widget/expandable_text.dart';
import 'package:untitled/widget/trend_img.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/null_list_widget.dart';

import 'recommend_item_widget.dart';

///推荐页面
class RecommendWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecommendWidgetState();
  }
}

class _RecommendWidgetState extends State<RecommendWidget>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final double _textContextWidth =
      ScreenUtil().screenWidth - ScreenUtil().setWidth(50 + 32 + 16);

  @override
  void initState() {
    logger.i('initState');
    _onRefresh();
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
        child: _getListView(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  int pageNo = 1;
  List<NewTrendsInfo> _trendsList = [];

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
    getNewTrends(pageNo).then((value) => {
          logger.i(value),
          if (value.isOk())
            if (isLoad)
              if (value.data == null)
                {
                  _refreshController.loadNoData(),
                }
              else
                {
                  _refreshController.loadComplete(),
                  _trendsList.addAll(value.data ?? []),
                  updatePage(),
                }
            else
              {
                _refreshController.refreshCompleted(),
                _trendsList = value.data ?? [],
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
    int length = _trendsList.length;
    if (length == 0) {
      return NullListWidget();
    } else {
      List<Widget> listView = [];
      for (int i = 0; i < length; i++) {
        listView.add(_itemView(_trendsList[i]));
      }
      return ListView(
        children: listView,
      );
    }
  }

  Widget _itemView(NewTrendsInfo info) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(
              ScreenUtil().setWidth(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(UserHomePage(uid: info.uid));
                  },
                  child: cardNetworkImage(info.headImgUrl ?? '',
                      ScreenUtil().setWidth(44), ScreenUtil().setWidth(44)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(10),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setWidth(0)),
                  child: Container(
                      constraints: BoxConstraints(
                        maxWidth: _textContextWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _itemName(info),
                              const Flexible(child: Align()),
                              FocusOnBtn(info),
                            ],
                          )),
                          const SizedBox(
                            height: 12,
                          ),
                          TQExpandableText(
                            "${info.content}",
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            bottom: ScreenUtil().setWidth(10),
                          )),
                          TrendImg(
                            imgs: info.imgArr,
                            contextWidth: _textContextWidth,
                            onClick: (img) {},
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(14),
                              bottom: ScreenUtil().setWidth(14),
                            ),
                            child: _itemLable(info),
                          ),
                          _comment(info),
                          LikeAndCommentWidget(info),
                        ],
                      )),
                )
              ],
            )),
        HDivider()
      ],
    );
  }

  Widget _comment(NewTrendsInfo info) {
    return info.commentList.isEmpty
        ? Container(
            width: 0,
            height: 0,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '精选评论',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(12),
                  color: MyColor.grey8C8C8C,
                ),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setWidth(10),
                ),
                child: _getComment(info),
              )
            ],
          );
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

  Widget _itemContentImage(NewTrendsInfo info) {
    var imgArr = info.imgArr;
    Widget widget = const Text('');
    if (imgArr.isNotEmpty) {
      int length = imgArr.length;
      if (length == 1) {
        widget = normalNetWorkImage(info.headImgUrl ?? '');
      } else if (length == 2) {}
    }
    return widget;
  }

  //标签
  Widget _itemLable(NewTrendsInfo info) {
    List<Widget> list = [];
    if (info.region != null) {
      list.add(Container(
          height: ScreenUtil().setHeight(23),
          // 边框设置
          decoration: const BoxDecoration(
            //背景
            color: Color(0x1A5DB1DE),
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            //设置四周边框
            border: Border(),
          ),
          // 设置 child 居中
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
        width: _textContextWidth,
        child: Row(
          children: list,
        ));
  }

  Widget _getComment(NewTrendsInfo info) {
    List<Widget> list = [];
    int commentLength = info.commentList.length;
    if (commentLength > 0) {
      if (commentLength == 1) {
        CommentBean? commentBean = info.commentList[0];
        list.add(_getSingleComment(
            '${commentBean?.cname}', '${commentBean?.content}'));
      } else {
        CommentBean? commentBean = info.commentList[0];
        list.add(_getSingleComment(
            '${commentBean?.cname}', '${commentBean?.content}'));
        list.add(Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(5),
          ),
        ));
        CommentBean? commentBean1 = info.commentList[1];
        list.add(_getSingleComment(
            '${commentBean1?.cname}', '${commentBean1?.content}'));
      }
    }
    return Column(
      children: list,
    );
  }

  Widget _getSingleComment(String user, String content) {
    return SizedBox(
        width: _textContextWidth,
        child: Row(
          children: [
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: _textContextWidth / 3),
                child: Text(
                  user,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: MyColor.blackColor,
                      fontSize: ScreenUtil().setSp(12)),
                )),
            Text(
              ':\t',
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColor.blackColor, fontSize: ScreenUtil().setSp(12)),
            ),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: _textContextWidth * 2 / 3 - 15),
              child: Text(
                content,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: MyColor.grey8C8C8C,
                    fontSize: ScreenUtil().setSp(12)),
              ),
            )
          ],
        ));
  }
}
