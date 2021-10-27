import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/widget/custom_text.dart';

List<CameraDescription> cameras = [];

class VideoVerifiedPage extends StatefulWidget {
  @override
  _VideoVerifiedPageState createState() => _VideoVerifiedPageState();
}

class _VideoVerifiedPageState extends State<VideoVerifiedPage> {
  CameraController? controller;

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
          controller == null ? Container() : CameraPreview(controller!),
          Container(
            height: 130,
            color: Color(0xffffffff),
          ),
          Container(
            height: 130,
            color: Color(0x80000000),
          ),
          ShaderMask(
            blendMode: BlendMode.srcOut,
            shaderCallback: (bounds) {
              return RadialGradient(
                colors: [Colors.transparent, MyColor.mainColor],
              ).createShader(bounds);
            },
            child: Align(child: Image(
              color: MyColor.mainColor,
              image: AssetImage("assets/images/icon_circle.png"),
              alignment: Alignment.center,
            ),)),
          // Container(
          //     margin: EdgeInsets.only(top: 100),
          //     height: double.infinity,
          //     decoration: BoxDecoration(
          //       color: Color(0xff000000),
          //       border: Border(),
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(30.0),
          //           topRight: Radius.circular(30.0)),
          //     )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              CustomText(
                  text: "把脸移入圈内",
                  textAlign: Alignment.center,
                  margin: EdgeInsets.only(top: 30),
                  textStyle: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              CustomText(
                  text: "拍摄真实信息，获取“真人”标签",
                  margin: EdgeInsets.only(top: 20, bottom: 50),
                  textAlign: Alignment.center,
                  textStyle: TextStyle(fontSize: 15, color: Colors.white)),
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  width: 214,
                  decoration: new BoxDecoration(
                    color: Color(0xffF3CD8E),
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  child: Text(
                    "立即认证",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  )),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: CustomText(
                    textAlign: Alignment.center,
                    text: "取消认证",
                    padding: EdgeInsets.only(top: 20),
                    textStyle:
                        TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              ),
              SizedBox(
                height: 50,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void startVideoRecording() async {
    try {
      showCamera(context);
      controller?.startVideoRecording();
    } on CameraException catch (e) {
      logger.e(e);
    }
  }

  void stopVideoRecording() async {
    try {
      final file = await controller?.stopVideoRecording();
      logger.i(file?.path);
    } on CameraException catch (e) {
      logger.e(e);
    }
  }

  void showCamera(BuildContext context) {
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
                        padding: EdgeInsets.only(
                            bottom: 20.0, left: 40, right: 40, top: 101),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        child: Column(children: <Widget>[
                          Image(
                            image: AssetImage("assets/images/icon_circle.png"),
                          ),
                          CustomText(
                              text: "把脸移入圈内",
                              textAlign: Alignment.center,
                              margin: EdgeInsets.only(top: 30),
                              textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          CustomText(
                              text: "拍摄真实信息，获取“真人”标签",
                              margin: EdgeInsets.only(top: 20, bottom: 50),
                              textAlign: Alignment.center,
                              textStyle:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          Container(
                              height: 40,
                              alignment: Alignment.center,
                              width: 214,
                              decoration: new BoxDecoration(
                                color: Color(0xffF3CD8E),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: Text(
                                "立即认证",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              )),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                                textAlign: Alignment.center,
                                text: "取消认证",
                                padding: EdgeInsets.only(top: 20),
                                textStyle: TextStyle(
                                    fontSize: 12, color: Color(0xff8C8C8C))),
                          ),
                        ]))
                  ]));
        });
  }
}
