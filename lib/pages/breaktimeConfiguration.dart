import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:poseimageestimation/utils/constant.dart';

class HomeScreen extends StatelessWidget {
  calculation() {
    double total = (29 / 30) * 100;
    total = total / 100;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
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
                    "AP Chemistry",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "9:45 - 10:45am · Room 1D",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      radius: 150,
                      lineWidth: 10,
                      percent: calculation(),
                      progressColor: AppColor.yellowtext,
                      backgroundColor: AppColor.yellowtext.withOpacity(0.3),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.science, color: Colors.orange, size: 40),
                          SizedBox(height: 10),
                          Text(
                            "15:27",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text("Share"),
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.science, color: Colors.orange, size: 40),
                        SizedBox(height: 10),
                        Text(
                          "15:27",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Share"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Today",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    ListTile(
                      leading: Icon(Icons.calculate, color: Colors.orange),
                      title: Text("Calculus BC"),
                      subtitle: Text("10:50 - 11:30am · Room 1D"),
                    ),
                    ListTile(
                      leading: Icon(Icons.lunch_dining, color: Colors.green),
                      title: Text("Lunch"),
                      subtitle: Text("11:35 - 12:15pm"),
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
