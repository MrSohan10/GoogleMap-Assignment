import 'package:flutter/material.dart';
import 'package:google_map_assignment/screen/home_screen.dart';


class GoogleMap extends StatelessWidget {
  const GoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Google Map Assignment",
      home: HomeScreen(),
    );
  }
}

