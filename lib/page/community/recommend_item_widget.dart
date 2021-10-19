import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/new_trends_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/login/add_basic_info.dart';
import 'package:untitled/page/login/login_page.dart';
import 'package:untitled/page/mine/info/edit_user_info.dart';
import 'package:untitled/widget/custom_text.dart';

import '../../route_config.dart';

class FocusOnBtn extends StatefulWidget {
  NewTrendsInfo info;

  FocusOnBtn(this.info, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FocusOnBtnState();
  }
}

class _FocusOnBtnState extends State<FocusOnBtn> {
  @override
  Widget build(BuildContext context) {
    logger.i("FocusOnBtn${widget.info.isFollow} ${widget.info.cname}");
    if (widget.info.isFollow == 1) {
      return Container(
        width: ScreenUtil().setWidth(60),
        height: ScreenUtil().setWidth(30),
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
            onTap: () {
              showBottomOpen(context);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '已关注',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(12),
                  color: MyColor.redFd4343,
                ),
              ),
            ])),
      );
    } else {
      //关注按钮
      return Container(
        width: ScreenUtil().setWidth(60),
        height: ScreenUtil().setWidth(30),
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
            onTap: () {
              add();
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              Padding(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(6))),
            ])),
      );
    }
  }

  void add() {
    addFollow(widget.info.uid).then((value) => {
          if (value.isOk())
            {
              setState(() {
                widget.info.isFollow = 1;
              })
            }
        });
  }

  void del() {
    delFollow(widget.info.uid).then((value) => {
          if (value.isOk())
            {
              setState(() {
                widget.info.isFollow = 0;
              })
            }
        });
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
                        padding: EdgeInsets.only(bottom: 20.0, top: 16),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        child: Column(children: <Widget>[
                          CustomText(
                              text: "操作",
                              textAlign: Alignment.center,
                              padding: EdgeInsets.only(bottom: 16),
                              textStyle:
                                  TextStyle(fontSize: 17, color: Colors.black)),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                del();
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "取消关注",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Colors.black))),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "取消",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Color(0xffFD4343)))),
                        ]))
                  ]));
        });
  }
}

class LikeAndCommentWidget extends StatefulWidget {
  NewTrendsInfo info;

  LikeAndCommentWidget(this.info, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LikeAndCommentWidgetState();
  }
}

class _LikeAndCommentWidgetState extends State<LikeAndCommentWidget> {
  bool isFabulous = false;
  int focusNum = 0;
  int commentNum = 0;

  @override
  void initState() {
    super.initState();
    isFabulous = widget.info.isTrendsFabulous == 1;
    focusNum = widget.info.fabulousSum ?? 0;
    commentNum = widget.info.commentSum ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    logger.i("FocusOnBtn${widget.info.isFollow} ${widget.info.cname}");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              //点赞
              onPressed: () {
                _focusClick();
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                visualDensity: VisualDensity.compact,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Image(
                  color: isFabulous ? MyColor.redFd4343 : MyColor.grey8C8C8C,
                  width: ScreenUtil().setWidth(21),
                  height: ScreenUtil().setWidth(18),
                  image: AssetImage(isFabulous
                      ? "assets/images/like_checked.png"
                      : "assets/images/mine_like.png"),
                  fit: BoxFit.fill)),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              '${widget.info.fabulousSum == 0 ? '' : widget.info.fabulousSum}',
              style: TextStyle(
                  color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(12)),
            ),
          ),
          TextButton(
              //评论
              onPressed: () {
                Get.to(AddBasicInfoPage());
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                visualDensity: VisualDensity.compact,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Image(
                  width: ScreenUtil().setWidth(21),
                  height: ScreenUtil().setWidth(18),
                  image: const AssetImage("assets/images/icon_comment.png"),
                  fit: BoxFit.fill)),
          Text(
            '${widget.info.commentSum == 0 ? '' : widget.info.commentSum}',
            style: TextStyle(
                color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(12)),
          ),
        ],
      ),
    );
  }

  void _focusClick() {
    if (isFabulous) {
      deleteTrendsFabulous(widget.info.trendsId).then((value) => {
            if (value.isOk())
              {
                isFabulous = false,
                focusNum--,
                _updatePage(),
              }
          });
    } else {
      addTrendsFabulous(widget.info.trendsId).then((value) => {
            if (value.isOk())
              {
                isFabulous = true,
                focusNum++,
                _updatePage(),
              }
          });
    }
  }

  void _updatePage() {
    logger.i('updatePage');
    setState(() {});
  }
}
