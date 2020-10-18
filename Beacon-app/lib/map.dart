import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapScreen extends StatefulWidget {
  String username;
  MapScreen(this.username);

  @override
  State<StatefulWidget> createState() {
    return new MapScreenState(username);
  }
}

class MapScreenState extends State<MapScreen> {


  TextEditingController usernameController = TextEditingController();
  int _state = 0;
  String username;
  MapScreenState(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(decoration: BoxDecoration(color: Colors.white)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(top:80, left: 30, right: 30),
                child: Text("Installation Instrunction", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold,)),
              ),

              Padding(
                padding: EdgeInsets.only(top:80, left: 30, right: 30),
                child: Text("Press on Map to install the Station with ID: $username", style: TextStyle(color: Colors.black, fontSize: 30,)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child:               GestureDetector(
                  onTap: _showMyDialog,
                  child: Image.asset('assets/map.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )





            ],
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Installation Settings'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to install the station in this location?'),
                Text('If yes, click "Ok", otherwise press "Dismiss".'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
