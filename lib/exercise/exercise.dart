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

// Function to detect squat exercise movements
void squatExercise(leftHip, leftKnee, leftAnkle, averageShoulder, averageHips,
    averageShoulderY, averageHipsY) {
  double kneeAngle = calculateKneeAngle(leftHip, leftKnee, leftAnkle);

  // Ensure proper posture

  if (averageShoulderY + 20 < averageHipsY && leftAnkle.y > averageHips) {
    // print(leftAnkle.y);
    if (kneeAngle < 3) {
      warningIndicatorTextExercise = "Too low, raise squat position!";
      speak(warningIndicatorTextExercise);
      warningIndicatorScreen = false;
    }

    // Detect "down" position
    if (kneeAngle < 130 && !staticIsDown) {
      warningIndicatorTextExercise = "";
      if (!staticIsDown) {
        staticIsDown = true;
        staticIsUp = false;
        print("Squat: Down position detected");
      }
    }

    // Detect "up" position
    if (kneeAngle > 140 && !staticIsUp) {
      StandStraight(averageShoulder, averageHips);
      warningIndicatorTextExercise = "";
      if (staticIsDown && !staticIsUp) {
        staticIsUp = true;
        staticIsDown = false;
        raise++;
        print("Squat count: $raise");
      }
    }
  }
}

