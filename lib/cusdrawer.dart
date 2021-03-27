import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanmed/cusdashboard.dart';
import 'package:urbanmed/cust_pharmaby_by_area.dart';
import 'package:urbanmed/custlogin.dart';
import 'package:urbanmed/faq_screen.dart';
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
    getProfile();
  }

  String username = '';
  String mobilenumber = '';
  String eid = '';
  String address = '';

  void getProfile() async {
    var query = await FirebaseFirestore.instance
        .collection('Customers')
        .where('email', isEqualTo: auth.currentUser.email)
        .get();
    if (query.docs.isNotEmpty) {
      var qData = query.docs[0].data();

      username = qData['fullname'].toString();
      mobilenumber = qData['contact'].toString();
      eid = qData['email'].toString();
      address = qData['address'].toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            arrowColor: Colors.transparent,
            accountName: Text('$username'),
            accountEmail: Text("${auth.currentUser.email}"),
            onDetailsPressed: () {},
          ),
          ListTile(
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CustomerDashboard(),
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
            title: Text("User Profile"),
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
          ListTile(
            leading: Icon(Icons.location_on),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CustPharmacyByAreaScreen(),
              ));
            },
            enabled: true,
            title: Text("Pharmacy By Area"),
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   onTap: () {},
          //   enabled: true,
          //   title: Text("Settings"),
          // ),
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
