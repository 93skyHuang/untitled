import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/new_trends_info.dart';
import 'package:untitled/network/http_manager.dart';
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
  @override
  Widget build(BuildContext context) {
    logger.i("FocusOnBtn${widget.info.isFollow} ${widget.info.cname}");
    bool isFabulous = widget.info.isTrendsFabulous == 1;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {},
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
              '128',
              style: TextStyle(
                  color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(12)),
            ),
          ),
          TextButton(
              onPressed: () {
                Get.toNamed(photoViewScalePName, arguments: {
                  'url': 'http://sancunkongjian.oss-cn-beijing.aliyuncs.com/TIS/20200418/2020041821385320771.jpg',
                });
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
            '67',
            style: TextStyle(
                color: MyColor.grey8C8C8C, fontSize: ScreenUtil().setSp(12)),
          ),
        ],
      ),
    );
  }
}
