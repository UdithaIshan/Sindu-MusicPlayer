// Uditha Ishan @2020

import 'package:flutter/material.dart';
import 'sindu_home.dart';

void main() => runApp(SinduApp());

class SinduApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff001646),
        scaffoldBackgroundColor: Color(0xff001646),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.white,
            backgroundColor: Color(0xFF000020),
        ),
      ),
      home: SafeArea(
          child: SinduHome()
      )
    );
  }
}


