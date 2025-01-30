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
  speak(text) async {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setPitch(0.5);
    _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("try page"),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey.withOpacity(0.5),
            child: Row(
              children: [
                Text("squat"),
                IconButton(
                    onPressed: () {
                      ExerciseName = "squat";
                      image = "squat.gif";
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    },
                    icon: Icon(Icons.abc)),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            color: Colors.grey.withOpacity(0.5),
            child: Row(
              children: [
                Text("Pushup"),
                IconButton(
                    onPressed: () {
                      ExerciseName = "pushup";
                      image = "pushup.gif";
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    },
                    icon: Icon(Icons.abc)),
              ],
            
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            color: Colors.grey.withOpacity(0.5),
            child: Row(
              children: [
                Text("Speak"),
                IconButton(
                    onPressed: () {
                      speak("Hello Hello Happy New Year everyone");
                      // ExerciseName = "pushup";
                      // image = "pushup.gif";
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => MyHomePage()));
                    },
                    icon: Icon(Icons.abc)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
