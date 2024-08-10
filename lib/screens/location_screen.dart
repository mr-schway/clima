import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  const LocationScreen({super.key, this.locationWeather});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int? temperature;
  String? cityName;
  late Widget weatherIcon;
  String? weatherMessage;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        cityName = '';
        weatherIcon = const Text('Error');
        weatherMessage = 'unable to get weather data';
        return;
      }
      var temp = weatherData['main']['temp'];
      temperature = (temp).toInt();
      cityName = weatherData['name'];
      int condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    var weatherData = await weather.getLocationWeather();
                    updateUI(weatherData);
                  },
                  child: const Icon(
                    Icons.near_me,
                    size: 50.0,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    var typedName = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CityScreen();
                        },
                      ),
                    );
                    if (typedName != null) {
                      var weatherData = await weather.getCityWeather(typedName);
                      updateUI(weatherData);
                    }
                    print(typedName);
                  },
                  child: const Icon(
                    Icons.location_city,
                    size: 50.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '$temperature°',
                    style: kTempTextStyle,
                  ),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: weatherIcon,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                '$weatherMessage in $cityName',
                textAlign: TextAlign.center,
                style: kMessageTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
