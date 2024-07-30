// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HOS extends StatefulWidget {
  const HOS({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HOSState createState() => _HOSState();
}

class _HOSState extends State<HOS> {
  late GoogleMapController _controller;
  late Position _currentPosition;
  final Set<Marker> _markers = {};
  final String _googleAPIKey = 'AIzaSyBWtRd8hzTy8nXQqIy3qAh-gPF7uvVamqs';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });
    _getNearbyHospitals();
  }

  _getNearbyHospitals() async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition.latitude},${_currentPosition.longitude}&radius=2000&type=hospital&key=$_googleAPIKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      setState(() {
        _markers.removeWhere(
            (marker) => marker.markerId.value != 'currentLocation');
        for (var result in results.take(10)) {
          _markers.add(Marker(
            markerId: MarkerId(result['place_id']),
            position: LatLng(result['geometry']['location']['lat'],
                result['geometry']['location']['lng']),
            infoWindow: InfoWindow(title: result['name']),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ));
        }
      });
      // Start the timer to send email after 10 seconds
      Timer(const Duration(seconds: 10), _sendEmail);
    }
  }

  _sendEmail() async {
    const url =
        'http://10.70.5.184:5000/send-email'; // Replace with your server IP or localhost if testing locally
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "receiver_email": "chalasaniajitha@gmail.com",
        "name": "Ajitha",
        "coordinates": {
          "latitude": "${_currentPosition.latitude}",
          "longitude": "${_currentPosition.longitude}"
        }
      }),
    );

    if (response.statusCode == 200) {
      _showPopupMessage('Email sent successfully');
    } else {
      _showPopupMessage('Failed to send email: ${response.body}');
    }
  }

  _showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Hospitals'),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          // ignore: unnecessary_null_comparison
          target: _currentPosition != null
              ? LatLng(_currentPosition.latitude, _currentPosition.longitude)
              : const LatLng(0, 0),
          zoom: 15.0,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
