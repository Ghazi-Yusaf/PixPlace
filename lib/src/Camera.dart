import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// https://pub.dev/packages/camera
// https://flutter.dev/docs/cookbook/plugins/picture-using-camera

import 'ErrorPage.dart';


// INIT CAMERA CODE
Future<List<CameraDescription>> ensureAndGetCameras() async {
  WidgetsFlutterBinding.ensureInitialized();
  return await availableCameras();
}


FutureBuilder getCamera() {
  return FutureBuilder<List<CameraDescription>>(
    future: ensureAndGetCameras(),
    builder: (BuildContext context,  AsyncSnapshot<List<CameraDescription>> camerasListSnapshot) {
      if (camerasListSnapshot.hasError) {
        String errorMessage = "Error: " + camerasListSnapshot.error.toString();
        return errorPage(errorMessage);
      }
      if (camerasListSnapshot.hasData) {
        List<CameraDescription> cameras = camerasListSnapshot.data;
        return CameraApp(cameras);
      }
      return errorPage("No cameras available");
    },
  );
}








// CAMERA CODE

class CameraApp extends StatefulWidget {
  List<CameraDescription> cameras;

  CameraApp(this.cameras);

  @override
  _CameraAppState createState() => _CameraAppState(this.cameras);
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  List<CameraDescription> cameras;

  _CameraAppState(this.cameras);


  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
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
    if (!controller.value.isInitialized) {
      return errorPage("Controller not initialised");
    }
    // get screen size
    final size = MediaQuery.of(context).size;

    // calculate scale for aspect ratio widget
    var scale = controller.value.aspectRatio * size.aspectRatio;

    // check if adjustments are needed...
    if (controller.value.aspectRatio > size.aspectRatio) {
      scale = 1 / scale;
    }
    return Transform.scale(
        scale: scale,
        child: Center(
          child: CameraPreview(controller)
        ),
    );
  }
}


