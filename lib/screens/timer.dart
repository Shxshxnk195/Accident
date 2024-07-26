import 'dart:async';

import 'package:flutter/material.dart';

import 'hospital_mail.dart'; // Ensure this import is correct
import 'location.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int countdown = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          _timer.cancel();
          navigateToHospitalMailPage();
        }
      });
    });
  }

  void navigateToHospitalMailPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => MyApp()), // Ensure this import is correct
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(45),
            border: Border.all(
              width: 10,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: ShapeDecoration(
                            color: Color(0xFFE52A2D),
                            shape: StarBorder.polygon(sides: 3),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 78,
                        top: 99,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 78,
                        top: 43,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 100.87,
                        top: 89.80,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, 0.0)
                            ..rotateZ(3.12),
                          child: Container(
                            width: 22,
                            height: 38.81,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: StarBorder.polygon(sides: 3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.55,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Text(
                  'An Accident has been detected!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'Hammersmith One',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                left: screenWidth * 0.25,
                right: screenWidth * 0.25,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(), // Go back to HomeScreen
                      ),
                    );
                  },
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Color(0xFFE52A2D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel ($countdown)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Hammersmith One',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
