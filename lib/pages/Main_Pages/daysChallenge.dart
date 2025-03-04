import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poseimageestimation/pages/arcade_mode_page.dart';
import 'package:poseimageestimation/pages/home.dart';
import 'package:poseimageestimation/pages/realtime_2.dart';
import 'package:poseimageestimation/utils/constant.dart';

class ThirtyDaysChallenge extends StatefulWidget {
  const ThirtyDaysChallenge({super.key});

  @override
  State<ThirtyDaysChallenge> createState() => _ThirtyDaysChallengeState();
}

class _ThirtyDaysChallengeState extends State<ThirtyDaysChallenge> {
  var peopleBox = Hive.box("Box");
  int days = 0;

  @override
  void initState() {
    super.initState();
    peopleBox = Hive.box("Box");
    days = peopleBox.get(ExerciseName, defaultValue: 0);
  }

  final List<Map<String, dynamic>> exercises = List.generate(
    30,
    (index) => {"day": "Day ${index + 1}", "Counts": (index + 1) * 100},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ArcadeModePage()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.textwhite,
            )),
        title: Text(
          "",
          style: TextStyle(color: AppColor.textwhite),
        ),
        backgroundColor: AppColor.primary,
        centerTitle: true,
        elevation: 5.0,
        shadowColor: AppColor.shadow,
      ),
      backgroundColor: AppColor.backgroundgrey,
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: AssetImage('assets/image/poseestimation2.jpg'),
                      fit: BoxFit.cover)),
              margin: EdgeInsets.all(15),
              height: 170,
              width: 400,
              child: Center(
                child: Text(
                  '"100 $ExerciseName 30 Days Challenge"',
                  style: TextStyle(
                      color: AppColor.yellowtext,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  final isCompleted = days >= exercise["Counts"];
                  final isAvailable = days + 100 >= exercise["Counts"];

                  return GestureDetector(
                    onDoubleTap: isAvailable
                        ? () {
                            if (!isCompleted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                              );
                            }
                          }
                        : null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColor.primary.withOpacity(0.8)
                            : AppColor.bottonSecondary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.shadow.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            exercise["day"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? AppColor.textwhite
                                  : AppColor.textwhite,
                            ),
                          ),
                          isAvailable
                              ? IconButton(
                                  onPressed: () {
                                    peopleBox.put("counts", 20);
                                    setState(
                                        () => days = peopleBox.get("counts"));
                                  },
                                  icon: Icon(
                                    isCompleted
                                        ? Icons.check_circle
                                        : Icons.fitness_center,
                                    color: isCompleted
                                        ? Colors.greenAccent
                                        : AppColor.purpletext,
                                    size: 30,
                                  ),
                                )
                              : Icon(
                                  Icons.lock,
                                  color: AppColor.solidtext.withOpacity(0.6),
                                  size: 30,
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
