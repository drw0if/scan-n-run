import 'dart:ui';
import 'package:Code_io/Release_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackageList extends StatefulWidget {
  String username;
  PackageList(this.username, {Key key, this.title}) : super(key: key);

  final String title;
  @override
  State<StatefulWidget> createState() {
    return new PackageListState(username);
  }
}

class PackageListState extends State<PackageList> {

  String username;
  PackageListState(this.username);

  String resultPickup = "ciao";
  int runner_id = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                    "Instruction",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                  child: Text(
                    "Hello $username runner id: 1! \n"
                    "Pick up a package by pressing the button at the bottom. "
                    "Once the button is pressed, scan the QR code "
                    "for the product you want to pick up.",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: SizedBox(
                    height: 100,
                    width: 200,
                    child: FlatButton(
                      child: Text(
                        'Pick Up',
                        style: TextStyle(fontSize: 25),
                      ),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () async {
                        _scanQR();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Future _scanQR() async {
    try {
      var qrResult = await BarcodeScanner.scan();
      setState(() {
        resultPickup = qrResult.rawContent;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          resultPickup = "Camera permission was denied";
        });
      } else {
        setState(() {
          resultPickup = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        resultPickup = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        resultPickup = "Unknown Error $ex";
      });
    }

     resultPickup = "1";
    var url = 'http://159.89.109.103:5000/runner/$runner_id/pickup/$resultPickup';

    await http.get(url)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 202) {
        print("Pick Up successful");
      } else {
        print("Pick Up not successful");
      }
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ReleaseScreen(resultPickup, username)),
    );
  }
}
