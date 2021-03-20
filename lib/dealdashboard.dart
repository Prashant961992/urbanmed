import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/dealdrawer.dart';
import 'package:urbanmed/edit_product.dart';
import 'package:urbanmed/productdetails.dart';

class Ddashboard extends StatefulWidget {
  @override
  Dashboard createState() => Dashboard();
}

class Dashboard extends State<Ddashboard> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  var query;
  var shopID = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getDetails();
  }

  void getDetails() async {
    query = await FirebaseFirestore.instance
        .collection('Retailer')
        .where('email', isEqualTo: firebaseUser.email)
        .get();
    if (query.docs.isNotEmpty) {
      shopID = query.docs[0].id;
      setState(() {});
    }
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchbar = Text("UrbanMed");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       if (this.cusIcon.icon == Icons.search) {
          //         this.cusIcon = Icon(Icons.cancel);
          //         this.cusSearchbar = Container(
          //           width: MediaQuery.of(context).size.width / 1.2,
          //           height: 45,
          //           margin: EdgeInsets.only(top: 15),
          //           padding:
          //               EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(50)),
          //               color: Colors.white,
          //               boxShadow: [
          //                 BoxShadow(color: Colors.black12, blurRadius: 20)
          //               ]),
          //           child: TextField(
          //             textInputAction: TextInputAction.go,
          //             decoration: InputDecoration(
          //                 border: InputBorder.none,
          //                 hintText: "Hey, Searching Something????"),
          //             style: TextStyle(
          //               fontSize: 16.0,
          //               color: Colors.white,
          //             ),
          //           ),
          //         );
          //       } else {
          //         this.cusIcon = Icon(Icons.search);
          //         this.cusSearchbar = Text("UrbanMed");
          //       }
          //     });
          //   },
          //   icon: cusIcon,
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.more_vert),
          // ),
        ],
        title: cusSearchbar,
      ),
      drawer: Dealdrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductRegister(User),
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: shopID.isEmpty
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Retailer')
                  .doc(shopID)
                  .collection("ProductData")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var docsData = snapshot.data.docs;
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Location',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          if (_currentPosition != null &&
                                              _currentAddress != null)
                                            Text(_currentAddress,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          width: width,
                          height: height - 120,
                          child: ListView.builder(
                              itemCount: docsData.length,
                              itemBuilder: (c, s) {
                                var d = docsData[s];
                                return Card(
                                  elevation: 0.8,
                                  child: ListTile(
                                    title: Text(
                                        ' Product Name: ${d['productname']}'),
                                    subtitle:
                                        Text(' Product Price: ${d['cost']}'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              EditProductScreen(
                                            productId: docsData[s].id,
                                          ), //(User),
                                        ));
                                      },
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No Data Found'),
                  );
                }
              }),
    );
  }
}
