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
      child: Center(
        child: Container(
          // color: Color(0xFF93A3B1).withOpacity(0.5),
          width: MediaQuery
              .sizeOf(context)
              .width * 0.89, // Adjust the height of the forecast cards
          child: ListView.builder(
            scrollDirection: Axis.vertical, // Horizontal scroll direction
            itemCount: dailyForecast.length,
            itemBuilder: (context, index) {
              String date = dailyForecast.keys.elementAt(index);
              List<Weather> weatherList = dailyForecast[date]!;
              Weather weather = weatherList
                  .first; // Assuming the first weather data represents the day
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.12,
                  child: Card(
                    elevation: 15,
                    color: Color(0xFF93A3B1).withOpacity(0.5),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          // SizedBox(height: 10),
                          Container(
                              height: MediaQuery
                                  .sizeOf(context)
                                  .height * 0.2,
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width * 0.2,
                              child: WeatherIcon(
                                weatherCode: weather.weatherConditionCode
                                    .toString() ?? "",)),
                          // SizedBox(height: 10),

                          Text(
                            date,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              '${weather.temperature?.celsius?.toStringAsFixed(0)}°C',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 50),
                            ),
                          ),

                        ],
                      ),

                    ),

                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  String _getFormattedDate(DateTime date) {
    // Create a list of suffixes for the days
    List<String> suffixes = [
      'th',
      'st',
      'nd',
      'rd',
      'th',
      'th',
      'th',
      'th',
      'th',
      'th'
    ];

    // Get the day of the month
    int day = date.day;

    // Determine the suffix based on the last digit of the day
    String suffix = (day % 10 >= 1 && day % 10 <= 3 &&
        (day % 100 < 10 || day % 100 > 20))
        ? suffixes[day % 10]
        : 'th';

    // Format the date as "12th April", "13th April", etc.
    return '${day.toString()}$suffix ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}