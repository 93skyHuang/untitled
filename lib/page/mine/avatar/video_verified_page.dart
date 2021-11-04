import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widgets/toast.dart';

List<CameraDescription> cameras = [];

class VideoVerifiedPage extends StatefulWidget {
  @override
  _VideoVerifiedPageState createState() => _VideoVerifiedPageState();
}

class _VideoVerifiedPageState extends State<VideoVerifiedPage> {
  CameraController? controller;
  bool isRecodeVideo = false;
  final Controller _controller = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    cameraInit();
  }

  void cameraInit() async {
    logger.i(cameras.length);
    cameras = cameras.isEmpty ? await availableCameras() : cameras;
    CameraDescription cameraDescription = cameras[0];
    for (int i = 0; i < cameras.length; i++) {
      cameraDescription = cameras[i];
      if (cameraDescription.lensDirection == CameraLensDirection.front) {
        break;
      }
    }
    controller = CameraController(cameraDescription, ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return RadialGradient(
                center: Alignment.center,
                radius: .7,
                colors: <Color>[
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black,
                  Colors.black
                ],
                stops: [0, .5, .5, .1],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child:
                controller == null ? Container() : CameraPreview(controller!),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              CustomText(
                  text: "把脸移入圈内",
                  textAlign: Alignment.center,
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  textStyle: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              CustomText(
                  text: "拍摄真实信息，获取“真人”标签",
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20), bottom: ScreenUtil().setHeight(20)),
                  textAlign: Alignment.center,
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  )),
              GestureDetector(
                  onTap: () {
                    startVideoRecording();
                  },
                  child: Container(
                      height:  ScreenUtil().setHeight(40),
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(214) ,
                      decoration: new BoxDecoration(
                        color: Color(0xffF3CD8E),
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      ),
                      child: Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _controller.btnStatus == 1
                                    ? "录制中"
                                    : _controller.btnStatus == 2
                                        ? "上传认证"
                                        : _controller.btnStatus == 3
                                            ? "上传中"
                                            : "立即认证",
                                style: TextStyle(
                                  fontSize: 17,
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 5),
                              _controller.btnStatus == 1 ||
                                      _controller.btnStatus == 3
                                  ? Container(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container()
                            ],
                          )))),
              TextButton(
                onPressed: () {
                  controller?.dispose();
                  Get.until((route) => Get.currentRoute == homePName);
                },
                child: CustomText(
                    textAlign: Alignment.center,
                    text: "取消认证",
                    padding: EdgeInsets.only(top:ScreenUtil().setHeight(10)),
                    textStyle:
                        TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(30),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void startVideoRecording() async {
    if (!isRecodeVideo) {
      try {
        isRecodeVideo = true;
        path = null;
        await controller?.startVideoRecording();
        _controller.btnStatus.value = 1;
        Future.delayed(Duration(seconds: 3)).then((value) => {
              if (_controller.btnStatus.value == 1)
                {_controller.btnStatus.value = 2}
            });
        Future.delayed(Duration(seconds: 10)).then((value) => {
              if (_controller.btnStatus.value == 2 && isRecodeVideo)
                {
                  MyToast.show('已到录制最长时间'),
                  //停止录制
                  stopVideoRecording()
                }
            });
      } on CameraException catch (e) {
        logger.e(e);
        error();
      }
    } else if ( _controller.btnStatus.value == 2) {
      if(isRecodeVideo){
        //主动停止录制
       await stopVideoRecording();
      }
      if (path != null) {
        _controller.btnStatus.value = 3;
        _controller.uploadVideo(path!);
      } else {
        error();
      }
    }
  }

  String? path;

  Future stopVideoRecording() async {
    try {
      final file = await controller?.stopVideoRecording();
      isRecodeVideo = false;
      logger.i(file?.path);
      path = file?.path;
      if (path == null) {
        error();
      }
    } on CameraException catch (e) {
      error();
      logger.e(e);
    }
  }

  void error() {
    isRecodeVideo = false;
    _controller.btnStatus.value = 0;
    MyToast.show('录制失败');
  }
}

class Controller extends GetxController {
  RxInt btnStatus = 0.obs; //0 立即认证 1 录制中... 2 上传认证 3 上传中

  void uploadVideo(String path) async {
    final r = await fileUpload(path);
    if (r.isOk()) {
      final r2 = await addCertification(1, files: [r.data ?? ""]);
      btnStatus.value = 0;
      if (r2.isOk()) {
        MyToast.show(r2.msg);
        Get.until((route) => Get.currentRoute == homePName);
      } else {
        MyToast.show(r2.msg);
      }
    } else {
      btnStatus.value = 0;
      MyToast.show(r.msg);
    }
  }

  @override
  void onInit() {
    super.onInit();
    logger.i("Controller");
  }

  @override
  void onClose() {
    logger.i("onClose");
  }

  @override
  void onReady() {
    logger.i("onReady");
  }
}
