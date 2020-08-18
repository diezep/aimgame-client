import 'package:aimgame/src/pages/game_page.dart';
import 'package:aimgame/src/pages/index_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // Dart client

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          buttonColor: ColorPalette.accent,
          textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white),
              headline2: TextStyle(
                  letterSpacing: 1.3,
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold))),
      routes: {
        IndexPage.routeName: (context) => IndexPage(),
        GamePage.routeName: (context) => GamePage()
      },
    );
  }
}

class ColorPalette {
  static const background = Color(0xff352C4D);
  static const accent = Color(0xffE23268);
}
