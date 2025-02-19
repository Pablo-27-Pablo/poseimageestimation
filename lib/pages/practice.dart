import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:poseimageestimation/pages/realtime_2.dart';
import 'package:poseimageestimation/utils/constant.dart';

class Trypage extends StatefulWidget {
  const Trypage({super.key});

  @override
  State<Trypage> createState() => _TrypageState();
}

class _TrypageState extends State<Trypage> {
  FlutterTts _flutterTts = FlutterTts();

  final List<Map<String, String>> exercises = [
    {"name": "squat", "image": "squat.gif"},
    {"name": "jumpingjacks", "image": "jumpingjacks.gif"},
    {"name": "legraises", "image": "legraises.gif"},
    {"name": "situp", "image": "situp.gif"},
    {"name": "mountainclimbers", "image": "mountainclimbers.gif"},
    {"name": "highknee", "image": "highknee.gif"},
    {"name": "lunges", "image": "lunges.gif"},
    {"name": "plank", "image": "plank.jpg"},
    {"name": "rightplank", "image": "sideplank.gif"},
    {"name": "leftplank", "image": "sideplank.gif"},
    {"name": "pushup", "image": "sideplank.jpg"},
  ];

  void _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(0.5);
    await _flutterTts.speak(text);
  }

  void _startExercise(String exerciseName, String imageName) {
    setState(() {
      ExerciseName = exerciseName;
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
      appBar: AppBar(title: const Text("Try Page")),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exercise["name"]!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => _startExercise(exercise["name"]!, exercise["image"]!),
                  icon: const Icon(Icons.fitness_center),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
