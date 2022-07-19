import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/home/home_page.dart';
import 'package:flutter_video_cut/app/shapes/track_shape.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Cut',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'BalsamiqSans',
        scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
        primarySwatch: Colors.amber,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.amber),
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
          trackShape: TrackShape(),
          inactiveTrackColor: const Color.fromARGB(100, 255, 255, 255),
        ),
      ),
      home: const HomePage(),
    );
  }
}
