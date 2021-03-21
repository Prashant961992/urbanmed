import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urbanmed/cusdrawer.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/customer_product_screen.dart';
import 'package:urbanmed/no_data_Found.dart';
import 'Cart_Page.dart';

class ShopData {
  double latitude;
  double longitude;
  String shopname;
  String pincode;
  String id;
  String address;
  String contactNUmber;
  String emailid;

  ShopData(
      {this.latitude,
      this.longitude,
      this.shopname,
      this.id,
      this.pincode,
      this.address,
      this.contactNUmber,
      this.emailid});
}

class CustomerDashboard extends StatefulWidget {
  CustomerDashboard({Key key}) : super(key: key);

  @override
  CustomerDashboardState createState() => CustomerDashboardState();
}

class CustomerDashboardState extends State<CustomerDashboard> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position currentPosition;
  String currentAddress;
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchbar = Text("UrbanMed");

  TextEditingController radiuscontroller = TextEditingController();
  bool isloading;
  File image;
  var listShopID = <ShopData>[];

  @override
  void initState() {
    super.initState();
    radiuscontroller.text = '2';
    getNearestShops();
  }

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }

  void getNearestShops() async {
    isloading = true;
    listShopID = <ShopData>[];
    setState(() {});
    currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var query = await FirebaseFirestore.instance.collection('Retailer').get();
    if (query.docs.isNotEmpty) {
      for (var i = 0; i < query.docs.length; i++) {
        var shopData = await FirebaseFirestore.instance
            .collection('Retailer')
            .doc(query.docs[i].id)
            .collection('Shopdata')
            .get();
        if (shopData.docs.isNotEmpty) {
          var latitude = checkDouble(shopData.docs[0].data()['Latitude']);
          var longitude = checkDouble(shopData.docs[0].data()['Longitude']);

          Geodesy geodesy = Geodesy();
          LatLng l1 =
              LatLng(currentPosition.latitude, currentPosition.longitude);
          LatLng l2 = LatLng(latitude, longitude);
          num distance = geodesy.distanceBetweenTwoGeoPoints(l2, l1);
          print(
              "[distanceBetweenTwoGeoPoints] Distance: " + distance.toString());
          if (radiuscontroller.text.isNotEmpty) {
            if (distance <= int.parse(radiuscontroller.text)) {
              var shopDatas = ShopData();
              shopDatas.id = query.docs[i].id;
              shopDatas.latitude = latitude;
              shopDatas.longitude = longitude;
              shopDatas.shopname = shopData.docs[0].data()['shopname'];
              shopDatas.pincode = shopData.docs[0].data()['pincode'];
              shopDatas.address = shopData.docs[0].data()['Address'].toString();
              shopDatas.contactNUmber =
                  shopData.docs[0].data()['contact'].toString();
              listShopID.add(shopDatas);
            }
          } else {
            var shopDatas = ShopData();
            shopDatas.id = query.docs[i].id;
            shopDatas.latitude = latitude;
            shopDatas.longitude = longitude;
            shopDatas.shopname = shopData.docs[0].data()['shopname'];
            shopDatas.pincode = shopData.docs[0].data()['pincode'];
            shopDatas.address = shopData.docs[0].data()['Address'].toString();
            shopDatas.contactNUmber =
                shopData.docs[0].data()['contact'].toString();
            listShopID.add(shopDatas);
          }
        }
      }

      if (radiuscontroller.text.isEmpty) {
      } else {}
    }

    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ));
                },
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
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: listShopID.length == 0
                  ? NoDataFoundWidget()
                  : ListView.builder(
                      itemCount: listShopID.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerProductScreen(
                                        shopId: listShopID[index].id,
                                      )),
                            );
                          },
                          child: Card(
                            elevation: 0.8,
                            child: ListTile(
                              title: Text(
                                  "Shop Name : " + listShopID[index].shopname),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Contact Number : " +
                                      listShopID[index].contactNUmber),
                                  Text(
                                      "Address : " + listShopID[index].address),
                                ],
                              ),
                              trailing: Icon(Icons.forward),
                              // subtitle: ,
                            ),
                          ),
                        );
                      })),
    );
  }

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
                  getNearestShops();
                  Navigator.of(context).pop();
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
}
