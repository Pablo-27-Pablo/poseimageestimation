import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poseimageestimation/pages/arcade_mode_page.dart';
import 'package:poseimageestimation/pages/realtime_2.dart';
import 'package:poseimageestimation/utils/constant.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

Timer? timer;

class RestimeTutorial extends StatefulWidget {
  const RestimeTutorial({super.key});

  @override
  State<RestimeTutorial> createState() => _RestimeTutorialState();
}

class _RestimeTutorialState extends State<RestimeTutorial> {
  String exerciseImage = "";
  String instructionExercise = "";
  String instructionExercise2 = "";
  String instructionExercise3 = "";
  String instruction = "";
  String instruction2 = "";
  String instruction3 = "";

  @override
  void initState() {
    super.initState();
    startTimer();
    ExerciseImage();
  }

  calculation() {
    double total = (seconds2 / 30) * 100;
    total = total / 100;
    return total;
  }

  void ArcadePlay() {
    if (1 == arcadeNumber) {
      setState(() {
        ExerciseName = "pushup";
        image = "pushup.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }

    if (2 == arcadeNumber) {
      setState(() {
        ExerciseName = "squat";
        image = "squat.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }

    if (3 == arcadeNumber) {
      setState(() {
        ExerciseName = "legraises";
        image = "legraises.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }

    if (4 == arcadeNumber) {
      setState(() {
        ExerciseName = "situp";
        image = "situp.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    if (5 == arcadeNumber) {
      setState(() {
        ExerciseName = "mountainclimbers";
        image = "mountainclimbers.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    if (6 == arcadeNumber) {
      setState(() {
        ExerciseName = "highknee";
        image = "highknee.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    if (7 == arcadeNumber) {
      setState(() {
        ExerciseName = "lunges";
        image = "lunges.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    if (8 == arcadeNumber) {
      setState(() {
        ExerciseName = "plank";
        image = "plank.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    if (9 == arcadeNumber) {
      setState(() {
        ExerciseName = "rightplank";
        image = "rightplank.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    if (10 == arcadeNumber) {
      setState(() {
        ExerciseName = "leftplank";
        image = "leftplank.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    if (11 == arcadeNumber) {
      setState(() {
        ExerciseName = "jumpingjacks";
        image = "jumpingjacks.gif";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

ExerciseImage() {
  if (1 == arcadeNumber) {
    exerciseImage = "pushup";
    instructionExercise = "Get into the Starting Position";
    instructionExercise2 = "Lower Your Body";
    instructionExercise3 = "Push Back Up";
    instruction =
        " - Place your hands shoulder-width apart on the floor\n - Extend your legs straight back with your toes on the ground\n - Keep your body in a straight line from head to heels (engage your core)\n - Your hands should be directly under your shoulders ";
    instruction2 =
        " - Bend your elbows and lower your chest toward the floor.\n - Keep your elbows at about a 45-degree angle from your body (not flared out too wide).\n - Lower yourself until your chest is just above the ground.";
    instruction3 =
        " - Press through your palms and straighten your arms\n - Keep your core engaged and body in a straight line\n - Fully extend your arms without locking your elbows.";
  }
  if (2 == arcadeNumber) {
    exerciseImage = "squat";
    instructionExercise = "Stand with Feet Shoulder-Width Apart";
    instructionExercise2 = "Lower Your Body";
    instructionExercise3 = "Push Back Up";
    instruction =
        " - Keep your chest up and back straight\n - Engage your core";
    instruction2 =
        " - Push your hips back and bend your knees\n - Keep your knees aligned with your toes\n - Lower yourself until your thighs are parallel to the ground";
    instruction3 =
        " - Drive through your heels to stand back up\n - Keep your core engaged and back straight";
  }
  if (3 == arcadeNumber) {
    exerciseImage = "legraises";
    instructionExercise = "Lie Flat on Your Back";
    instructionExercise2 = "Lift Your Legs";
    instructionExercise3 = "Lower Your Legs";
    instruction =
        " - Place your hands under your hips for support\n - Keep your legs straight and together";
    instruction2 =
        " - Raise your legs towards the ceiling while keeping them straight\n - Engage your core and avoid arching your back";
    instruction3 =
        " - Slowly lower them back down without touching the ground\n - Repeat while maintaining control";
  }
  if (4 == arcadeNumber) {
    exerciseImage = "situp";
    instructionExercise = "Lie on Your Back";
    instructionExercise2 = "Perform the Sit-Up";
    instructionExercise3 = "Lower Yourself Back Down";
    instruction =
        " - Bend your knees and place your feet flat on the ground\n - Cross your arms over your chest or place hands behind your head";
    instruction2 =
        " - Engage your core and lift your upper body toward your knees\n - Keep your feet planted on the ground";
    instruction3 =
        " - Lower yourself back down with control";
  }
  if (5 == arcadeNumber) {
    exerciseImage = "mountainclimbers";
    instructionExercise = "Get into a Plank Position";
    instructionExercise2 = "Start the Movement";
    instructionExercise3 = "Continue at a Steady Pace";
    instruction = " - Hands directly under shoulders\n - Keep your body in a straight line";
    instruction2 = " - Bring one knee toward your chest\n - Quickly switch legs in a running motion";
    instruction3 = " - Keep your core engaged and move at a steady pace";
  }
  if (6 == arcadeNumber) {
    exerciseImage = "highknee";
    instructionExercise = "Stand Tall";
    instructionExercise2 = "Start the Movement";
    instructionExercise3 = "Move at a Quick Pace";
    instruction = " - Feet hip-width apart\n - Keep your core engaged";
    instruction2 = " - Drive one knee toward your chest\n - Quickly switch legs, bringing the opposite knee up";
    instruction3 = " - Move at a quick pace like running in place";
  }
  if (7 == arcadeNumber) {
    exerciseImage = "lunges";
    instructionExercise = "Stand with Feet Together";
    instructionExercise2 = "Step Forward";
    instructionExercise3 = "Push Back Up";
    instruction = " - Keep your upper body straight";
    instruction2 = " - Lower your hips until both knees are bent at 90 degrees\n - Keep your front knee above your ankle";
    instruction3 = " - Drive through your front heel to return to starting position\n - Switch legs and repeat";
  }
  if (8 == arcadeNumber) {
    exerciseImage = "plank";
    instructionExercise = "Get into a Forearm Plank Position";
    instructionExercise2 = "Hold the Position";
    instructionExercise3 = "Maintain Stability";
    instruction = " - Place elbows directly under shoulders";
    instruction2 = " - Keep your body in a straight line";
    instruction3 = " - Engage your core and hold the position";
  }
  if (9 == arcadeNumber) {
    exerciseImage = "rightplank";
    instructionExercise = "Lie on Your Right Side";
    instructionExercise2 = "Lift Your Hips";
    instructionExercise3 = "Hold the Position";
    instruction = " - Stack your legs on top of each other\n - Place your right elbow under your shoulder";
    instruction2 = " - Lift your hips off the ground";
    instruction3 = " - Keep your body in a straight line and hold";
  }
  if (10 == arcadeNumber) {
    exerciseImage = "leftplank";
    instructionExercise = "Lie on Your Left Side";
    instructionExercise2 = "Lift Your Hips";
    instructionExercise3 = "Hold the Position";
    instruction = " - Stack your legs on top of each other\n - Place your left elbow under your shoulder";
    instruction2 = " - Lift your hips off the ground";
    instruction3 = " - Keep your body in a straight line and hold";
  }
  if (11 == arcadeNumber) {
    exerciseImage = "jumpingjacks";
    instructionExercise = "Start Standing";
    instructionExercise2 = "Perform the Movement";
    instructionExercise3 = "Repeat at a Steady Pace";
    instruction = " - Feet together, arms at your sides";
    instruction2 = " - Jump while spreading your legs and raising your arms overhead";
    instruction3 = " - Jump again to return to the starting position";
  }
}


  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds2 > 0) {
        setState(() {
          seconds2--;
        });
      } else {
        timer?.cancel();
        seconds2 = 2;
        ArcadePlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundgrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseImage,
                    style: TextStyle(
                      color: AppColor.textwhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Mucsle Gain · Cardio · Physique",
                    style: TextStyle(color: AppColor.purpletext),
                  ),
                ],
              ),
            ),
            Center(
                child: Column(
              children: [
                Text(seconds2.toString(),
                    style: TextStyle(
                        color: AppColor.purpletext,
                        fontWeight: FontWeight.bold,
                        fontSize: 55)),
                Text("Break Time",
                    style: TextStyle(
                        color: AppColor.purpletext,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            )),
            Expanded(
              child: Center(
                child: CircularPercentIndicator(
                    radius: 150,
                    lineWidth: 10,
                    percent: calculation(),
                    progressColor: AppColor.yellowtext,
                    backgroundColor: AppColor.yellowtext.withOpacity(0.3),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: ClipOval(
                      child: Container(
                          height: 275,
                          child: Image.asset(
                              "assets/image/" + exerciseImage + ".gif")),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Instruction: ",
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 48, 48, 48),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(16),
                
                  children: [
                    Text(
                      instructionExercise+":",
                      style:
                          TextStyle(color:const Color.fromARGB(255, 238, 238, 238), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    smallGap,
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 128, 128, 128).withOpacity(0.3)
                      ),
                      child: Text(
                        instruction,
                        style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color:  Color.fromARGB(255, 150, 150, 150)),
                      ),
                    ),
                    smallGap,
                    smallGap,
                    instructionExercise2 == "" ? Container() : Text(
                      instructionExercise2+":",
                      style:
                          TextStyle(color:Color.fromARGB(255, 238, 238, 238), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    smallGap,
                    
                    instruction2 == "" ? Container() : Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 128, 128, 128).withOpacity(0.3)
                      ),
                      child: Text(
                        instruction,
                        style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 150, 150, 150)),
                      ),
                    ),
                    smallGap,
                    smallGap,
                    instructionExercise3 == "" ? Container() :  Text(
                      instructionExercise3+":",
                      style:
                          TextStyle(color:const Color.fromARGB(255, 238, 238, 238), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    smallGap,
                    instruction3 == "" ? Container() : Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  Color.fromARGB(255, 128, 128, 128).withOpacity(0.3)
                      ),
                      child: Text(
                        instruction3,
                        style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 150, 150, 150)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
