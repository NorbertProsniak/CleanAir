import 'package:aplikacja_z_kursu/MyHomePage.dart';
import 'package:aplikacja_z_kursu/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Stack(fit: StackFit.expand,
          // wybiera najwiekszy mozliwy rozmiar dla dzieci
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
                    Image(image: AssetImage('icons/hand-wave.png')),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    Text("Hej!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                          color: Colors.white,
                        ))),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    Text(
                        'Aplikacja ${Strings.appTitle} potrzebuje do działania \n przybliżonej lokalizacji urządzenia',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ))),
                  ],
                )),
            Positioned(
                // ustawienie do dolu (wypozycjonowany w stosunku do czegos)
                left: 0,
                right: 0,
                bottom: 35,
                child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(top: 12.0, bottom: 12.0),
                            ),
                          ),
                          child: Text(
                            'Zgoda!',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          onPressed: () async {
                            LocationPermission permission =
                                await Geolocator.requestPermission();
                            if (permission == LocationPermission.always ||
                                permission == LocationPermission.whileInUse)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SplashScreen()));
                          },
                        ))))
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
