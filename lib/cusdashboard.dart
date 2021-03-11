import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urbanmed/Medicinedata.dart';
import 'package:urbanmed/cusdrawer.dart';
import 'package:flutter/material.dart';

class Cusboard extends StatefulWidget {
  String get id => null;

  @override
  Dashboard createState() => Dashboard();
}

class Dashboard extends State<Cusboard> {
  final database = FirebaseFirestore.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String currentAddress;

  //for creating radius dialog box method
  TextEditingController radiuscontroller = TextEditingController();

//  var fetch = FirebaseFirestore.instance
  //    .collection('Shopdata')
  //  .snapshots;
  File image;

  _imgFromCamera() async {
    PickedFile picture =
        await ImagePicker().getImage(source: ImageSource.camera);
    image = File(picture.path);
    setState(() {});
  }

  _imgFromGallery() async {
    PickedFile picture =
        await ImagePicker().getImage(source: ImageSource.gallery);
    image = File(picture.path);
    setState(() {});
  }

  Future<String> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Radius in Km :"),
            content: TextField(
              controller: radiuscontroller,
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(radiuscontroller.text.toString());
                },
              )
            ],
          );
        });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    Geolocator()
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
        currentAddress =
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
    // firebaseUser= FirebaseFirestore.instance.collection('Retailer').snapshots();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  this.cusIcon = Icon(Icons.cancel);
                  this.cusSearchbar = Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    margin: EdgeInsets.only(top: 15),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 20)
                        ]),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Hey, Searching Something????"),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.cusSearchbar = Text("UrbanMed");
                }
              });
            },
            icon: cusIcon,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
        title: cusSearchbar,
      ),
      drawer: MyDrawer(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              heroTag: "button1",
              child: Icon(Icons.location_on),
              onPressed: () {
                createAlertDialog(context);
              }),
          SizedBox(height: 20),
          FloatingActionButton(
              heroTag: "button2",
              child: Icon(Icons.image),
              onPressed: () {
                _showPicker(context);
              }),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 60.0,
              child: InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.shopping_cart),
                    Text(
                      'Cart',
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Shopdata').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var doc = snapshot.data.docs;
              return new ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          //print(doc[index].documentID);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MedicineData(doc[index].id)),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Text("owner Name : " +
                                  doc[index].data()['shopname']),
                              //Text("Contact : " + doc[index].data()['contact']),
                              //Text("Email : " + doc[index].data()['email']),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
    );

    /*FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString("asset/data.json"),
        builder: (context,snapshot) {
          var mydata = json.decode(snapshot.data.toString());
          if (mydata == null) {
            return Center(
              child: Text(
                'Loading',
              ),
            );
          }
          else {
            return Center(
              child: Text(
                mydata[1]["name"],
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
            );
          }
        },
      ),*/
  }
}
