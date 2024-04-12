import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'bottom_nav.dart'; // Import your bottom nav bar page

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to the bottom nav bar page after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => bottom_nav()),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF93A3B1).withOpacity(0.9), // Change to your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your icon
            Image.asset('assets/imgs/weather-app.png'),

            SizedBox(height: 20),
            // Circular progress indicator
            CircularProgressIndicator(
              color: Colors.white, // Change to your desired progress indicator color
            ),
          ],
        ),
      ),
    );
  }
}
