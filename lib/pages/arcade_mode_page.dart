import 'package:flutter/material.dart';
import 'package:poseimageestimation/pages/Main_Pages/daysChallenge.dart';
import 'package:poseimageestimation/pages/home.dart';
import 'package:poseimageestimation/pages/Main_Pages/resttime.dart';
import 'package:poseimageestimation/utils/constant.dart';

class ArcadeModePage extends StatefulWidget {
  const ArcadeModePage({super.key});

  @override
  State<ArcadeModePage> createState() => _ArcadeModePageState();
}

class _ArcadeModePageState extends State<ArcadeModePage> {
  final List<Map<String, String>> exercises = [
    {"name": "Push Up", "PrimaryName": "pushup", "image": "pushup.gif"},
    {"name": "Sit Up", "PrimaryName": "situp", "image": "situp.gif"},
    {
      "name": "Leg Raises",
      "PrimaryName": "legraises",
      "image": "legraises.gif"
    },
    {"name": "Squat", "PrimaryName": "squat", "image": "squat.gif"},
  ];

  void startExercise(String exerciseName, String imageName, String Name) {
    Mode = "dayChallenge";

    setState(() {
      ExerciseName = exerciseName;
      image = imageName;
      PrimaryExerciseName = Name;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ThirtyDaysChallenge()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHome()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.textwhite,
            )),
        title: const Text("Arcade Mode",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.textwhite)),
        centerTitle: true,
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () {
                Mode = "Arcade";
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RestimeTutorial()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 2, color: AppColor.primary)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Arcade",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textwhite,
                          ),
                        ),
                        Text(
                          "Semi Arcade",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.purpletext,
                          ),
                        ),
                      ],
                    ),
                    ClipOval(
                      child: Image.asset(
                        "assets/image/arcade.gif",
                        height: 65,
                        color: Colors.transparent, // Apply transparency
                        colorBlendMode: BlendMode
                            .multiply, // Adjust blend mode based on background color
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "100 Exercise in 30 days",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.yellowtext,
              ),
            ),
            largeGap,
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return GestureDetector(
                    onDoubleTap: () => startExercise(exercise["PrimaryName"]!,
                        exercise["image"]!, exercise["name"]!),
                    child: Container(
                      height: 85,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundgrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColor.textwhite.withOpacity(0.3),
                            width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primary.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            exercise["name"]!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.textwhite),
                          ),
                          Image.asset("assets/image/" + exercise['image']!,
                              height: 75, width: 75, fit: BoxFit.cover),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.backgroundgrey,
    );
  }
}
