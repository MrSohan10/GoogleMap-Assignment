import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _googleMapController;
  late StreamSubscription _locationSubscription;
  final Location _location = Location();
  LocationData? _initialLocation;
  LocationData? _currentLocation;
  List<LatLng> _pathPoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoogleMap'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _googleMapController = controller;
          getInitialLocation();
          getCurrentLocation();
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(_initialLocation?.latitude ?? 23.812092840505958,
              _initialLocation?.longitude ?? 90.41354404593507),
          zoom: 17,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
              markerId: const MarkerId('this is marker'),
              infoWindow: InfoWindow(
                  title: 'my current location',
                  snippet:
                      '${_currentLocation?.latitude ?? ''}  ${_currentLocation?.longitude ?? ''}'),
              position: LatLng(_currentLocation?.latitude ?? 23.812092840505958,
                  _currentLocation?.longitude ?? 90.41354404593507))
        },
        polylines: {
          Polyline(
              polylineId: const PolylineId('this is polyline'),
              color: Colors.blue,
              endCap: Cap.roundCap,
              startCap: Cap.roundCap,
              width: 4,
              points: _pathPoints)
        },
      ),
    );
  }

  Future<void> getInitialLocation() async {
    _initialLocation = await _location.getLocation();
    if (mounted) {
      setState(() {});
    }
    if (_initialLocation == null) {
      return;
    }
    _googleMapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_initialLocation!.latitude!, _initialLocation!.longitude!),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      _currentLocation = locationData;
      _pathPoints.add(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!));
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }
}
