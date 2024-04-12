import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ForecastWise/screens/week_forcast.dart';
import 'package:ForecastWise/utils/consts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:collection/collection.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  List<Weather>? _forecast;
  

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName('Toronto').then((w) {
      setState(() {
        _weather = w;
      });
    });
    _wf.fiveDayForecastByCityName('Hyderabad').then((f) {
      setState(() {
        _forecast = f;
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildUI(),
    );
  }
  Widget _buildUI() {

    if (_weather == null) {
      return Container(
        color: Color(0xFF93A3B1).withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      color: Color(0xFF93A3B1).withOpacity(0.5),
      child: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to the WeekForecast screen when the card is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => week_forcast(city: _weather!.areaName ?? "Unknown"), // Pass the city name to the WeekForecast screen
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Card(
              elevation: 15,
              color: Color(0xFF93A3B1).withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _weathericon(),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.01,
                          ),
                          _locationheader(),
                          _currenttemp(),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.01,
                          ),
                          _extrainfo(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text("Tap To View This Week's Weather", style: GoogleFonts.poppins().copyWith(
                                color: Colors.white,
                                fontSize: 12
                              ),),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_circle_right),
                              )
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.01,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationheader() {
    return Text(_weather?.areaName ?? "", style:  GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w500),);

  }

  Widget _datetimeinfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(DateFormat("h:mm a ").format(now), style: GoogleFonts.poppins(fontSize: 35),),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat("EEEE").format(now), style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),),
            Text("  ${DateFormat("d.m.y").format(now)}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),),


          ],
        )

      ],
    );
  }
  Widget _weathericon() {
    String capitalize(String s) {
      List<String> words = s.split(' ');
      words = words.map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1);
      }).toList();
      return words.join(' ');
    }

    String customImagePath;
    String weatherCode = _weather?.weatherConditionCode.toString() ?? "";

    // Map each weather code to its corresponding image
    if (weatherCode.startsWith('2')) {
      customImagePath = 'assets/imgs/thunder.png'; // Image for thunderstorm
    } else if (weatherCode.startsWith('3')) {
      customImagePath = 'assets/imgs/drizzle.png'; // Image for drizzle
    } else if (weatherCode.startsWith('5')) {
      customImagePath = 'assets/imgs/rainy.png'; // Image for rain
    } else if (weatherCode.startsWith('6')) {
      customImagePath = 'assets/imgs/snow.png'; // Image for snow
    } else if (weatherCode.startsWith('7')) {
      customImagePath = 'assets/imgs/atmosphere.png'; // Image for atmosphere
    } else if (weatherCode == '800') {
      customImagePath = 'assets/imgs/sunny.png'; // Image for clear sky
    } else if (weatherCode.startsWith('8')) {
      customImagePath = 'assets/imgs/cloudy.png'; // Image for clouds
    } else {
      customImagePath = 'assets/imgs/sunny.png'; // Default image for unknown conditions
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(customImagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(capitalize(_weather?.weatherDescription ?? ""), style: GoogleFonts.poppins(
            fontSize: 30, fontWeight: FontWeight.bold
        )),
      ],
    );
  }


  Widget _currenttemp() {
    return Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C", style: GoogleFonts.poppins(
      fontSize: 80,
      fontWeight: FontWeight.w500
    ),);
  }
  Widget _buildWeeklyForecast() {
    if (_forecast == null) {
      return Text('No data available'); // Show loading indicator if forecast data is null
    }

    return Column(
      children: _forecast!.map((weather) {
        final date = DateTime.fromMillisecondsSinceEpoch(weather.date!.millisecondsSinceEpoch);
        final temperature = weather.temperature?.celsius?.toStringAsFixed(0) ?? 'N/A'; // Use null safety to avoid accessing null values
        final description = weather.weatherDescription ?? 'N/A'; // Use null safety to avoid accessing null values
        return ListTile(
          title: Text(DateFormat('EEEE').format(date)),
          subtitle: Text('$temperature°C - $description'),
        );
      }).toList(),
    );
  }

  Widget _extrainfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(25),
      //   color: Color(0xFF93A3B1).withOpacity(0.5),
      // ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
                style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)} %",
                style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold,  color: Colors.white),
              )
            ],
          ),
        ],
      ),
    );
  }




}




