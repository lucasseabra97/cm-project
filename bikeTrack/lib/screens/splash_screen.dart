import 'package:bikeTrack/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash_Screen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
            seconds: 3,
            navigateAfterSeconds: HomeScreen(),
            title: new Text(
              'BikeTrack',
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            image: Image.asset("assets/logo.png"),
            backgroundColor: Colors.amber,
            loadingText: Text("Getting Started"),
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            loaderColor: Colors.white)
      ],
    );
  }
}
