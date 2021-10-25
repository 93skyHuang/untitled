import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/video_trends_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/chat/chat_page.dart';
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
  late VideoTrendsInfo info;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    final details = Get.arguments as Map;
    info = details['videoTrendsInfo'];
    _controller.setInfo(info);
    _videoController = VideoPlayerController.network(info.video ?? '')
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
                        child: Container(
                          width: 40,
                          height: 40,
                          child: CachedNetworkImage(
                            fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
                            imageUrl: info.headImgUrl ?? '',
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/user_icon.png',
                              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      singeLineText('${info.cname}', 80,
                          TextStyle(color: Color(0xffffffff), fontSize: 14),
                          textAlign: TextAlign.right),
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
                          onTap: () {},
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
                      child: Text('${info.content}',
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xffffffff), fontSize: 17)),
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
  late VideoTrendsInfo info;

  void setInfo(VideoTrendsInfo info) {
    this.info = info;
    isLike.value = info.isTrendsFabulous == 1;
    likeNum.value = info.fabulousSum ?? 0;
  }

  void clickLike() {
    if (!isLike.value) {
      likeNum++;
      isLike.value = true;
      addTrendsFabulous(info.trendsId ?? 0).then((value) => {
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
      deleteTrendsFabulous(info.trendsId ?? 0).then((value) => {
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
    final u = GetStorageUtils.getUserBasic(info.uid);
    if (u == null) {
      final value = await getHomeUserData(info.uid);
      if (value.isOk()) {
        GetStorageUtils.saveUserBasic(info.uid, value.data!);
        Get.to(ChatPage(), arguments: value.data);
      }
    } else {
      Get.to(ChatPage(), arguments: u);
    }
  }
}
