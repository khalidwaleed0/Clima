import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

import 'city_screen.dart';

class WeatherScreen extends StatefulWidget {
  var weatherData;
  WeatherScreen(this.weatherData);
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherModel weatherModel = WeatherModel();
  int temp = 0;
  int humidity = 0;
  int windSpeed = 0;
  String description = '';
  String cityName = '';
  String weatherIcon = 'Error';
  String tempMessage = 'internet or location is disabled';
  void updateUI() {
    setState(() {
      int condition = widget.weatherData['weather'][0]['id'];
      humidity = widget.weatherData['main']['humidity'];
      windSpeed = (widget.weatherData['wind']['speed'] * 3.6).toInt();
      description = widget.weatherData['weather'][0]['description'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      temp = widget.weatherData['main']['temp'].toInt();
      tempMessage = weatherModel.getMessage(temp);
      cityName = widget.weatherData['name'];
    });
  }

  @override
  void initState() {
    updateUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        widget.weatherData = await weatherModel.getLocationWeather();
                        updateUI();
                      } catch (e) {
                        final snackBar = SnackBar(content: Text('Error: Location is disabled.'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var selectedCity = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      try {
                        widget.weatherData = await weatherModel.getCityWeather(selectedCity);
                        updateUI();
                      } catch (e) {
                        final snackBar = SnackBar(content: Text('Error: couldn\'t find this city.'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          '$temp°',
                          style: kTempTextStyle,
                        ),
                        Text(
                          weatherIcon,
                          style: kConditionTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      '$description',
                      style: kDescriptionTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    Center(
                        child: Column(children: [
                      Text('Humidity : $humidity%', style: kDetailsTextStyle),
                      Text('Wind Speed : $windSpeed km/h', style: kDetailsTextStyle),
                    ])),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, bottom: 15),
                child: Text(
                  '$tempMessage in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
