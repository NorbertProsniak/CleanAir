import 'dart:convert';
import 'dart:developer';

import 'package:aplikacja_z_kursu/MyHomePage.dart';
import 'package:aplikacja_z_kursu/PermissionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // powoduje przejscie do nastepnego ekranu
    return Scaffold(
      body: Stack(
          fit: StackFit.expand, // wybiera najwiekszy mozliwy rozmiar dla dzieci
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: new Color(0xffffffff),
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [new Color(0xff6671e5), new Color(0xff4852d9)])),
            ),
            Align(
                // wyrownuje do srodka (przyciaga do czegos, tutaj do srodka)
                alignment: FractionalOffset.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('icons/cloud-sun.png')),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    Text(Strings.appTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 42.0,
                          color: Colors.white,
                        ))),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    Text('Aplikacja do monitorowania \n czystości powietrza',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ))),
                  ],
                )),
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PermissionScreen()));
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        executeOnceAfterBuild();
      });
    }
  }

  void executeOnceAfterBuild() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.lowest,
            forceAndroidLocationManager: true,
            timeLimit: Duration(seconds: 5))
        .then((value) => {loadLocationData(value)})
        .onError((error, stackTrace) =>{
            Geolocator.getLastKnownPosition(forceAndroidLocationManager: true)
                .then((value) => {loadLocationData(value)})
  });
}

  loadLocationData(Position value) async {
    var lat = value.latitude;
    var lon = value.longitude;

    WeatherFactory wf = new WeatherFactory("5c316189a5aec9c238717769038ccfa9",
        language: Language.POLISH);
    Weather w = await wf.currentWeatherByLocation(lat, lon);
    log(w.toJson().toString());

    var keyword = 'geo:$lat;$lon';
    String _endpoint = 'https://api.waqi.info/feed/';
    var key = '934ca358c129a8fc09239c796b0aade3b96ccc4f';
    String url = '$_endpoint/$keyword/?token=$key';
    http.Response response = await http.get(Uri.parse(url));
    log(response.body.toString());

    Map<String, dynamic> jsonBody = json.decode(response.body);
    AirQuality aq = new AirQuality(jsonBody);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(weather: w, air: aq)));
  }
}

class AirQuality {
  bool isGood = false;
  bool isBad = false;
  String quality = "";
  String advice = "";
  int aqi = 0;
  int pm25 = 0;
  int pm10 = 0;
  String station = "";

  AirQuality(Map<String, dynamic> jsonBody) {
    aqi = int.tryParse(jsonBody['data']['aqi'].toString()) ?? -1;
    pm25 = int.tryParse(jsonBody['data']['iaqi']['pm25']['v'].toString()) ?? -1;
    pm10 = int.tryParse(jsonBody['data']['iaqi']['pm10']['v'].toString()) ?? -1;
    station = jsonBody['data']['city']['name'].toString();
    setupLevel(aqi);
  }

  void setupLevel(intaqi) {
    if (aqi <= 100) {
      quality = "Bardzo dobra";
      advice = "Skorzystaj z dobrzego powietrza i idź na spcer";
      isGood = true;
    } else if (aqi <= 150) {
      quality = "Nie za dobra";
      advice = "Jeśli możesz to zostań w domu";
      isBad = true;
    } else {
      quality = "Bardzo zła!";
      advice = "Zostań w domu!";
    }
  }
}
