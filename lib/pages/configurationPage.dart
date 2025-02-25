import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poseimageestimation/utils/constant.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              print(peopleBox.get('squat'));
              peopleBox.put('squat',1020);
            },
            icon: Icon(Icons.abc_rounded)),
      ),
    );
  }
}
