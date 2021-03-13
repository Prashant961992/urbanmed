import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerProductScreen extends StatefulWidget {
  final String shopId;

  CustomerProductScreen({this.shopId}) : super();

  @override
  _CustomerProductScreenState createState() => _CustomerProductScreenState();
}

class _CustomerProductScreenState extends State<CustomerProductScreen> {
  var firebaseUser = FirebaseAuth.instance.currentUser;

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
                return Center(child: Text('No Data Found'));
              } else {
                return new ListView(
                    padding: EdgeInsets.all(8),
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return Card(
                        elevation: 0.8,
                        // borderOnForeground: true,
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
                                  child: Text('Add To Cart'), onPressed: () {}),
                            )
                          ],
                        ),
                      );
                    }).toList());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: Loading());
            // } else {

            // }
          }),
    );
  }
}
