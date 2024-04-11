import 'package:flutter/material.dart';
import 'package:forecast_master/screens/wheather_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/Icons_weather.dart';
import '../utils/consts.dart';

class WeatherSearchPage extends StatefulWidget {
  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  List<Map<String, dynamic>> _weatherDataList = [];




  @override
  void initState() {
    super.initState();
    _fetchWeatherForTopCities();
  }

  Future<void> _fetchWeatherForTopCities() async {

    for (String city in topCities) {
      final String apiUrl =
          'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$OPENWEATHER_API_KEY&units=metric';

      try {
        final response = await http.get(Uri.parse(apiUrl));
        final jsonData = json.decode(response.body);

        setState(() {
          _weatherDataList.add({
            'city': city,
            'weatherDescription': jsonData['weather'][0]['description'],
            'id': jsonData['weather'][0]['id'],
            'currentTemp': jsonData['main']['temp'],
            'maxTemp': jsonData['main']['temp_max'],
            'minTemp': jsonData['main']['temp_min'],
          });
        });
      } catch (error) {
        print('Error fetching weather data for $city: $error');
      }
    }
  }

  List<Map<String, dynamic>> _searchResults = [];

  void _searchCity(String query) {
    _searchResults.clear();
    _weatherDataList.forEach((weatherData) {
      if (weatherData['city'].toLowerCase().contains(query.toLowerCase())) {
        _searchResults.add(weatherData);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top 10 Cities Weather'),
        backgroundColor: Color(0xFF93A3B1).withOpacity(0.5),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: WeatherSearchDelegate(topCities),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF93A3B1).withOpacity(0.5),
        child: ListView.builder(
          itemCount: _searchResults.isEmpty
              ? _weatherDataList.length
              : _searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            final weatherData = _searchResults.isEmpty
                ? _weatherDataList[index]
                : _searchResults[index];
            return ListTile(
              leading: WeatherIcon(weatherCode: weatherData['id'].toString() ?? ""),
              title: Text(weatherData['city']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather: ${weatherData['weatherDescription']}',
                    style: TextStyle(),
                  ),
                  Text(
                    'Current Temperature: ${weatherData['currentTemp']}°C',
                  ),
                  Text(
                    'Max Temperature: ${weatherData['maxTemp']}°C',
                  ),
                  Text(
                    'Min Temperature: ${weatherData['minTemp']}°C',
                  ),
                ],
              ),
              onTap: () {
                // Navigate to the details page when a list item is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => wheather_detail(city: weatherData['city']),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class WeatherSearchDelegate extends SearchDelegate<String> {
  final List<String> topCities;

  WeatherSearchDelegate(this.topCities);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // This is where you can show search results if needed
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : topCities
        .where((city) =>
        city.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            // Navigate to the details page when a suggestion is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    wheather_detail(city: suggestionList[index]),
              ),
            );
          },
        );
      },
    );
  }
}