import 'package:aplikacja_z_kursu/MyHomePage.dart';
import 'package:aplikacja_z_kursu/PermissionScreen.dart';
import 'package:flutter/material.dart';

import 'SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class Strings{
  static const String appTitle = 'Clean Air';
}