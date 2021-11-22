import 'package:aplikacja_z_kursu/AirScreen.dart';
import 'package:aplikacja_z_kursu/SplashScreen.dart';
import 'package:aplikacja_z_kursu/WeatherScreen.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({this.weather, this.air});

  final Weather weather;
  final AirQuality air;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex = 1;
  var screens;

  @override
  void initState() {
      screens = [
      AirScreen(air: widget.air),
      WeatherScreen(weather: widget.weather),
    ];
      super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 38,
        currentIndex: _currentIndex, // pokazuje wskazany element (0 - pierwszy element na liście nawigacji itd)
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem( icon: Image.asset("icons/house.png"), label: "Powietrze", activeIcon: Image.asset("icons/house-checked.png")),
          BottomNavigationBarItem( icon: Image.asset("icons/cloud.png"), label: "Pogoda", activeIcon: Image.asset("icons/cloud-checked.png")),
        ],
      ),
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}