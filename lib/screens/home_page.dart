import 'package:flutter/material.dart';
import 'package:forecast_master/utils/consts.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName('Hyderabad').then((w) {
      setState(() {
        _weather = w;
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [


      SingleChildScrollView(
        child: SizedBox(

          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height, child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            _locationheader(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            _datetimeinfo(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            _weathericon(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            _currenttemp(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            _extrainfo(),





        ],),
        ),
      ),
    ]
    );
  }
  Widget _locationheader() {
    return Text(_weather?.areaName ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),);

  }

  Widget _datetimeinfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(DateFormat("h:mm a ").format(now), style: TextStyle(fontSize: 35),),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat("EEEE").format(now), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
            Text("  ${DateFormat("d.m.y").format(now)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),


          ],
        )

      ],
    );
  }
  Widget _weathericon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.2,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage("http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))
          ),
        ),
        Text(_weather?.weatherDescription ?? "", style: TextStyle(
          fontSize: 20
        ),)

      ],
    );
  }
  Widget _currenttemp() {
    return Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C", style: TextStyle(
      fontSize: 90,
      fontWeight: FontWeight.w500
    ),);
  }
  Widget _extrainfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width:  MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C", style: TextStyle(
                fontSize: 15,
                  color: Colors.white
              ),),
              Text("Max: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C", style: TextStyle(
                  fontSize: 15,
                  color: Colors.white
              ),)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s", style: TextStyle(
                color: Colors.white,
                  fontSize: 15
              ),),
              Text("Humidity: ${_weather?.humidity?.toStringAsFixed(0)} %", style: TextStyle(
                  fontSize: 15,
                  color: Colors.white
              ),)
            ],
          ),

        ],
      ),
    );
  }
}


