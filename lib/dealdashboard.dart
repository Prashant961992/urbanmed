import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/dealdrawer.dart';
import 'package:urbanmed/edit_product.dart';
import 'package:urbanmed/searchproduct.dart';
import 'package:urbanmed/view_shop_info.dart';
import 'package:urbanmed/productregister.dart';

class Ddashboard extends StatefulWidget {
  @override
  Dashboard createState() => Dashboard();
}

class Dashboard extends State<Ddashboard> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  final TextEditingController searchcontroller = TextEditingController();
  bool searchState = false;
  var query;
  var shopID = '';
  var queryResult = [];
  var temp = [];

  //search bar code
  searchProduct(String search) async {
    return FirebaseFirestore.instance
        .collection('Retailer')
        .doc(shopID)
        .collection("ProductData")
        .where('productname', isEqualTo: search.substring(0, 1).toUpperCase())
        .get();
  }

  initiateState(value) {
    if (value == 0) {
      setState(() {
        queryResult = [];
        temp = [];
      });
    }
    var letter = value.substring(0, 1).toUpperCase() + value.sunstring(1);
    if (queryResult.length == 0 && value.length == 1) {
      Search().searchProduct(value).then((QuerySnapshot data) {
        for (int i = 0; i < data.docs.length; ++i) {
          queryResult.add(data.docs[i].data());
        }
      });
    } else {
      temp = [];
      queryResult.forEach((element) {
        if (element['productname'].startsWith(letter)) {
          setState(() {
            temp.add(element);
          });
        }
      });
    }
  }

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

  //Icon cusIcon = Icon(Icons.search);
  //Widget cusSearchbar = Text("UrbanMed");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  searchState = !searchState;
                });
              }),
        ],
        title: !searchState
            ? Text("UrbanMed")
            : TextField(
                controller: searchcontroller,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Enter Product Name",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
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
      // for the card to be listed

      // ListView.builder(
      //     padding: EdgeInsets.only(left: 10.0, right: 10.0),
      //     crossAxisCount: 2,
      //     crossAxisSpacing: 4.0,
      //     mainAxisSpacing: 4.0,
      //     primary: false,
      //     shrinkWrap: true,
      //     children: temp.map((element) {
      //       return buildcard(element);
      //     }).toList())
      body: shopID.isEmpty
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: searchcontroller.text.length > 0
                  ? FirebaseFirestore.instance
                      .collection('Retailer')
                      .doc(shopID)
                      .collection("ProductData")
                      .where('productname', isEqualTo: searchcontroller.text)
                      .snapshots()
                  : FirebaseFirestore.instance
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
                          width: width,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ViewShopInfo(User, true),
                                ));
                              },
                              child: Text('View Info')),
                        ),
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

  Widget buildcard(element) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Retailer')
            .doc(shopID)
            .collection("ProductData")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docsData = snapshot.data.docs;
            return SingleChildScrollView(
                child: Container(
              width: width,
              height: height - 120,
              child: ListView.builder(
                  itemCount: docsData.length,
                  itemBuilder: (c, s) {
                    var d = docsData[s];
                    return Card(
                      elevation: 0.8,
                      child: ListTile(
                        title: Text(' Product Name: ${d['productname']}'),
                        subtitle: Text(' Product Price: ${d['cost']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProductScreen(
                                productId: docsData[s].id,
                              ), //(User),
                            ));
                          },
                        ),
                      ),
                    );
                  }),
            ));
          } else {
            return Center(
              child: Text('No Data Found'),
            );
          }
        });
    // return Container(
    //   width: width,
    //   height: height - 120,
    //   child: ListView.builder(
    //       itemCount: docsData.length,
    //       itemBuilder: (c, s) {
    //         var d = docsData[s];
    //         return Card(
    //           elevation: 0.8,
    //           child: ListTile(
    //             title: Text(' Product Name: ${d['productname']}'),
    //             subtitle: Text(' Product Price: ${d['cost']}'),
    //             trailing: IconButton(
    //               icon: Icon(Icons.edit),
    //               onPressed: () {
    //                 Navigator.of(context).push(MaterialPageRoute(
    //                   builder: (context) => EditProductScreen(
    //                     productId: docsData[s].id,
    //                   ), //(User),
    //                 ));
    //               },
    //             ),
    //           ),
    //         );
    //       }),
    // );
  }
}
