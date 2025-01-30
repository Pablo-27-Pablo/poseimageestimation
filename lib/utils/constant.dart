import 'dart:async';
import 'package:flutter/material.dart';

//global variable
bool staticIsUp = false;
bool staticIsDown = false;
bool warningIndicatorScreen = true;
String warningIndicatorText = "";
String warningIndicatorTextExercise = "";
int raise = 0;
int seconds = 60;
Timer? timer;
String ExerciseName = "";
String image = "";
bool isDownPosition = false;



//small Gap

const smallGap = SizedBox(
  height: 15,
);

//large Gap
const largeGap = SizedBox(
  height: 30,
);

extension ShowSnackBar on BuildContext {
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.redAccent),
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}

//color

class AppColor {
  static const Color primary = Color(0xFF9575CD);
  static const Color shadow = Color(0xFF5E35B1);
  static const Color solidtext = Color.fromARGB(255, 52, 28, 102);
  static const Color bottonPrimary = Color.fromARGB(255, 51, 51, 51);
  static const Color bottonSecondary = Color.fromARGB(255, 146, 146, 146);
  static const Color textwhite = Color.fromARGB(255, 219, 219, 219);
  static const Color yellowtext = Color.fromARGB(255, 226, 241, 99);
  static const Color purpletext = Color.fromARGB(255, 179, 160, 255);
  static const Color backgroundgrey = Color.fromARGB(255, 30, 30, 30);
}

class Utils extends StatefulWidget {
  const Utils({super.key});

  @override
  State<Utils> createState() => _UtilsState();
}

class _UtilsState extends State<Utils> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
