import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MyRealTimePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MyRealTimePage({super.key, required this.cameras});

  @override
  State<MyRealTimePage> createState() => _MyRealTimePageState();
}

class _MyRealTimePageState extends State<MyRealTimePage> {
  
    late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Realtime Capturing"),),
      body: Center(
        child: controller.value.isInitialized?CameraPreview(controller):Container(),
      ),
    );
  }
}