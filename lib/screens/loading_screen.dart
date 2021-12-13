import 'package:clima/screens/weather_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLocationEnabled = true;

  @override
  void initState() {
    try {
      getLocationData().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return WeatherScreen(value);
          })));
    } catch (e) {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLocationEnabled
            ? SpinKitDoubleBounce(
                color: Colors.white,
                size: 100,
              )
            : Text('Please Enable Location'),
      ),
    );
  }

  Future<dynamic> getLocationData() async {
    try {
      var weatherData = await WeatherModel().getLocationWeather();
      return weatherData;
    } catch (e) {
      setState(() {
        isLocationEnabled = false;
      });
      throw Exception();
    }
  }
}
