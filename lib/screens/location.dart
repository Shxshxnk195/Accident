import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'timer.dart'; // Import the TimerPage

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool gpsEnabled = false;
  bool permissionGranted = false;
  l.Location location = l.Location();
  late StreamSubscription<l.LocationData> subscription;
  GoogleMapController? mapController; // Change to nullable
  Marker? userMarker;
  LatLng? lastKnownPosition;

  @override
  void initState() {
    super.initState();
    loadLastKnownLocation();
    checkStatus();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: permissionGranted
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: lastKnownPosition ?? LatLng(0, 0),
                      zoom: 15.0,
                    ),
                    markers: userMarker != null ? {userMarker!} : {},
                    onMapCreated: (controller) {
                      mapController = controller;
                      if (userMarker != null) {
                        // Reposition map to user's marker
                        mapController?.animateCamera(
                            CameraUpdate.newLatLng(userMarker!.position));
                      }
                    },
                  )
                : Center(child: Text('Requesting location permission...')),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TimerPage(),
                  ),
                );
              },
              child: const Text('Trigger Action'),
            ),
          ),
        ],
      ),
    );
  }

  void checkStatus() async {
    bool permissionGranted = await isPermissionGranted();
    if (permissionGranted) {
      bool gpsEnabled = await isGpsEnabled();
      if (gpsEnabled) {
        startTracking();
      } else {
        bool isGpsActive = await location.requestService();
        setState(() {
          gpsEnabled = isGpsActive;
          if (gpsEnabled) {
            startTracking();
          }
        });
      }
    } else {
      await requestLocationPermission();
    }
  }

  Future<bool> isPermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  Future<bool> isGpsEnabled() async {
    return await location.serviceEnabled();
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();
    setState(() {
      permissionGranted = permissionStatus == PermissionStatus.granted;
    });
    if (permissionGranted) {
      checkStatus(); // Recheck status after permission is granted
    }
  }

  void startTracking() async {
    subscription = location.onLocationChanged.listen((event) {
      updateLocation(event);
    });
  }

  void stopTracking() {
    subscription.cancel();
  }

  void updateLocation(l.LocationData data) async {
    LatLng newPosition = LatLng(data.latitude!, data.longitude!);
    setState(() {
      userMarker = Marker(
        markerId: const MarkerId('userMarker'),
        position: newPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      lastKnownPosition = newPosition;
    });

    // Check if mapController is initialized before using it
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(newPosition));
      saveLastKnownLocation(newPosition);
    }
  }

  Future<void> saveLastKnownLocation(LatLng position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', position.latitude);
    await prefs.setDouble('longitude', position.longitude);
  }

  Future<void> loadLastKnownLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble('latitude');
    final longitude = prefs.getDouble('longitude');
    if (latitude != null && longitude != null) {
      setState(() {
        lastKnownPosition = LatLng(latitude, longitude);
      });
    }
  }
}
