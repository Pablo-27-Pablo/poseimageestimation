import 'dart:math';
import 'package:flutter/material.dart';
import 'package:poseimageestimation/pages/practice.dart';
import 'package:poseimageestimation/utils/constant.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

FlutterTts _flutterTts = FlutterTts();
speak(text) async {
  _flutterTts.setLanguage("en-US");
  _flutterTts.setPitch(1.5);
  _flutterTts.speak(text);
}

void squatExercise(leftHip, leftKnee, leftAnkle, averageShoulder, averagehips) {
  // State variables

  // Calculate knee angle
  double kneeAngle = calculateKneeAngle(leftHip, leftKnee, leftAnkle);

  // Ensure proper posture
  StandStraight(averageShoulder, averagehips);

  if (kneeAngle < 80) {
    warningIndicatorTextExercise = "To lower squat!!!";
    speak(warningIndicatorTextExercise);
    warningIndicatorScreen = false;
  }
  // Detect "down" position
  if (kneeAngle > 80 && kneeAngle < 130) {
    warningIndicatorTextExercise = "";

    print(staticIsDown);
    if (!staticIsDown) {
      staticIsDown = true;
      staticIsUp = false;
      //print("Squat: Down position detected");
    }
  }

  // Detect "up" position
  if (kneeAngle > 140) {
    warningIndicatorTextExercise = "";

    if (staticIsDown && !staticIsUp) {
      staticIsUp = true;
      staticIsDown = false;

      // Count a completed squat
      raise += 1;
      print("Squat count: $raise");
    }
  }
}

void pushupExercise(avgWristY, avgShoulderY, avgElbowY, averageHipsY) {
  //Detect down position

  //   print("                     ");
  // print("                     ");
  // print("                     ");
  // print("                     ");
  // print("     Wriist: " +
  //     avgWristY.toString() +
  //     "     Shoulder: " +
  //     avgShoulderY.toString() +
  //     "     Elbow: " +
  //     avgElbowY.toString());
  // print("                     ");
  // print("                     ");
  // print("                     ");
  // print("                     ");

  pushupError(averageHipsY, avgShoulderY, avgWristY, avgElbowY);
  // Detect "down" position (elbows near shoulders)
  if (avgElbowY < avgShoulderY + 50) {
    print("Down position detected: Elbow: $avgElbowY  Hips: " +
        averageHipsY.toString());
    print("                     ");

    if (!staticIsDown) {
      staticIsDown = true;
      staticIsUp = false;
      warningIndicatorScreen = true;
      warningIndicatorTextExercise = "";
    }
  }

  // Detect "up" position (wrists and elbows higher than shoulders)
  if (avgWristY > avgShoulderY && avgElbowY > avgShoulderY) {
    print("up");
    warningIndicatorScreen = true;
    warningIndicatorTextExercise = "";

    if (staticIsDown && !staticIsUp) {
      staticIsUp = true;
      staticIsDown = false;

      // Count a completed push-up
      raise++;
      print("Push-up count: $raise");
    }
  }
}

pushupError(averageHipsY, avgShoulderY, avgWristY, avgElbowY) {
  if (averageHipsY < avgShoulderY + 30 &&
      avgWristY > avgShoulderY &&
      avgElbowY > avgShoulderY) {
    warningIndicatorScreen = false;
    warningIndicatorTextExercise = "Your hips are too high!";
    speak(warningIndicatorTextExercise);
  }
  if (averageHipsY > avgShoulderY + 30 &&
      avgWristY > avgShoulderY &&
      avgElbowY > avgShoulderY) {
    warningIndicatorScreen = false;
    warningIndicatorTextExercise = "Your hips are too low!";
    speak(warningIndicatorTextExercise);
  }
}

double calculateKneeAngle(hip, knee, ankle) {
  double dx1 = knee.x - hip.x;
  double dy1 = knee.y - hip.y;
  double dx2 = knee.x - ankle.x;
  double dy2 = knee.y - ankle.y;

  double dotProduct = dx1 * dx2 + dy1 * dy2;
  double magnitude1 = sqrt(dx1 * dx1 + dy1 * dy1);
  double magnitude2 = sqrt(dx2 * dx2 + dy2 * dy2);
  double cosTheta = dotProduct / (magnitude1 * magnitude2);

  // Clamping value to avoid errors in calculation
  cosTheta = cosTheta.clamp(-1.0, 1.0);
  return acos(cosTheta) * (180 / pi);
}

StandStraight(shoulder, hips) {
  if (shoulder >= hips + 27 || shoulder <= hips - 27) {
    warningIndicatorScreen = false;
    warningIndicatorText = "The body is not align";

    speak(warningIndicatorText);

    //print("Wrong posture");
    //print("Shoulder: $shoulder, Hips: $hips");
  } else {
    warningIndicatorScreen = true;
    warningIndicatorText = "";
    //print("Right posture");
    //print("Shoulder: $shoulder, Hips: $hips");
  }
}
