import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/custlogin.dart';
import 'package:urbanmed/retailerLogin.dart';

class Screen extends StatefulWidget {
  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  bool darkMode = false;

  static const MaterialColor myColour = const MaterialColor(
    0xFFff0055,
    const <int, Color>{
      50: const Color( 0xFFff4081),
      100: const Color( 0xFFff4081),
      200: const Color( 0xFFff4081),
      300: const Color( 0xFFff4081),
      400: const Color( 0xFFff4081),
      500: const Color( 0xFFff4081),
      600: const Color( 0xFFff4081),
      700: const Color( 0xFFff4081),
      800: const Color( 0xFFff4081),
      900: const Color( 0xFFff4081),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColour,
      appBar: AppBar(
        backgroundColor: Color(0xFFf45d27),
        elevation: 0.0,
        title: Center(
          child: Text('Want  To Continue As ....',
            style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
          ),
        ),
      ),
      body: Container(
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
        child: Container(
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 120,
                      child: Image.asset('Images/Customer.png',
                      ),
                      //child: Icon(Icons.android, size: 80, color: darkMode ? Colors.white : Colors.black),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFFFFFFF)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:20),
                    Column(children: [
                      RaisedButton(
                        color: Colors.white,
                        child: Text(
                          'Customer',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CusLogin()),
                          );},
                      ),
                    ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40),
              Text('Or',
                style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 120,
                          height: 120,
                          child: Image.asset('Images/Owner.jpg'),
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
                        ),
                        SizedBox(height:20),
                        Column(
                          children: [
                            RaisedButton(
                              color: Colors.white,
                              child: Text(
                                'Retailer',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => RetailLogin(User)),
                                );},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}