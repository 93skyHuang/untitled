import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/trends_details.dart';
import 'package:untitled/network/bean/video_trends_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/chat/chat_page.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/page/report/report_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/my_text_widget.dart';
import 'package:untitled/widgets/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

///动态视频播放页面
class TrendVideoPlayPage extends StatefulWidget {
  const TrendVideoPlayPage({Key? key}) : super(key: key);

  @override
  _TrendVideoPlayPageState createState() => _TrendVideoPlayPageState();
}

class _TrendVideoPlayPageState extends State<TrendVideoPlayPage> {
  late VideoPlayerController _videoController;
  final _Controller _controller = Get.put(_Controller());
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    final details = Get.arguments as Map;
    String videoUrl = details['videoUrl'];
    int  trendsId = details['trendsId'];
    logger.i("trendsId=$trendsId videoUrl=$videoUrl");
    _controller.setTrendsId(trendsId);
    _videoController = VideoPlayerController.network(videoUrl)
      ..initialize().then((value) => {
            // setState(() {}),
            logger.i('VideoPlayerController initialize'), initPlay(),
          });
  }

  void initPlay() async {
    await _videoController.play();
    logger.i('initPlay ');
    isPlaying = true;
    setState(() {});
    _videoController.addListener(playerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 60),
                  child: IconButton(
                      icon: Icon(Icons.close, size: 20, color: Colors.white),
                      onPressed: () {
                        Get.back();
                      }),
                ),
              ),
              GestureDetector(
                  onDoubleTap: () {
                    logger.i('onDoubleTap $isPlaying');
                    if (isPlaying) {
                      pause();
                    }
                  },
                  child: Center(
                    child: _videoController.value.isPlaying
                        ? Container()
                        : _videoController.value.isInitialized
                            ? IconButton(
                                icon: Icon(Icons.play_circle_fill,
                                    size: 50, color: Colors.white),
                                onPressed: () {
                                  if (!isPlaying) {
                                    play();
                                  }
                                })
                            : Container(),
                  )),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: GestureDetector(
                          onTap: () {
                            logger.i('他人主页');
                            pause();
                            Get.to(UserHomePage(
                              uid: _controller.info.uid,
                              initialIndex: 2,
                            ));
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Obx(() => CachedNetworkImage(
                                  fit: Platform.isIOS
                                      ? BoxFit.cover
                                      : BoxFit.fill,
                                  imageUrl: _controller.headerUrl.value,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/user_icon.png',
                                    fit: Platform.isIOS
                                        ? BoxFit.cover
                                        : BoxFit.fill,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(() => singeLineText(_controller.cName.value, 80,
                          TextStyle(color: Color(0xffffffff), fontSize: 14),
                          textAlign: TextAlign.right)),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          logger.i('私聊');
                          pause();
                          _controller.goToChatPage();
                        },
                        child: Image.asset('assets/images/private_chat.png'),
                      ),
                      SizedBox(height: 10),
                      Text('私聊',
                          style: TextStyle(
                              color: Color(0xffffffff), fontSize: 14)),
                      SizedBox(height: 30),
                      TextButton(
                          //点赞
                          onPressed: () {
                            _controller.clickLike();
                          },
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(0, 0)),
                            visualDensity: VisualDensity.compact,
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          child: Obx(() => Image(
                              color: _controller.isLike.value
                                  ? MyColor.redFd4343
                                  : MyColor.whiteFFFFFF,
                              width: 35,
                              height: 30,
                              image: AssetImage(_controller.isLike.value
                                  ? "assets/images/video_like.png"
                                  : "assets/images/video_not_like.png"),
                              fit: BoxFit.fill))),
                      Obx(() => singeLineText(
                          '${_controller.likeNum.value}',
                          50,
                          TextStyle(color: Color(0xffffffff), fontSize: 14))),
                      SizedBox(height: 40),
                      GestureDetector(
                          onTap: () {
                            pause();
                            Get.to(ReportPage(_controller.info.uid));
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/images/report.png'),
                              SizedBox(height: 10),
                              Text('举报',
                                  style: TextStyle(
                                      color: Color(0xffffffff), fontSize: 14)),
                            ],
                          )),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 80),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: ScreenUtil().screenWidth / 2),
                      child: Obx(() => Text(_controller.content.value,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xffffffff), fontSize: 17))),
                    )),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.removeListener(playerListener);
    _videoController.dispose();
  }

  void pause() async {
    isPlaying = false;
    if (_videoController.value.isPlaying) {
      await _videoController.pause();
      setState(() {});
    }
  }

  void play() async {
    await _videoController.play();
    isPlaying = true;
    setState(() {});
  }

  void playerListener() {
    logger.i('${_videoController.value.isPlaying} isPlaying$isPlaying');
    //状态改变
    if (isPlaying != _videoController.value.isPlaying) {
      isPlaying = _videoController.value.isPlaying;
      setState(() {});
    }
  }
}

class _Controller extends GetxController {
  RxBool isLike = false.obs;
  RxInt likeNum = 0.obs;
  RxString headerUrl = "".obs;
  RxString cName = "".obs;
  RxString content = "".obs;
  late TrendsDetails info;
  int id = -1;

  void setTrendsId(int id) {
    this.id = id;
    trendsDetails(id).then((value) => {
          if (value.isOk())
            {setInfo(value.data!)}
          else
            {MyToast.show(value.msg)}
        });
  }

  void setInfo(TrendsDetails info) {
    this.info = info;
    isLike.value = info.isTrendsFabulous == 1;
    likeNum.value = info.fabulousSum ?? 0;
    headerUrl.value = info.headImgUrl ?? "";
    cName.value = info.cname ?? "";
    content.value = info.content ?? "";
  }

  void clickLike() {
    if (!isLike.value) {
      likeNum++;
      isLike.value = true;
      addTrendsFabulous(info.id).then((value) => {
            if (value.isOk())
              {
                info.isTrendsFabulous = 1,
                info.fabulousSum = likeNum.value,
              }
            else
              {
                MyToast.show(value.msg),
                likeNum--,
                isLike.value = false,
              }
          });
    } else {
      likeNum--;
      isLike.value = false;
      deleteTrendsFabulous(info.id).then((value) => {
            if (value.isOk())
              {
                info.isTrendsFabulous = 0,
                info.fabulousSum = likeNum.value,
              }
            else
              {
                MyToast.show(value.msg),
                likeNum++,
                isLike.value = true,
              }
          });
    }
  }

  void goToChatPage() async {
    Get.to(ChatPage(), arguments: {'uid': info.uid});
  }
}
