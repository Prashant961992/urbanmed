import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/commons.dart';
import 'package:urbanmed/no_data_Found.dart';

class CustomerProductScreen extends StatefulWidget {
  final String shopId;

  CustomerProductScreen({this.shopId}) : super();

  @override
  _CustomerProductScreenState createState() => _CustomerProductScreenState();
}

class _CustomerProductScreenState extends State<CustomerProductScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Retailer')
              .doc(widget.shopId)
              .collection('ProductData')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0) {
                return NoDataFoundWidget();
              } else {
                return new ListView(
                    padding: EdgeInsets.all(8),
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return Card(
                        elevation: 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "Product Name: ${document.data()['productname']}"),
                            Text(
                                "Medicine Type: ${document.data()['medicinetype']}"),
                            Text(
                                "Manufacturing Date: ${document.data()['manufacture_date']}"),
                            Text(
                                "Expiry Date: ${document.data()['expiry_date']}"),
                            Text("Cost: ${document.data()['cost'].toString()}"),
                            Center(
                              child: RaisedButton(
                                  child: Text('Add To Cart'),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('Customers')
                                        .doc(auth.currentUser.uid)
                                        .collection('Cart')
                                        .add(document.data());
                                    showMyDialog(context, 'Success!!',
                                        'your product add successfully go to cart and checkout you order');
                                  }),
                            )
                          ],
                        ),
                      );
                    }).toList());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
