import 'package:flutter/material.dart';
import 'package:poseimageestimation/pages/arcade_mode_page.dart';
import 'package:poseimageestimation/pages/breaktimeConfiguration.dart';
import 'package:poseimageestimation/pages/daysChallenge.dart';
import 'package:poseimageestimation/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:poseimageestimation/pages/practice.dart';
import 'package:poseimageestimation/pages/realtime_2.dart';
import 'package:poseimageestimation/pages/resttime.dart';
import 'package:poseimageestimation/utils/constant.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initializes Hive for Flutter
  await Hive.openBox("Box");
  cameras = await availableCameras(); // Initialize cameras
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}
