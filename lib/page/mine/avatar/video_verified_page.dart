import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';

List<CameraDescription> cameras = [];

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    cameraInit();
  }

  void cameraInit() async {
    cameras = cameras.isEmpty ? await availableCameras() : cameras;
    controller = CameraController(cameras[0], ResolutionPreset.max);
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
    if (controller == null) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller!),
    );
  }

  void startVideoRecording() async {
    try {
      controller?.startVideoRecording();
    } on CameraException catch (e) {
      logger.e(e);
    }
  }

  void stopVideoRecording() async {
    try {
      final file = controller?.stopVideoRecording();
    } on CameraException catch (e) {
      logger.e(e);
    }
  }
}
