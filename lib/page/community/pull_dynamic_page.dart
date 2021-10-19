import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/utils/image_picker_util.dart';
import 'package:untitled/widgets/bottom_pupop.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/my_text_widget.dart';
import 'package:untitled/widgets/toast.dart';
import 'community_tab_bar.dart';
import 'community_tab_bar_view.dart';

//发布动态
class PullDynamicPage extends StatefulWidget {
  const PullDynamicPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PullDynamicPageState();
  }
}

class _PullDynamicPageState extends State<PullDynamicPage> {
  final TextEditingController _textFieldController = TextEditingController();
  final _Controller _controller = Get.put(_Controller());

  List<String> imageUrls = [];
  String? videoUrls;
  bool icCanPull = false;
  int _type = 1; //type=1 picture type=2 video

  @override
  Widget build(BuildContext context) {
    logger.i('CommunityPage');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.5,
            leading: new IconButton(
                icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
                onPressed: () {
                  Navigator.maybePop(context);
                }),
            title: Text("我的动态",
                style: TextStyle(fontSize: 17, color: Colors.black)),
            backgroundColor: Color(0xFFF5F5F5),
            centerTitle: true,
            actions: <Widget>[
              Container(
                width: 62,
                alignment: const Alignment(0, 0),
                // 边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: Color(0xffE2E2E2),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  //设置四周边框
                  border: Border(),
                ),
                margin: const EdgeInsets.fromLTRB(5, 12, 16.0, 12),
                child: GestureDetector(
                  onTap: () {},
                  child: Text("发布",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: icCanPull
                              ? Color(0xFF000000)
                              : Color(0xFF8C8C8C))),
                ),
              ),
            ]),
        backgroundColor: Color(0xFFF5F5F5),
        body: _child(),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _child() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextField(
              onChanged: (text) {
                //输入框内容变化回调
              },
              controller: _textFieldController,
              maxLines: 8,
              minLines: 8,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0),
                ),
                fillColor: Color(0xffF5F5F5),
                filled: true,
                hintStyle: TextStyle(color: Color(0xFF8C8C8C), fontSize: 15),
                hintText: "说出你的心情～",
                contentPadding: EdgeInsets.fromLTRB(12, 5, 10, 5),
              ),
            ),
          ),
          _gridView(),
          SizedBox(
            height: 20,
          ),
          _locationAndTopic(),
          SizedBox(
            height: 20,
          ),
          _action(),
        ],
      ),
    );
  }

  Widget _gridView() {
    return GridView.count(
      shrinkWrap: true,
      //为true可以解决子控件必须设置高度的问题
      physics: NeverScrollableScrollPhysics(),
      //禁用滑动事件
      //GridView内边距
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      crossAxisSpacing: ScreenUtil().setWidth(10),
      //垂直子Widget之间间距
      mainAxisSpacing: ScreenUtil().setWidth(4),
      //一行的Widget数量
      crossAxisCount: 4,
      //子Widget宽高比例
      childAspectRatio: 1,
      children: _listView(),
    );
  }

  List<Widget> _listView() {
    List<Widget> list = [];
    logger.i('_type=$_type $imageUrls \nvideoUrls$videoUrls');
    if (_type == 2) {
      //video
    } else if (_type == 1) {
      //picture
      int length = imageUrls.length;
      for (int i = 0; i < length; i++) {
        list.add(_pictureItem(imageUrls[i]));
      }
    }
    return list;
  }

  Widget _pictureItem(String url) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8, top: 8),
          child: Image.file(
            File(url),
            fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () {
                imageUrls.remove(url);
                setState(() {});
              },
              child: Container(
                child: Icon(Icons.remove_circle, size: 16, color: Colors.red),
              )),
        )
      ],
    );
  }

  Widget _locationAndTopic() {
    return Row(
      children: [
        Obx(() => _controller.location.value.isEmpty
            ? Text('')
            : Container(
                margin: EdgeInsets.only(left: 16),
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                        top: ScreenUtil().setWidth(6),
                        bottom: ScreenUtil().setWidth(6),
                        right: ScreenUtil().setWidth(2)),
                    child: Image(
                        color: MyColor.blackColor,
                        image:
                            const AssetImage("assets/images/ic_location.png"),
                        fit: BoxFit.fill),
                  ),
                  singeLineText(
                    _controller.location.value,
                    50,
                    TextStyle(
                      fontSize: ScreenUtil().setSp(10),
                      color: MyColor.blackColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _controller.location.value = '';
                      logger.i('message delete location');
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.only(right: 8, left: 4),
                      child: Image(
                        color: MyColor.blackColor,
                        image: const AssetImage("assets/images/delete.png"),
                      ),
                    ),
                  ),
                ]))),
        Obx(() => _controller.topicName.value.isEmpty
            ? Text('')
            : Container(
                margin: EdgeInsets.only(left: 16),
                height: ScreenUtil().setHeight(23),
                // 边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: Color(0xffE6E6E6),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  //设置四周边框
                  border: Border(),
                ),
                // 设置 child 居中
                alignment: const Alignment(0, 0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                        top: ScreenUtil().setWidth(6),
                        bottom: ScreenUtil().setWidth(6),
                        right: ScreenUtil().setWidth(4)),
                    child: Image(
                        color: MyColor.blackColor,
                        image:
                            const AssetImage("assets/images/ic_location.png"),
                        fit: BoxFit.fill),
                  ),
                  singeLineText(
                    _controller.topicName.value,
                    80,
                    TextStyle(
                      fontSize: ScreenUtil().setSp(10),
                      color: MyColor.blackColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _controller.topicName.value = '';
                      logger.i('message delete topic');
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.only(right: 8, left: 4),
                      child: Image(
                        color: MyColor.blackColor,
                        image: const AssetImage("assets/images/delete.png"),
                      ),
                    ),
                  ),
                ])))
      ],
    );
  }

  Widget _action() {
    return Row(
      children: [
        _choicePictureWidget(),
        _choiceVideoWidget(),
        _locationWidget(),
        _choiceTopicWidget(),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  Widget _choicePictureWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 16),
      child: GestureDetector(
        onTap: () {
          if (_type == 2 && videoUrls != null) {
            MyToast.show('图片与视频不能一起发布');
            return;
          }
          if (_type == 1 && imageUrls.length == 12) {
            MyToast.show('一次最多只能发布12张图片');
            return;
          }
          showBottomImageSource(context, _choicePicture, _tokePhoto);
        },
        child: Column(
          children: [
            Image.asset(
              'assets/images/ic_picture.png',
              width: 22,
              height: 19,
            ),
            Text(
              '图片',
              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceVideoWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 16),
      child: GestureDetector(
        onTap: () {
          if (_type == 1 && imageUrls.isNotEmpty) {
            MyToast.show('图片与视频不能一起发布');
            return;
          }
          if (_type == 2 && videoUrls != null) {
            MyToast.show('一次最多只能发布1个视频');
            return;
          }
          showBottomImageSource(context, _choiceVideo, _tokeVideo,
              title: '选择视频来源', action1Str: '录视频');
        },
        child: Column(
          children: [
            Image.asset(
              'assets/images/ic_video.png',
              width: 20,
              height: 20,
            ),
            Text(
              '视频',
              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 16),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Image.asset(
              'assets/images/ic_location.png',
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
              width: 18,
              height: 20,
            ),
            Text(
              '定位',
              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceTopicWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 16),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Image.asset(
              'assets/images/topic.png',
              color: Color(0xff8C8C8C),
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
              width: 20,
              height: 20,
            ),
            Text(
              '话题',
              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _choicePicture() async {
    XFile? f = await getImageFromGallery();
    logger.i(f?.path);
    if (f != null) {
      imageUrls.add(f.path);
    }
    _type = 1;
    setState(() {});
  }

  //拍照
  void _tokePhoto() async {
    XFile? f = await getPhoto();
    if (f != null) {
      imageUrls.add(f.path);
    }
    _type = 1;
    setState(() {});
  }

  void _choiceVideo() async {
    XFile? f = await getVideoFromGallery();
    logger.i(f?.path);
    if (f != null) {
      imageUrls.add(f.path);
    }
    _type = 2;

    setState(() {});
  }

  //录视频
  void _tokeVideo() async {
    XFile? f = await getVideo();
    if (f != null) {
      imageUrls.add(f.path);
    }
    _type = 2;
    setState(() {});
  }
}

class _Controller extends GetxController {
  List<String> topics = [];
  RxString topicName = '美女派对话题'.obs;
  RxString location = '成都市'.obs;

  @override
  void onInit() {}
}
