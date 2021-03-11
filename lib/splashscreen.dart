import 'dart:async';
import 'package:flutter/material.dart';
import 'package:urbanmed/screen.dart';
//import 'package:urbanmed/custlogin.dart';
//import 'package:urbanmed/retailerLogin.dart';

class Splash extends StatefulWidget {
  @override
  Splashscreen createState() => Splashscreen();
}

class Splashscreen extends State<Splash> {

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Screen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              //backgroundColor: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFf45d27),
                    Color(0xFFff4081)
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "UrbanMed",
                  style: TextStyle(fontSize:40.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

