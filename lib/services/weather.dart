import 'package:clima/services/networking.dart';
import 'package:clima/services/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

const apiKey = '6ac1fc5026679b1519abf67ede6f410f';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    var url = '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    var weatherData;
    try {
      weatherData = await networkHelper.getData();
    } catch (e) {
      print("Failed to get weather data: $e");
      return null;
    }

    return weatherData;
  }

  Widget getWeatherIcon(int condition) {
    if (condition < 300) {
      return Lottie.asset('animations/thunderCloudy.json');
    } else if (condition < 400) {
      return Lottie.asset('animations/rainingSlow.json');
    } else if (condition < 600) {
      return Lottie.asset('animations/rainingFast.json');
    } else if (condition < 700) {
      return Lottie.asset('animations/snowing.json');
    } else if (condition < 800) {
      return Lottie.asset('animations/windy.json');
    } else if (condition == 800) {
      return Lottie.asset('animations/sunny.json');
    } else if (condition <= 804) {
      return Lottie.asset('animations/cloudy.json');
    } else {
      return Lottie.asset('animations/exclamationMark.json');
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
