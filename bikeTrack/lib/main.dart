import 'package:bikeTrack/screens/history_screen.dart';
import 'package:bikeTrack/screens/splash_screen.dart';
import 'package:bikeTrack/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/authentication.dart';

void main() {
  runApp(MyApp());

  /* SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.values.first]); */
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Authentication(),
          ),
          ChangeNotifierProvider(
              create: (context) => DatabaseHelper.instance,
              child: HistoryScreen())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: Splash_Screen(),
        ));
  }
}
