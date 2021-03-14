import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profilepage extends StatefulWidget {
  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String username = '';
  String mobilenumber = '';
  String eid = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    getProfile();
  }

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
    Icon ofericon = Icon(
      Icons.edit,
      color: Colors.black38,
    );
    Icon keyloch = Icon(
      Icons.vpn_key,
      color: Colors.black38,
    );
    Icon clear = Icon(
      Icons.history,
      color: Colors.black38,
    );
    Icon logout = Icon(
      Icons.do_not_disturb_on,
      color: Colors.black38,
    );

    Icon menu = Icon(
      Icons.more_vert,
      color: Colors.black38,
    );

    bool checkboxValueA = true;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Container(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(7.0),
            alignment: Alignment.topCenter,
            height: 230.0,
            child: Card(
              elevation: 3.0,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      margin: const EdgeInsets.all(10.0),
                      child: ClipOval(
                        child: Image.network(
                            'https://www.fakenamegenerator.com/images/sil-female.png'),
                      ),
                    ),
                  ),
                  // FlatButton(
                  //   onPressed: null,
                  //   child: Text(
                  //     'Change',
                  //     style:
                  //         TextStyle(fontSize: 13.0, color: Colors.blueAccent),
                  //   ),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30.0),
                  //       side: BorderSide(color: Colors.blueAccent)),
                  // ),
                  //Padding(padding: EdgeInsets.only(left: 20.0),),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                username,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              _verticalDivider(),
                              Text(
                                mobilenumber,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5),
                              ),
                              _verticalDivider(),
                              Text(
                                eid,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   child: IconButton(
                        //       icon: ofericon,
                        //       color: Colors.blueAccent,
                        //       onPressed: null),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: Text(
              'Addresses',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
          Container(
            height: 150.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  // height: 165.0,
                  // width: 230.0,
                  margin: EdgeInsets.all(7.0),
                  child: Card(
                    elevation: 3.0,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    username,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  _verticalDivider(),
                                  Text(
                                    address,
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 13.0,
                                        letterSpacing: 0.5),
                                  ),
                                  // _verticalDivider(),
                                  // Text(
                                  //   'vadodara',
                                  //   style: TextStyle(
                                  //       color: Colors.black45,
                                  //       fontSize: 13.0,
                                  //       letterSpacing: 0.5),
                                  // ),
                                  // _verticalDivider(),
                                  // Text(
                                  //   ' 390025',
                                  //   style: TextStyle(
                                  //       color: Colors.black45,
                                  //       fontSize: 13.0,
                                  //       letterSpacing: 0.5),
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5.0,
                                  top: 05.0,
                                  right: 0.0,
                                  bottom: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black26,
                                    ),
                                  ),
                                  _verticalD(),
                                  Checkbox(
                                    value: checkboxValueA,
                                    onChanged: (bool value) {
                                      setState(() {
                                        checkboxValueA = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              icon: menu,
                              color: Colors.black38,
                              onPressed: null),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.all(7.0),
          //   child: Card(
          //     elevation: 1.0,
          //     child: Row(
          //       children: <Widget>[
          //         IconButton(icon: keyloch, onPressed: null),
          //         _verticalD(),
          //         Text(
          //           'Change Password',
          //           style: TextStyle(fontSize: 15.0, color: Colors.black87),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: EdgeInsets.all(7.0),
          //   child: Card(
          //     elevation: 1.0,
          //     child: Row(
          //       children: <Widget>[
          //         IconButton(icon: clear, onPressed: null),
          //         _verticalD(),
          //         Text(
          //           'Clear History',
          //           style: TextStyle(
          //             fontSize: 15.0,
          //             color: Colors.black87,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: EdgeInsets.all(7.0),
          //   child: Card(
          //     elevation: 1.0,
          //     child: Row(
          //       children: <Widget>[
          //         IconButton(icon: logout, onPressed: null),
          //         _verticalD(),
          //         Text(
          //           'Deactivate Account',
          //           style: TextStyle(
          //             fontSize: 15.0,
          //             color: Colors.redAccent,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ))),
    );
  }

  _verticalDivider() => Container(
        padding: EdgeInsets.all(2.0),
      );

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 3.0, right: 0.0, top: 0.0, bottom: 0.0),
      );
}
