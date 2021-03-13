import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:urbanmed/Cart_Page.dart';
import 'package:urbanmed/cusdashboard.dart';
import 'package:urbanmed/cusdrawer.dart';
import 'package:urbanmed/customer_product_screen.dart';

import 'no_data_Found.dart';

class CustPharmacyByAreaScreen extends StatefulWidget {
  CustPharmacyByAreaScreen({Key key}) : super(key: key);

  @override
  _CustPharmacyByAreaScreenState createState() =>
      _CustPharmacyByAreaScreenState();
}

class _CustPharmacyByAreaScreenState extends State<CustPharmacyByAreaScreen> {
  TextEditingController pincodecontroller = TextEditingController();

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position currentPosition;
  String currentAddress;
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchbar = Text("UrbanMed");

  bool isloading;
  var listShopID = <ShopData>[];

  @override
  void initState() {
    super.initState();
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
    setState(() {});
    currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    listShopID = <ShopData>[];
    var query = await FirebaseFirestore.instance.collection('Retailer').get();
    if (query.docs.isNotEmpty) {
      for (var i = 0; i < query.docs.length; i++) {
        var shopData = await FirebaseFirestore.instance
            .collection('Retailer')
            .doc(query.docs[i].id)
            .collection('Shopdata')
            .get();
        if (shopData.docs.isNotEmpty) {
          if (pincodecontroller.text.isEmpty) {
            var latitude = checkDouble(shopData.docs[0].data()['Latitude']);
            var longitude = checkDouble(shopData.docs[0].data()['Longitude']);
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
          } else {
            var pinCode = shopData.docs[0].data()['pincode'];
            if (pincodecontroller.text == pinCode) {
              var latitude = checkDouble(shopData.docs[0].data()['Latitude']);
              var longitude = checkDouble(shopData.docs[0].data()['Longitude']);
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
      }

      if (pincodecontroller.text.isEmpty) {
      } else {}
    }

    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy By Area'),
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "button1",
          child: Icon(Icons.add),
          onPressed: () {
            createAlertDialog(context);
          }),
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

  Future<String> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter your area code :"),
            content: TextField(
              controller: pincodecontroller,
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
}
