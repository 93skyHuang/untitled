import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/new_trends_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/divider.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/null_list_widget.dart';

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
                cardNetworkImage(info.headImgUrl ?? '',
                    ScreenUtil().setWidth(44), ScreenUtil().setWidth(44)),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(10),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setWidth(12)),
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
                              _widgetFocusOn(info),
                            ],
                          )),
                          _richText(
                            "${info.content}",
                          ),
                          _itemContentImage(info),
                          // _itemContentImage(info),
                        ],
                      )),
                )
              ],
            )),
        HDivider()
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

  Widget _widgetFocusOn(NewTrendsInfo info) {
    return Container(
      // 边框设置
      decoration: const BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        //设置四周边框
        border: Border(),
      ),
      // 设置 child 居中
      alignment: const Alignment(0, 0),
      child: InkWell(
          onTap: () {},
          child: Row(children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(6),
                  top: ScreenUtil().setWidth(6),
                  bottom: ScreenUtil().setWidth(6),
                  right: ScreenUtil().setWidth(4)),
              child: Image(
                  color: MyColor.redFd4343,
                  width: ScreenUtil().setWidth(12),
                  height: ScreenUtil().setWidth(12),
                  image: const AssetImage("assets/images/add.png"),
                  fit: BoxFit.fill),
            ),
            Text(
              '关注',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                color: MyColor.redFd4343,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: ScreenUtil().setWidth(6))),
          ])),
    );
  }

  Widget _itemContentImage(NewTrendsInfo info) {
    return Container(
      height: ScreenUtil().setWidth(183),
      width: double.infinity,
      child: cardNetworkImage(info.headImgUrl ?? '', ScreenUtil().setWidth(44),
          ScreenUtil().setWidth(44)),
    );
  }

// Widget _itemLable(NewTrendsInfo info){
//
// }

// 当前是否已是 "全文" 状态
  bool mIsExpansion = false;

  //最大显示行数（默认 3 行）
  int mMaxLine = 3;

//_text：显示的文字
  Widget _richText(String _text) {
    if (_isExpansion(_text)) {
//      //如果需要截断
      if (mIsExpansion) {
        return Column(
          children: <Widget>[
            Text(
              _text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: MyColor.grey8C8C8C,
              ),
              textAlign: TextAlign.left,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                  visualDensity: VisualDensity.compact,
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  _isShowText();
                },
                child: Text("收起",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      color: MyColor.blackColor,
                    )),
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: <Widget>[
            Text(
              _text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: MyColor.grey8C8C8C,
              ),
              maxLines: mMaxLine,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                  visualDensity: VisualDensity.compact,
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  _isShowText();
                },
                child: Text("全文",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      color: MyColor.blackColor,
                    )),
              ),
            ),
          ],
        );
      }
    } else {
      return Text(
        _text,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(14),
          color: MyColor.grey8C8C8C,
        ),
        maxLines: mMaxLine,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  bool _isExpansion(String text) {
    TextPainter _textPainter = TextPainter(
        maxLines: mMaxLine,
        text: TextSpan(
            text: text,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(14), color: Colors.black)),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: _textContextWidth);
    if (_textPainter.didExceedMaxLines) {
      //这里判断 文本是否截断
      return true;
    } else {
      return false;
    }
  }

  void _isShowText() {
    if (mIsExpansion) {
      //关闭了
      setState(() {
        mIsExpansion = false;
      });
    } else {
      setState(() {
        mIsExpansion = true;
      });
    }
  }
}
