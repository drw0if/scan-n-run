import 'dart:async';
import 'package:Code_io/Package_List.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  TextEditingController usernameController = TextEditingController();
  String username;
  int _state = 0;


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
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Image.asset(
                        'assets/logo_size.png',
                        height: 350,
                        width: 350,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                      child: Text(
                        "Your Custom package tracker!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                      child: Text(
                        "For Runners",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 52, right: 52),
                      child: TextFormField(
                        controller: usernameController,
                        decoration:
                            InputDecoration(labelText: 'Enter your Runner ID'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                      child: MaterialButton(
                        child: setUpButtonChild(),
                        onPressed: () async {

                          String username = usernameController.text;
                          var url = 'http://159.89.109.103:5000/runner/login/$username';

                          await http.get(url)
                              .then((http.Response response) {
                            final int statusCode = response.statusCode;
                            if (statusCode == 200) {
                              print("login successful");
                            } else {
                              print("login not successful");
                            }
                          });
                          print(usernameController.text);

                          setState(() {
                            if (_state == 0) {
                              animateButton();
                            }
                          }
                          );

                        },
                        height: 50.0,
                        color: Colors.blueAccent,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "Login",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: SpinKitChasingDots(color: Colors.white, size: 30,),
      );

    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton()  {
    setState(() {
      username = usernameController.text;
      _state = 1;
    });

    Timer(Duration(milliseconds: 3000), () {
      setState(() {
        _state = 2;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PackageList(username)),
        );

      });
    });

  }
}
