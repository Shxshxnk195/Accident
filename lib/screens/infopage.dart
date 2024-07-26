import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'location.dart'; // Correct import for HomeScreen

class Infare extends StatefulWidget {
  const Infare({super.key});

  @override
  _InfareState createState() => _InfareState();
}

class _InfareState extends State<Infare> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 155, 157),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    'How to',
                    style: GoogleFonts.hammersmithOne(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 40.0,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    'Connect',
                    style: GoogleFonts.hammersmithOne(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 40.0,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    color: const Color.fromARGB(52, 0, 0, 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/Image placeholder.png',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut ',
                            style: GoogleFonts.gothicA1(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    color: const Color.fromARGB(52, 0, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut ',
                        style: GoogleFonts.gothicA1(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomeScreen()), // Navigate to HomeScreen
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 90, vertical: 10),
                    ),
                    child: Text(
                      'OK',
                      style: GoogleFonts.gothicA1(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
