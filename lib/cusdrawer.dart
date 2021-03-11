import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/cusdashboard.dart';
import 'package:urbanmed/custlogin.dart';
import 'package:urbanmed/helppage.dart';
import 'package:urbanmed/orderhistory.dart';
import 'package:urbanmed/profilepage.dart';
import 'package:urbanmed/screen.dart';

class MyDrawer extends StatefulWidget {
  @override
  DrawerState createState() => DrawerState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

Future signOut() async {
  try {
    return await _auth.signOut();
  } catch (error) {
    print(error.toString());
    return null;
  }
}

class DrawerState extends State<MyDrawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text("${auth.currentUser.email}"),
            onDetailsPressed: () {},
          ),
          ListTile(
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Cusboard(),
              ));
            },
            enabled: true,
            title: Text("Home"),
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Profilepage(),
              ));
            },
            enabled: true,
            title: Text("Your Account"),
          ),
          ListTile(
            leading: Icon(Icons.local_grocery_store),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Orderhistory(),
              ));
            },
            enabled: true,
            title: Text("Your Orders"),
          ),
          // ListTile(
          //   leading: Icon(Icons.chat),
          //   onTap: () {},
          //   enabled: true,
          //   title: Text("My Chat"),
          // ),
          ListTile(
            leading: Icon(Icons.location_on),
            onTap: () {},
            enabled: true,
            title: Text("Pharmacy By Area"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            onTap: () {},
            enabled: true,
            title: Text("Settings"),
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
            leading: Icon(Icons.logout),
            onTap: () async {
              await auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Screen(),
                  ),
                  (route) => false);
            },
            enabled: true,
            title: Text("Log Out"),
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            onTap: () {},
            enabled: true,
            title: Text("FAQ"),
          ),
        ],
      ),
    );
  }
}
