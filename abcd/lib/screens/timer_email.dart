import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'hospital.dart'; // Import the HOS page
import 'location.dart'; // Import the HomeScreen

class TimerPage extends StatefulWidget {
  final LatLng? coordinates;

  TimerPage({this.coordinates});

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
          sendEmailRequest();
          navigateToHospitalMailPage();
        }
      });
    });
  }

  Future<void> sendEmailRequest() async {
    const url =
        'http://10.70.5.184:5000/send-email'; // Replace with your Flask API URL
    const receiverEmail = 'chalasaniajitha@gmail.com';
    const name = 'John Doe';
    final coordinates = {
      'latitude': widget.coordinates?.latitude.toString(),
      'longitude': widget.coordinates?.longitude.toString(),
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'receiver_email': receiverEmail,
        'name': name,
        'coordinates': coordinates,
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email');
    }
  }

  void navigateToHospitalMailPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => HOS()), // Ensure this import is correct
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
            border: Border.all(width: 10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  'EMERGENCY ALERT\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
              Text(
                'Seconds Remaining',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                countdown.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE52A2D),
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  _timer.cancel();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFE52A2D),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
