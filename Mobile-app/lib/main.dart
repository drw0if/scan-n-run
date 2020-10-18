import 'package:flutter/material.dart';
import 'package:Code_io/SplashScreen.dart';



// creo la classe principale che farà comparire lo splashscreen prima di entrare nella visualizzazione a mappa
void main() => runApp(new MaterialApp(
  theme: ThemeData(
      primarySwatch: Colors.red, accentColor: Colors.yellowAccent),
  debugShowCheckedModeBanner: false,
  home: SplashScreen(),
));

