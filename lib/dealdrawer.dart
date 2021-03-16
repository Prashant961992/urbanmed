import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanmed/dealdashboard.dart';
import 'package:urbanmed/faq_screen.dart';
import 'package:urbanmed/productdetails.dart';
import 'package:urbanmed/profilepage.dart';
import 'package:urbanmed/retailerLogin.dart';
import 'package:urbanmed/helppage.dart';
import 'package:urbanmed/screen.dart';
import 'package:urbanmed/shopregister.dart';

class Dealdrawer extends StatefulWidget {
  @override
  Ddrawer createState() => Ddrawer();
}

final FirebaseAuth auth = FirebaseAuth.instance;

Future signOut() async {
  try {
    return await auth.signOut();
  } catch (error) {
    print(error.toString());
    return null;
  }
}

class Ddrawer extends State<Dealdrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            arrowColor: Colors.transparent,
            accountName: Text("Owner Name"),
            accountEmail: Text("${auth.currentUser.email}"),
            onDetailsPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => Profilepage(),
              // ));
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Ddashboard(),
              ));
            },
            enabled: true,
          ),
          ListTile(
            leading: Icon(Icons.description),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShopRegister(User, true),
              ));
            },
            enabled: true,
            title: Text("Your Shop Details"),
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductRegister(User),
              ));
            },
            enabled: true,
            title: Text("Add Product"),
          ),
          ListTile(
            leading: Icon(Icons.help),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Helppage(),
              ));
            },
            enabled: true,
            title: Text("Help"),
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FAQScreen(),
              ));
            },
            enabled: true,
            title: Text("FAQ"),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            onTap: () async {
              await auth.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('islogin', false);
              await prefs.setString('type', '');
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Screen(),
                  ),
                  (route) => false);
            },
            enabled: true,
            title: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
