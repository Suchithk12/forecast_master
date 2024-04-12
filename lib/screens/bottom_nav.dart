import 'package:flutter/material.dart';
import 'package:forecast_master/screens/home_page.dart';
import 'package:forecast_master/screens/search_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

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
        items:  [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/Vectorhome-icon.svg',color: _currentIndex == 0 ? Color(0xFF93A3B1).withOpacity(1) : Colors.grey,),

            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/search-bar-search.svg',color: _currentIndex == 0 ? Color(0xFF93A3B1).withOpacity(1) : Colors.grey,),
            label: 'Search',
          ),
          // Add more items as needed
        ],
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold), // Adjust the selected label style as needed
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.normal),
      ),
    );
  }
}