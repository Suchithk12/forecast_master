import 'package:flutter/material.dart';
import 'package:ForecastWise/screens/bottom_nav.dart';
import 'package:ForecastWise/screens/home_page.dart';
import 'package:ForecastWise/screens/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

      home: LandingPage(),
      debugShowCheckedModeBanner: false,

    );
  }
}