void pushupExercise(avgWristY, avgShoulderY, avgElbowY, averageHipsY,
    averageKneeY, averageAnkleY) {
  pushupError(
      averageHipsY, avgShoulderY, avgWristY, averageKneeY, averageAnkleY);

  if (avgWristY + 30 > averageAnkleY) {
    // Detect "down" position (elbows near shoulders)
    if (avgElbowY < avgShoulderY + 30 && avgWristY > avgShoulderY) {
      print(
          "Down position detected: Shoulder: $avgShoulderY Elbow: $avgElbowY  Hips: " +
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
    if (avgWristY > avgShoulderY &&
        avgElbowY < avgWristY &&
        avgShoulderY < avgElbowY - 45 &&
        !staticIsUp) {
      pushupError(
          averageHipsY, avgShoulderY, avgWristY, averageKneeY, averageAnkleY);
      print("up");
      warningIndicatorScreen = true;
      warningIndicatorTextExercise = "";

      if (staticIsDown && !staticIsUp) {
        staticIsUp = true;
        staticIsDown = false;
        print(staticIsUp);

        // Count a completed push-up
        raise++;
        print("Push-up count: $raise");
      }
    }
  }
}

pushupError(
    averageHipsY, avgShoulderY, avgWristY, averageKneeY, averageAnkleY) {
  if ((averageHipsY < avgShoulderY - 10 || averageKneeY - 10 > averageAnkleY) &&
      avgWristY + 20 > averageAnkleY &&
      staticIsUp) {
    warningIndicatorScreen = false;
    warningIndicatorTextExercise =
        "Your hips are not align, Make your body straight";
    speak(warningIndicatorTextExercise);
  } else if ((averageHipsY < avgShoulderY - 23 ||
          averageHipsY + 10 > avgWristY) &&
      avgWristY + 20 > averageAnkleY &&
      staticIsDown) {
    warningIndicatorScreen = false;
    warningIndicatorTextExercise =
        "Your hips are not  not align, Make your body straight";
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
  int currentTime = DateTime.now().millisecondsSinceEpoch;

  if (shoulder >= hips + 30 || shoulder <= hips - 30) {
    if (currentTime - lastUpdateTime3 >= 2000) {
      warningIndicatorScreen = false;
      warningIndicatorText = "The body is not align";
      speak(warningIndicatorText); // Increment raise every second
      lastUpdateTime3 = currentTime; // Update the last update time
    }

    //speak(warningIndicatorText);

    //print("Wrong posture");
    //print("Shoulder: $shoulder, Hips: $hips");
  } else {
    warningIndicatorScreen = true;
    warningIndicatorText = "";
    //print("Right posture");
    //print("Shoulder: $shoulder, Hips: $hips");
  }
}

// Function to detect leg raise movements
void legRaiseExercise(
    avgHipY, avgKneeY, avgAnkleY, averageShoulderY, averageEarsY) {
  // Detect "down" position

  if (averageShoulderY + 10 > avgHipY && averageEarsY + 20 > avgHipY) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    if (avgHipY < avgAnkleY + 1) {
      if (currentTime - lastUpdateTime3 >= 2000) {
        warningIndicatorText = "don't let your ankle drop too low!";
        speak(warningIndicatorText); // Increment raise every second
        lastUpdateTime3 = currentTime; // Update the last update time
      }

      warningIndicatorScreen = false;
    }

    if (avgAnkleY > avgHipY - 20 && !staticIsDown) {
      warningIndicatorScreen = true;

      //Error

      if (avgHipY - 30 > avgKneeY || avgKneeY < avgAnkleY - 5) {
        if (currentTime - lastUpdateTime3 >= 2000) {
          warningIndicatorTextExercise = "Don't bend your knee!";
          speak(warningIndicatorTextExercise); // Increment raise every second
          lastUpdateTime3 = currentTime; // Update the last update time
        }

        warningIndicatorScreen = false;
      } else {
        warningIndicatorTextExercise = "";
        warningIndicatorScreen = true;
      }
      if (!staticIsDown) {
        staticIsDown = true;
        staticIsUp = false;
        warningIndicatorScreen = true;
        warningIndicatorTextExercise = "";
      }
    }

    // Detect "up" position
    if (avgAnkleY < avgHipY - 100 && !staticIsUp) {
      warningIndicatorTextExercise = "";
      warningIndicatorText = "";
      warningIndicatorScreen = true;
      print("true");
      warningIndicatorScreen = true;
      warningIndicatorTextExercise = "";

      if (staticIsDown && !staticIsUp) {
        staticIsUp = true;
        staticIsDown = false;
        raise++;
        print("Leg raise count: $raise");
      }
    }
  }
}

void sitUpExercise(noseX, avgShoulderY, avgHipY, averageKneeY, averageAnkleY) {
  //sitUpError(avgHeadY, avgShoulderY, avgHipY);
  if (averageKneeY + 70 < avgHipY && averageKneeY + 70 < averageAnkleY) {
    // Detect "down" position (shoulders near the ground)

    if (avgShoulderY + 10 > avgHipY && !staticIsDown) {
      //print("Down position detected: Head: $avgHeadY Shoulders: $avgShoulderY Hips: " + avgHipY.toString());
      print("                     ");

      if (!staticIsDown) {
        staticIsDown = true;
        staticIsUp = false;
        warningIndicatorScreen = true;
        warningIndicatorTextExercise = "";
      }
    }

    // Detect "up" position (shoulders raised above hips)
    if (avgShoulderY < averageKneeY && !staticIsUp) {
      //sitUpError(avgHeadY, avgShoulderY, avgHipY);
      print("Up position detected");
      warningIndicatorScreen = true;
      warningIndicatorTextExercise = "";

      if (staticIsDown && !staticIsUp) {
        staticIsUp = true;
        staticIsDown = false;
        print(staticIsUp);

        // Count a completed sit-up
        raise++;
        print("Sit-up count: $raise");
      }
    }
  }
}

void jumpingJacksExercise(
    averageWristY,
    averageShoulderY,
    leftAnkle,
    rightAnkle,
    leftShoulder,
    rightShoulder,
    avgHipY,
    averageShoulderX,
    avgHipX,
    averageAnkleY) {
  //jumpingJacksError(avgWristX, avgShoulderX, avgAnkleX, avgHipY, avgAnkleY);

  if (averageShoulderY + 20 < avgHipY && avgHipY + 20 < averageAnkleY) {
    StandStraight(averageShoulderX, avgHipX);
    //print("$averageShoulderX           $avgHipX");
    // Detect "closed" position (hands close together, feet close together)
    if (averageWristY + 20 > avgHipY &&
        leftAnkle - 10 < leftShoulder &&
        rightAnkle + 10 > rightShoulder) {
      warningIndicatorScreen = true;
      //print("Closed position detected: Wrists: $avgWristX Shoulders: $avgShoulderX Ankles: $avgAnkleX");
      //print("         TRUE            ");
      //print(rightAnkle);

      if (!staticIsDown) {
        staticIsDown = true;
        staticIsUp = false;
        warningIndicatorScreen = true;
        warningIndicatorTextExercise = "";
      }
    }

    // Detect "open" position (hands and feet spread apart)
    if (averageWristY < averageShoulderY - 30 &&
        leftAnkle - 13 > leftShoulder &&
        rightAnkle < rightShoulder - 13 &&
        !staticIsUp) {
      warningIndicatorScreen = true;
      //jumpingJacksError(avgWristX, avgShoulderX, avgAnkleX, avgHipY, avgAnkleY);
      //print("Open position detected");
      warningIndicatorScreen = true;
      warningIndicatorTextExercise = "";

      if (staticIsDown && !staticIsUp) {
        staticIsUp = true;
        staticIsDown = false;
        print(staticIsUp);

        // Count a completed jumping jack
        raise++;
        print("Jumping jack count: $raise");
      }
    }
  }
}

void mountainClimbersExercise(avgKneeY, avgHipX, leftKneeX, leftKneeY,
    rightKneeX, rightKneeY, averageWristY, averageShoulderY, avgHipY) {
  if (averageWristY > avgHipY) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    //error
    if (avgHipY < averageShoulderY - 50) {
      if (currentTime - lastUpdateTime >= 2000) {
        warningIndicatorTextExercise = "dont over high your butt";
        warningIndicatorScreen = false;
        speak(warningIndicatorTextExercise);
        lastUpdateTime = currentTime; // Update the last update time
      } else {
        warningIndicatorTextExercise = "";
        warningIndicatorScreen = true;
      }
    }

    // Detect if the left knee is reaching the elbow position
    if (leftKneeX > avgHipX + 37 &&
        rightKneeX < avgHipX - 35 &&
        averageWristY + 10 > rightKneeY &&
        !staticIsDown) {
      // Ensure the state is updated only if it's not already in the "down" position
      if (!staticIsDown) {
        staticIsDown = true;
        staticIsUp = false;
        warningIndicatorScreen = true;
        warningIndicatorTextExercise = ""; // Clear warning text if needed
      }
    }

    // Detect if the right knee is reaching the elbow position
    if (rightKneeX > avgHipX + 37 &&
        leftKneeX < avgHipX - 35 &&
        averageWristY + 10 > leftKneeY &&
        !staticIsUp) {
      print("Low knee position detected");
      warningIndicatorScreen = true;
      warningIndicatorTextExercise = ""; // Clear warning text if needed

      // Update state when transitioning from "down" to "up" position
      if (staticIsDown && !staticIsUp) {
        staticIsUp = true;
        staticIsDown = false;
        print(staticIsUp);

        // Increment the mountain climber count and log the value
        raise++;
        print("Mountain climber count: $raise");
      }
    }
  }
}

void highKneeExercise(leftKneeY, rightKneeY, avgHipY, avgShoulderX, avgHipX,
    avgShoulderY, averageAnkleY) {
  StandStraight(avgShoulderX, avgHipX);

  if (avgHipY > avgShoulderY + 20 && avgHipY + 20 < averageAnkleY) {}
  // Detect "raised knee" position (knee above hip level)
  if (rightKneeY < avgHipY + 25 && avgHipY < leftKneeY - 100) {
    // print(" true ");
    // print("   $avgHipY          $rightKneeY         ");

    if (!staticIsDown) {
      staticIsDown = true;
      staticIsUp = false;
      warningIndicatorScreen = true;
      warningIndicatorTextExercise = ""; // Clear warning text if needed
    }
  }

  // Detect "lowered knee" position (knee below hip level)
  if (leftKneeY < avgHipY + 25 && avgHipY < rightKneeY - 100 && !staticIsUp) {
    // print("Lowered knee position detected");
    warningIndicatorScreen = true;
    warningIndicatorTextExercise = "";

    if (staticIsDown && !staticIsUp) {
      staticIsUp = true;
      staticIsDown = false;
      print(staticIsDown);

      // Count a completed high knee step
      raise++;
      // print("High knee count: $raise");
    }
  }
}

void sidePlankRightExercise(avgShoulderY, avgHipY, avgAnkleY, rightElbow,
    rightKneeY, leftElbowY, leftShoulderY) {
  int currentTime2 =
      DateTime.now().millisecondsSinceEpoch; 
      
      plankError(avgShoulderY, avgHipY, currentTime2);// Get current time in milliseconds

  // Detect proper side plank position (right side)

  //print("$avgHipY  $avgShoulderY ");
  if (avgHipY < avgShoulderY + 50 &&
      rightElbow + 10 > avgAnkleY &&
      rightElbow - 40 > avgHipY &&
      leftElbowY < leftShoulderY - 10) {
    // Check if 1 second has passed
    if (currentTime2 - lastUpdateTime2 >= 1000) {
      raise++; // Increment raise every second
      lastUpdateTime2 = currentTime2; // Update the last update time
    }

    //print("Side plank right position held");
    warningIndicatorScreen = true;
    warningIndicatorTextExercise = "";
  } else {
    lastUpdateTime2 = currentTime2; // Reset timer when position is lost
  }
}

// Stores the last time incremented

// plank error

void plankError(avgShoulderY, avgHipY, currentTime) {
  if (avgShoulderY + 10 > avgHipY || avgShoulderY + 50 < avgHipY) {
    if (currentTime - lastUpdateTime3 >= 2000) {
      warningIndicatorScreen = false;
      warningIndicatorText = "The body is not align";
      speak(warningIndicatorText);
      lastUpdateTime3 = currentTime; // Update the last update time
    }
  }
}

void sidePlankLeftExercise(avgShoulderY, avgHipY, avgAnkleY, leftElbow,
    leftKneeY, rightElbowY, rightShoulderY) {
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  plankError(avgShoulderY, avgHipY, currentTime);
  // Get current time in milliseconds

// print(" $rightElbowY      <     $rightShoulderY                   ");
  // Detect proper side plank position (right side)
  if (avgHipY < avgShoulderY + 50 &&
      leftElbow + 10 > avgAnkleY &&
      leftElbow - 40 > avgHipY &&
      rightElbowY < rightShoulderY - 10) {
    // Check if 1 second has passed
    if (currentTime - lastUpdateTime >= 1000) {
      raise++; // Increment raise every second
      lastUpdateTime = currentTime; // Update the last update time
    }
  } else {
    lastUpdateTime = currentTime; // Reset timer when position is lost
  }
}

void normalPlankExercise(avgShoulderY, avgHipY, avgAnkleY, leftElbow, leftKneeY,
    rightElbowY, rightShoulderY) {
  int currentTime =
      DateTime.now().millisecondsSinceEpoch; 
       plankError(avgShoulderY, avgHipY, currentTime);// Get current time in milliseconds
  print(" $rightElbowY      <     $rightShoulderY                   ");
  // Detect proper side plank position (right side)
  if (avgHipY < avgShoulderY + 50 &&
      leftElbow + 5 > leftKneeY &&
      leftElbow - 10 > avgHipY) {
    // Check if 1 second has passed
    if (currentTime - lastUpdateTime3 >= 1000) {
      raise++; // Increment raise every second
      lastUpdateTime3 = currentTime; // Update the last update time
    }

    //print("Side plank right position held");
    warningIndicatorScreen = true;
    warningIndicatorTextExercise = "";
  } else {
    lastUpdateTime3 = currentTime; // Reset timer when position is lost
  }
}

void lungesExercise(
    averageHipsY,
    averageHipsX,
    leftKneeX,
    leftKneeY,
    rightKneeX,
    rightKneeY,
    leftAnkleY,
    leftAnkleX,
    rightAnkleY,
    rightAnkleX,
    avgShoulderX) {
  StandStraight(avgShoulderX, averageHipsX);
  // Detect "down" position (knee close to the ground)
  print(" $staticIsDown     ");
  if (leftAnkleY < leftKneeY + 40 &&
      rightKneeY < averageHipsY + 15 &&
      rightAnkleY < leftKneeY + 40 &&
      !staticIsDown) {
    print("true");
    print("                     ");

    if (!staticIsDown) {
      staticIsDown = true;
      staticIsUp = false;
      warningIndicatorScreen = true;
      warningIndicatorTextExercise = "";
    }
  }

  if (rightAnkleY < rightKneeY + 40 &&
      leftKneeY < averageHipsY + 15 &&
      leftAnkleY < rightKneeY + 50 &&
      !staticIsUp) {
    print("false");
    print("    $rightKneeY 40 +  > $leftAnkleY               ");

    if (staticIsDown && !staticIsUp) {
      staticIsUp = true;
      staticIsDown = false;
      print(staticIsUp);

      // Count a completed lunge
      raise++;
      print("Lunge count: $raise");
    }
  }
}
