import 'package:flutter/material.dart';
import 'package:forecast_master/screens/week_forcast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import '../utils/consts.dart';

class wheather_detail extends StatefulWidget {
  final String city;
  const wheather_detail({Key? key, required this.city}) : super(key: key);

  @override
  State<wheather_detail> createState() => _wheather_detailState();
}

class _wheather_detailState extends State<wheather_detail> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  List<Weather>? _forecast;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    final weather = await _wf.currentWeatherByCityName(widget.city);
    setState(() {
      _weather = weather;
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
        child: Center(
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
                builder: (context) =>
                    week_forcast(city: _weather!.areaName ??
                        'Unknown'), // Provide a default value or handle null city names
              ),
            );
          },
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.85,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery
                      .sizeOf(context)
                      .height * 0.1,
                ),
                Card(
                  elevation: 15,
                  color: Color(0xFF93A3B1).withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _weathericon(),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02),
                        _locationheader(),
                        _currenttemp(),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.01),
                        _extrainfo(),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _locationheader() {
    return Text(
      _weather?.areaName ?? "",
      style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w500),
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
      customImagePath =
      'assets/imgs/sunny.png'; // Default image for unknown conditions
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(customImagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(capitalize(_weather?.weatherDescription ?? ""),
            style: GoogleFonts.poppins(
                fontSize: 30, fontWeight: FontWeight.bold
            )),
      ],
    );
  }

  Widget _currenttemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: GoogleFonts.poppins(fontSize: 80, fontWeight: FontWeight.w500),
    );
  }

  Widget _extrainfo() {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(25),
      //   color: Color(0xFF93A3B1).withOpacity(0.5),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.2),
      //       spreadRadius: 2,
      //       blurRadius: 5,
      //       offset: Offset(0, 3),
      //     ),
      //   ],
      // ),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.15,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.80,
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
                style: GoogleFonts.poppins(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                style: GoogleFonts.poppins(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: GoogleFonts.poppins(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)} %",
                style: GoogleFonts.poppins(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
        ],
      ),
    );
  }
}
