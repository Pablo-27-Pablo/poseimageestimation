import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:poseimageestimation/main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController controller;
  bool isBusy = false;
  CameraImage? img;
  dynamic poseDetector;
  late Size size;
  dynamic _scanResults;
  int selectedCameraIndex = 1;
  bool fixingcamera = true;
  int raise = 0;

  final Map<DeviceOrientation, int> _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    poseDetector = PoseDetector(
        options: PoseDetectorOptions(mode: PoseDetectionMode.stream));

    controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
    );
    await controller.initialize().then((_) {
      if (!mounted) return;
      controller.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          img = image;
          doPoseEstimationOnFrame();
        }
      });
    });
  }

  void toggleCamera() async {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await controller.dispose();
    fronfixposition();
    initializeCamera();
  }

  Uint8List convertYUV420ToNV21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final Uint8List yPlane = image.planes[0].bytes;
    final Uint8List uPlane = image.planes[1].bytes;
    final Uint8List vPlane = image.planes[2].bytes;

    final int uvLength = uPlane.length;
    final Uint8List uvInterleaved = Uint8List(uvLength * 2);
    for (int i = 0; i < uvLength; i++) {
      uvInterleaved[i * 2] = vPlane[i];
      uvInterleaved[i * 2 + 1] = uPlane[i];
    }

    final Uint8List nv21 = Uint8List(yPlane.length + uvInterleaved.length);
    nv21.setRange(0, yPlane.length, yPlane);
    nv21.setRange(yPlane.length, nv21.length, uvInterleaved);

    return nv21;
  }

  InputImage? getInputImage() {
    if (img == null || img?.format.group != ImageFormatGroup.yuv420)
      return null;

    final nv21Bytes = convertYUV420ToNV21(img!);
    final camera = cameras[selectedCameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    return InputImage.fromBytes(
      bytes: nv21Bytes,
      metadata: InputImageMetadata(
        size: Size(img!.width.toDouble(), img!.height.toDouble()),
        rotation: rotation ??
            InputImageRotation.rotation0deg, // Provide a default value
        format: InputImageFormat.nv21,
        bytesPerRow: img!.planes[0].bytesPerRow,
      ),
    );
  }

  Future<void> doPoseEstimationOnFrame() async {
    final inputImage = getInputImage();
    if (inputImage == null) return;

    final List<Pose> poses = await poseDetector.processImage(inputImage);
    _scanResults = poses;
    for (Pose pose in poses) {
////////////////////////////////////
      PoseLandmark leftShoulder =
          pose.landmarks[PoseLandmarkType.leftShoulder]!;
      PoseLandmark rightShoulder =
          pose.landmarks[PoseLandmarkType.rightShoulder]!;
      PoseLandmark leftWrist = pose.landmarks[PoseLandmarkType.leftWrist]!;
      PoseLandmark rightWrist = pose.landmarks[PoseLandmarkType.rightWrist]!;
      PoseLandmark head = pose.landmarks[PoseLandmarkType.rightEye]!;

      if (leftWrist.y < head.y || leftWrist.x < head.x) {
        setState(() {
          raise = raise + 1;
        });
        print("hatdog");
        print("hatdog");
        print("hatdog");

        print("hatdog");
        print("hatdog");

        print("hatdog");

        print("hatdog");
      }
///////////////////////////////
      pose.landmarks.forEach((_, landmark) {
        final x = landmark.x;
        final y = landmark.y;
        final type = landmark.type;
      });
    }

    setState(() {
      _scanResults;
      isBusy = false;
    });
  }

  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return Text('');
    }

    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter painter = PosePainter(imageSize, _scanResults);
    return CustomPaint(
      painter: painter,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    poseDetector.close();
    super.dispose();
  }

  void fronfixposition() {
    if (selectedCameraIndex == 0) {
      fixingcamera = false;
    } else if (selectedCameraIndex == 1) {
      fixingcamera = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Container(),
          ),
        ),
      );

      fixingcamera
          ? stackChildren.add(
              Positioned(
                top: 0.0,
                left: 0.0,
                width: size.width,
                height: size.height,
                child: Transform(
                  alignment: Alignment
                      .center, // Ensure the flip happens around the center
                  transform: Matrix4.identity()
                    ..scale(-1.0, 1.0), // Horizontal flip
                  child: buildResult(),
                ),
              ),
            )
          : stackChildren.add(
              Positioned(
                  top: 0.0,
                  left: 0.0,
                  width: size.width,
                  height: size.height,
                  child: buildResult()),
            );

      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: Container(
              child: Column(
                children: [Text(raise.toString())],
              ),
            )),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pose Estimation",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: Icon(Icons.flip_camera_android),
            onPressed: toggleCamera,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
          margin: const EdgeInsets.only(top: 0),
          color: Colors.black,
          child: Stack(
            children: stackChildren,
          )),
    );
  }
}

class PosePainter extends CustomPainter {
  PosePainter(this.absoluteImageSize, this.poses);

  final Size absoluteImageSize;
  final List<Pose> poses;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    final facePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = const Color.fromARGB(255, 207, 6, 207);

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
            Offset(landmark.x * scaleX, landmark.y * scaleY), 1, paint);
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(Offset(joint1.x * scaleX, joint1.y * scaleY),
            Offset(joint2.x * scaleX, joint2.y * scaleY), paintType);
      }

      //Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          rightPaint);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, rightPaint);

      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, rightPaint);
      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

      //Draw face

      paintLine(
          PoseLandmarkType.leftEyeOuter, PoseLandmarkType.leftEye, facePaint);
      paintLine(
          PoseLandmarkType.leftEye, PoseLandmarkType.leftEyeInner, facePaint);
      paintLine(
          PoseLandmarkType.leftEyeInner, PoseLandmarkType.nose, facePaint);
      paintLine(
          PoseLandmarkType.nose, PoseLandmarkType.rightEyeInner, facePaint);
      paintLine(
          PoseLandmarkType.rightEyeInner, PoseLandmarkType.rightEye, facePaint);
      paintLine(
          PoseLandmarkType.rightEye, PoseLandmarkType.rightEyeOuter, facePaint);
      paintLine(
          PoseLandmarkType.leftMouth, PoseLandmarkType.rightMouth, facePaint);
    }
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}
