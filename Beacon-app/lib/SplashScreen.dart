import 'dart:async';
import 'package:SmartMap_Fix/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  TextEditingController usernameController = TextEditingController();
  int _state = 0;
  String username;


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
                        "Your Custom package tracker! \n"
                        "For Stations",textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 150, right: 150),
                      child: TextFormField(
                        controller: usernameController,
                        decoration:
                        InputDecoration(labelText: 'Enter your Station ID'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                      child: MaterialButton(
                        child: setUpButtonChild(),
                        onPressed: () {
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
      _state = 1;
       username = usernameController.text;
    });


    Timer(Duration(milliseconds: 3000), () {
      setState(() {
        _state = 2;

       Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MapScreen(username)),
        );

      });
    });

  }
}
