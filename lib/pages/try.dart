import 'package:flutter/material.dart';
import 'package:poseimageestimation/exercise/exercise.dart';

class Try extends StatefulWidget {
  const Try({super.key});

  @override
  State<Try> createState() => _TryState();
}

class _TryState extends State<Try> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        
          title: Text("try"),
          leading: IconButton(
              onPressed: () {
                
              },
              icon: Icon(Icons.abc))),
    );
  }
}
