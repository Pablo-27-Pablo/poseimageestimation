import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:poseimageestimation/pages/home.dart';
import 'package:poseimageestimation/pages/realtime_2.dart';
import 'package:poseimageestimation/utils/constant.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Trypage extends StatefulWidget {
  const Trypage({super.key});

  @override
  State<Trypage> createState() => _TrypageState();
}

class _TrypageState extends State<Trypage> {
  FlutterTts _flutterTts = FlutterTts();

  final List<Map<String, String>> exercises = [
    {"name": "squat", "image": "squat.gif", "PrimaryName": "Squat"},
    {
      "name": "jumpingjacks",
      "image": "jumpingjacks.gif",
      "PrimaryName": "JumpingJacks"
    },
    {
      "name": "legraises",
      "image": "legraises.gif",
      "PrimaryName": "Leg-Raises"
    },
    {"name": "situp", "image": "situp.gif", "PrimaryName": "Sit-Up"},
    {"name": "lunges", "image": "lunges.gif", "PrimaryName": "Lunges"},
    {"name": "plank", "image": "plank.jpg", "PrimaryName": "Plank"},
    {
      "name": "rightplank",
      "image": "sideplank.gif",
      "PrimaryName": "Right-Plank"
    },
    {
      "name": "leftplank",
      "image": "sideplank.gif",
      "PrimaryName": "Left-Plank"
    },
    {"name": "pushup", "image": "sideplank.jpg", "PrimaryName": "Push-Up"},
  ];

  void _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(0.8);
    await _flutterTts.speak(text);
  }

  void _startExercise(
      String exerciseName, String imageName, String PrimaryName) {
    setState(() {
      ExerciseName = exerciseName;
      PrimaryExerciseName = PrimaryName;
      image = imageName;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundgrey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHome()),
              );
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text("Pose Estimation Exercises",
            style: TextStyle(
                color: Color.fromARGB(255, 240, 240, 240),
                fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.primary,
        iconTheme: const IconThemeData(color: AppColor.textwhite),
      ),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: AssetImage('assets/image/poseestimation.jpg'),
                      fit: BoxFit.cover)),
              margin: EdgeInsets.all(15),
              height: 170,
              width: 400,
              child: Center(
                child: Text(
                  '"Success starts with self-discipline."',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 237, 218, 248),
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
              )),
          Divider(
            thickness: 1,
            color: const Color.fromARGB(255, 145, 145, 145).withOpacity(0.3),
          ),
          smallGap,
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Text(
                  "Exercise: ",
                  style: TextStyle(color: AppColor.textwhite,fontSize: 20,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          smallGap,
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return GestureDetector(
                  onDoubleTap: () => _startExercise(exercise["name"]!,
                      exercise["image"]!, exercise["PrimaryName"]!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.bottonPrimary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.bottonSecondary.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              exercise["PrimaryName"]!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.textwhite,
                              ),
                            ),
                            Text(
                              " •",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.yellowtext,
                              ),
                            ),
                          ],
                        ),
                        ClipOval(
                            child: Image.asset(
                          'assets/image/' + exercise["image"].toString(),
                          height: 55,
                          width: 55,
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
