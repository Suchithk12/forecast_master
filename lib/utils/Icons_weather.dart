import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String weatherCode;

  const WeatherIcon({Key? key, required this.weatherCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String customImagePath = _getWeatherImagePath(weatherCode);
    return Image.asset(customImagePath);
  }

  String _getWeatherImagePath(String weatherCode) {
    if (weatherCode.startsWith('2')) {
      return 'assets/imgs/thunder.png'; // Image for thunderstorm
    } else if (weatherCode.startsWith('3')) {
      return 'assets/imgs/drizzle.png'; // Image for drizzle
    } else if (weatherCode.startsWith('5')) {
      return 'assets/imgs/rainy.png'; // Image for rain
    } else if (weatherCode.startsWith('6')) {
      return 'assets/imgs/snow.png'; // Image for snow
    } else if (weatherCode.startsWith('7')) {
      return 'assets/imgs/atmosphere.png'; // Image for atmosphere
    } else if (weatherCode == '800') {
      return 'assets/imgs/cloudy.png'; // Image for clear sky
    } else if (weatherCode.startsWith('8')) {
      return 'assets/imgs/cloudy.png'; // Image for clouds
    } else {
      return 'assets/imgs/sunny.png'; // Default image for unknown conditions
    }
  }
}
