import 'package:flutter/material.dart';
import 'package:forecast_master/screens/home_page.dart';
import 'package:forecast_master/screens/search_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'week_forcast.dart';

class bottom_nav extends StatefulWidget {
  const bottom_nav();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<bottom_nav> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    homepage(),
    WeatherSearchPage(),
    // new_screen(),
     // Add your other pages here
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Forecast',
          style: GoogleFonts.poppins().copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF93A3B1).withOpacity(0.5),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF93A3B1).withOpacity(0.5),
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        elevation: 0, // Remove the black shadow
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}