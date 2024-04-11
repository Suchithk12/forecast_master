import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';

import '../utils/Icons_weather.dart';
import '../utils/consts.dart';

class week_forcast extends StatefulWidget {
  final String city;
  const week_forcast({Key? key, required this.city}) : super(key: key);

  @override
  State<week_forcast> createState() => _week_forcastState();
}

class _week_forcastState extends State<week_forcast> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  List<Weather>? _forecast;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    final weather = await _wf.fiveDayForecastByCityName(widget.city);
    setState(() {
      _forecast = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast for ${widget.city}',
          style: GoogleFonts.poppins().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),),
        backgroundColor: Color(0xFF93A3B1).withOpacity(0.5),
      ),
      body: _buildForecast(),
    );
  }

  Widget _buildForecast() {
    if (_forecast == null) {
      return Container(
          color: Color(0xFF93A3B1).withOpacity(0.5),
          child: Center(child: CircularProgressIndicator()));
    }

    // Group forecast data by date
    Map<String, List<Weather>> dailyForecast = {};
    for (Weather weather in _forecast!) {
      String date = _getFormattedDate(weather.date!);
      if (!dailyForecast.containsKey(date)) {
        dailyForecast[date] = [];
      }
      dailyForecast[date]!.add(weather);
    }

    return Container(
      color: Color(0xFF93A3B1).withOpacity(0.5),
      // height: 150, // Adjust the height of the forecast cards
      child: ListView.builder(
        scrollDirection: Axis.vertical, // Horizontal scroll direction
        itemCount: dailyForecast.length,
        itemBuilder: (context, index) {
          String date = dailyForecast.keys.elementAt(index);
          List<Weather> weatherList = dailyForecast[date]!;
          Weather weather = weatherList.first; // Assuming the first weather data represents the day
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  WeatherIcon(weatherCode: weather.weatherConditionCode.toString() ?? ""),
                  SizedBox(height: 10),
                  Text(
                    '${weather.temperature?.celsius}°C',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  String _getFormattedDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}