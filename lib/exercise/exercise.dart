import 'dart:math';
import 'package:poseimageestimation/utils/constant.dart';

int raise = 0;

void squatExercise(leftHip, leftKnee, leftAnkle, averageShoulder, averagehips) {
  // State variables

  // Calculate knee angle
  double kneeAngle = calculateKneeAngle(leftHip, leftKnee, leftAnkle);

  // Ensure proper posture
  StandStraight(averageShoulder, averagehips);

  if (kneeAngle < 80) {
    warningIndicatorTextExercise = "To lower squat!!!";
    warningIndicatorScreen = false;
  }
  // Detect "down" position
  if (kneeAngle > 80 && kneeAngle < 130) {
    warningIndicatorTextExercise = "";
    
    print(staticIsDown);
    if (!staticIsDown) {
      staticIsDown = true;
      staticIsUp = false;
      print("Squat: Down position detected");
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
  if (shoulder >= hips + 35 || shoulder <= hips - 35) {
    warningIndicatorScreen = false;
    warningIndicatorText = "The body is not align";
    print("Wrong posture");
    print("Shoulder: $shoulder, Hips: $hips");
  } else {
    warningIndicatorScreen = true;
    warningIndicatorText = "";
    print("Right posture");
    print("Shoulder: $shoulder, Hips: $hips");
  }
}
