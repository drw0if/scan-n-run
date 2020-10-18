import 'package:Code_io/Package_List.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class EndScreen extends StatefulWidget {
  String resultRelease;
  String username;
  EndScreen(this.resultRelease, this.username);

  @override
  State<StatefulWidget> createState() {
    return new EndScreenState(resultRelease, username);
  }
}

class EndScreenState extends State<EndScreen> {
  String resultRelease;
  String username;
  EndScreenState(this.resultRelease, this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Colors.blueAccent,
              width: 3.0,
            ),
          ),
          elevation: 6,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40, left: 40, right: 40),
                child: Text(
                  "Result",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                child: Text(
                  "You have correctly delivered the package to the deposit number $resultRelease. "
                  "Press the button to return to the pick up screen.",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: 100,
                  width: 200,
                  child: FlatButton(
                    child: Text(
                      'Start screen',
                      style: TextStyle(fontSize: 25),
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PackageList(username)),
                      );
                    },
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
