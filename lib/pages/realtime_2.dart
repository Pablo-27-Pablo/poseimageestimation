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
import 'package:poseimageestimation/exercise/exercise.dart';
import 'package:poseimageestimation/main.dart';
import 'package:poseimageestimation/utils/constant.dart';
import '../utils/constant.dart';

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
      PoseLandmark leftHip = pose.landmarks[PoseLandmarkType.leftHip]!;
      PoseLandmark rightHip = pose.landmarks[PoseLandmarkType.rightHip]!;
      PoseLandmark leftKnee = pose.landmarks[PoseLandmarkType.leftKnee]!;
      PoseLandmark leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle]!;
      double averageShoulder = (leftShoulder.x + rightShoulder.x) / 2;
      double averagehips = (leftHip.x + rightHip.x) / 2;

      squatExercise(leftHip, leftKnee, leftAnkle, averageShoulder, averagehips);
      setState(() {
        raise = raise;
      });
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

      //output screen

      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: Container(
              decoration: warningIndicatorScreen
                  ? BoxDecoration()
                  : BoxDecoration(
                      border: Border.all(width: 2, color: Colors.red),
                      color: Colors.red.withOpacity(0.1)),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        raise.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 70,
                            color: Colors.yellow),
                      ),
                      Text("Reps Count/s"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: AppColor.textwhite,
                              borderRadius: BorderRadius.circular(13)),
                          child: Column(
                            children: [
                              Text("Time"),
                              Text(
                                "10:2".toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: AppColor.shadow),
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 410,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Container(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColor.bottonPrimary.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Exercise Feedback: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppColor.purpletext),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                warningIndicatorText == ""
                                    ? Container()
                                    : Container(
                                        width: 180,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 247, 247, 247)
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255))),
                                        child: Text(
                                          warningIndicatorText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColor.solidtext,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(height: 10,),

                                      //error indicator in exercise
                                warningIndicatorTextExercise == ""
                                    ? Container()
                                    : Container(
                                        width: 180,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 247, 247, 247)
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255))),
                                        child: Text(
                                          warningIndicatorTextExercise,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColor.solidtext,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                              ],
                            )),
                        SizedBox(
                          width: 35,
                        ),
                        Container(
                          width: 90,
                          height: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://homeworkouts.org/wp-content/uploads/anim-sumo-squats.gif',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  largeGap,
                  Container(
                    height: 70,
                    color: AppColor.backgroundgrey.withOpacity(0.8),
                    child: GestureDetector(
                      onDoubleTap: () {
                        print("Pagod na pagod nako");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Go to the next workout",
                            style: TextStyle(
                                color: AppColor.textwhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_right,
                            color: AppColor.textwhite,
                            size: 35,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pose Estimation",
          style: TextStyle(color: AppColor.purpletext),
        ),
        backgroundColor: AppColor.backgroundgrey,
        actions: [
          IconButton(
            icon: Icon(
              Icons.flip_camera_android,
              color: AppColor.purpletext,
            ),
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
      paintLine(
          PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, rightPaint);

      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder,
          rightPaint);
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
