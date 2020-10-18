import 'package:flutter/material.dart';
import 'package:SmartMap_Fix/SplashScreen.dart';

void main() => runApp(new MaterialApp(
  theme: ThemeData(
      primarySwatch: Colors.red, accentColor: Colors.yellowAccent),
  debugShowCheckedModeBanner: false,
  home: SplashScreen(),
));