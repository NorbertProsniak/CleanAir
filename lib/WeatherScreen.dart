import 'package:aplikacja_z_kursu/MyHomePage.dart';
import 'package:aplikacja_z_kursu/PermissionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:intl/date_symbol_data_http_request.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class WeatherScreen extends StatefulWidget {

  WeatherScreen({this.weather});
  final Weather weather;

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
          fit: StackFit.expand, // wybiera najwiekszy mozliwy rozmiar dla dzieci
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                 gradient: getGradientByMood(widget.weather)
              )),
            Align(
              // wyrownuje do srodka (przyciaga do czegos, tutaj do srodka)
                alignment: FractionalOffset.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 45.0)),
                    Image(image: AssetImage('icons/${getIconByMood(widget.weather)}.png'),
                        color: Colors.white),
                    Padding(padding: EdgeInsets.only(top: 41.0)),
                    Text("${DateFormat.MMMMEEEEd('pl').format(DateTime.now())}, ${widget.weather.weatherDescription}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 14.0,
                        height: 1.2,
                        color: Colors.white,
                        fontWeight: FontWeight.w400
                      )
                    )),
                    Padding(padding: EdgeInsets.only(top: 41.0)),
                    Text('${widget.weather.temperature.celsius.floor().toString()}°C',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 64.0,
                                height: 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w700
                            )
                        )),
                    Text('Odczuwalna ${widget.weather.tempFeelsLike.celsius.floor().toString()}°C',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14.0,
                                height: 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w700
                            )
                        )),
                    Padding(padding: EdgeInsets.only(top: 24.0)),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Ciśnienie",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 14.0,
                                              height: 1.2,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700
                                          )
                                      )),
                                  Padding(padding: EdgeInsets.only(top:2.0)),
                                  Text("${widget.weather.pressure.floor().toString()} hPa",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 26.0,
                                              height: 1.2,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700
                                          )
                                      ))
                                ],
                              ),
                          ),
                          VerticalDivider(
                            width: 48,
                            color: Colors.white,
                            thickness: 1,
                          ),
                          Container(
                              width: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Wiatr",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 14.0,
                                              height: 1.2,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700
                                          )
                                      )),
                                  Padding(padding: EdgeInsets.only(top:2.0)),
                                  Text("${widget.weather.windSpeed} m/h",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 26.0,
                                              height: 1.2,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700
                                          )
                                      ))
                                ],
                              ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 24.0)),
                    if(widget.weather.rainLastHour != null)
                    Text ("Opady: $widget.weather.rainLastHour m/1h",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14.0,
                                height: 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w400
                            )
                        )),
                    Padding(padding: EdgeInsets.only(top: 68.0)),
                  ],
                )),
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  bool havePermission() {
    return true;
  }

  getIconByMood(Weather weather) {
    var main = weather.weatherMain;
    if(main == 'Clouds' || main == 'Drizzle' || main == "Snow"){
      return 'weather-rain';
    }else if(main == 'Thunderstorm'){
      return 'weather-lighting';
    } else if(isNight(weather)){
      return 'weather-moonny';
    }else{
      return 'weather-sunny';
    }
  }

  bool isNight(Weather weather) {
    return DateTime.now().isAfter(weather.sunset) || DateTime.now().isBefore(weather.sunrise);
  }

  LinearGradient getGradientByMood(Weather weather) {
    var main = weather.weatherMain;
    if(main=='Clouds' || main=='Drizzle' || main=="Snow"){
      return LinearGradient(
        begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors:[
    new Color(0xff6E6CD8),
    new Color(0xff40A0EF),
    new Color(0xff77E1EE),
      ]);
    }
      else if (main=='Thunderstorm' || isNight(weather)){
      return LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors:[
            new Color(0xffFFFFFF),
            new Color(0xffEFEFEF),
          ]);
    }
      else {
      return LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors:[
            new Color(0xff5283F0),
            new Color(0xffCDEDD4),
            new Color(0xff77E1EE),
          ]);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }
}

