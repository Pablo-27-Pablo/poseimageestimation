import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poseimageestimation/exercise/exercise.dart';
import 'package:poseimageestimation/pages/arcade_mode_page.dart';
import 'package:poseimageestimation/pages/Main_Pages/Exercises_Page.dart';

import '../utils/constant.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late ImagePicker imagePicker;
  File? _image;
  dynamic poseDetector;
  String result = '';
  var image;
  late List<Pose> poses;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();

    final options = PoseDetectorOptions(
        mode: PoseDetectionMode.single, model: PoseDetectionModel.base);
    poseDetector = PoseDetector(options: options);
  }

  chooseImage() async {
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      _image = File(selectedImage.path);

      doPoseDetection();
    }
  }

  captureImage() async {
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      _image = File(selectedImage.path);

      doPoseDetection();
    }
  }

  doPoseDetection() async {
    //input file from image we send or capture we send
    InputImage inputImage = InputImage.fromFile(_image!);

    poses = await poseDetector.processImage(inputImage);

    for (Pose pose in poses) {
      // to access all landmarks
      pose.landmarks.forEach((_, landmark) {
        final type = landmark.type;
        final x = landmark.x;
        final y = landmark.y;
        print("${type.name} $x $y");
      });

      // to access specific landmarks
      final landmark = pose.landmarks[PoseLandmarkType.nose];
    }
    setState(() {
      _image;
    });
    drawPose();
  }

  //TODO draw pose
  drawPose() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    setState(() {
      image;
      poses;
      result;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "hello",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onDoubleTap: () {
                Mode = "postureCorrection";
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Trypage()));
              },
              child: Container(
                height: 135,
                width: 500,
                color: Colors.green,
                child: Text("Posture Correction Exercise: "),
              )),
          GestureDetector(
              onDoubleTap: () {
                Mode = "postureCorrection";
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Trypage()));
              },
              child: Container(
                height: 135,
                width: 500,
                color: Colors.red,
                child: Text("Exercise Reccomendations: "),
              )),
          GestureDetector(
              onDoubleTap: () {
                
                int last = peopleBox.get("final", defaultValue: 0);

                if (last < 1) {
                  peopleBox.put("squat", 0);
                  peopleBox.put("legraises", 0);
                  peopleBox.put("pushup", 0);
                  peopleBox.put("situp", 0);
                  peopleBox.put("finalcoloriesburn", 0);
                  peopleBox.put("final", 5);
                }

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ArcadeModePage()));
              },
              child: Container(
                height: 135,
                width: 500,
                color: Colors.pink,
                child: Text("Arcade Mode: "),
              )),
        ],
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  PosePainter(this.poses, this.imageFile);

  final List<Pose> poses;
  var imageFile;

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
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

    final Other = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.pink;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(Offset(landmark.x, landmark.y), 1, paint);
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(joint1.x, joint1.y), Offset(joint2.x, joint2.y), paintType);
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

      //Draw legs

      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
      //Other
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, Other);

      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, Other);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.poses != poses;
  }
}
