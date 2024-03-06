import 'package:flutter/material.dart';
import 'package:forecast_master/screens/home_page.dart';
import 'package:forecast_master/screens/search_screen.dart';

import 'new_screen.dart';

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
        title: Text('Weather Forecaster'),
        centerTitle: true,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search', // Replace with your label
          ),
          // Replace with your label

        ],
      ),
    );
  }
}