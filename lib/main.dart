import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanmed/cusdashboard.dart';
// import 'package:urbanmed/cusdashboard.dart';
import 'package:urbanmed/screen.dart';
// import 'splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:urbanmed/splashscreen.dart';

import 'dealdashboard.dart';
// import 'package:urbanmed/retailerLogin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var widget = await getDefaultWidget();

  runApp(MyApp(
    defaultWidget: widget,
  ));
}

Future<Widget> getDefaultWidget() async {
  Widget _defaultWidget = Screen();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    if (!prefs.getBool('islogin')) {
      _defaultWidget = Screen();
    } else {
      var type = prefs.getString('type');
      if (type != null) {
        if (type == 'retail') {
          _defaultWidget = Ddashboard();
        } else {
          _defaultWidget = CustomerDashboard();
        }
      } else {
        _defaultWidget = Screen();
      }
    }
  } catch (e) {
    _defaultWidget = Screen();
  }
  return _defaultWidget;
}

class MyApp extends StatefulWidget {
  final Widget defaultWidget;

  MyApp({this.defaultWidget});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "UrbanMed",
      theme: ThemeData(
        primarySwatch: myColour,
      ),
      home: Splash(),
    );
  }
}

const MaterialColor myColour = const MaterialColor(
  0xFFff0055,
  const <int, Color>{
    50: const Color(0xFFff4081),
    100: const Color(0xFFff4081),
    200: const Color(0xFFff4081),
    300: const Color(0xFFff4081),
    400: const Color(0xFFff4081),
    500: const Color(0xFFff4081),
    600: const Color(0xFFff4081),
    700: const Color(0xFFff4081),
    800: const Color(0xFFff4081),
    900: const Color(0xFFff4081),
  },
);
