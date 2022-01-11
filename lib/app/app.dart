import 'package:flutter/material.dart';

import 'screens/home/home_page.dart';
import 'shared/shapes/custom_track_shape.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Cut',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
        fontFamily: 'BalsamiqSans',
        primarySwatch: Colors.amber,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white38,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white38,
          ),
        ),
        sliderTheme: SliderThemeData(
          trackShape: CustomTrackShape(),
          inactiveTrackColor: const Color.fromARGB(100, 255, 255, 255),
        ),
      ),
      home: const HomePage(),
    );
  }
}
