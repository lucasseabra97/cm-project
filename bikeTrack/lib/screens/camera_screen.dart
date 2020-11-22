import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreen createState() => _CameraScreen();
}

class _CameraScreen extends State<CameraScreen> {
  List<CameraDescription> cameras;
  CameraController controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    setupCameras();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }

    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady && !controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
