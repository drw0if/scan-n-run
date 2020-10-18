import 'package:Code_io/End_Screen.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReleaseScreen extends StatefulWidget {
  String resultPickup;
  String username;
  ReleaseScreen(this.resultPickup, this.username);

  @override
  State<StatefulWidget> createState() {
    return new ReleaseScreenState(resultPickup, username);
  }
}

class ReleaseScreenState extends State<ReleaseScreen> {
  String resultPickup;
  String username;
  ReleaseScreenState(this.resultPickup, this.username);
  String resultRelease;
  int runner_id = 1;

  Future _scanQR() async {
    try {
      var qrResult = await BarcodeScanner.scan();
      setState(() {
        resultRelease = qrResult.rawContent;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          resultRelease = "Camera permission was denied";
        });
      } else {
        setState(() {
          resultRelease = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        resultRelease = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        resultRelease = "Unknown Error $ex";
      });
    }

    resultRelease = "1";

    var url = 'http://159.89.109.103:5000/runner/$runner_id/release/$resultRelease';

    await http.get(url)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 202) {
        print("Release successful");
      } else {
        print("Release not successful");
      }
    });


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EndScreen(resultRelease, username)),
    );
  }

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
                  "Instruction",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                child: Text(
                  "You took the package with id $resultPickup. Deliver it to destination and scan the QR Code again to make the release",
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
                      'Release',
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
      ),
    ));
  }
}
