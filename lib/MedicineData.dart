import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/loading.dart';

class MedicineData extends StatefulWidget {
  final doc;
  MedicineData(this.doc);
  @override
  Data createState() => Data();
}

class Data extends State<MedicineData> {
  var firebaseUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Shopdata')
              .doc(firebaseUser.uid)
              .collection('ProductData')
              .snapshots(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Loading());
            } else {
              return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          Text("Product Name: " + document.data()['productname']),
                          Text("Medicine Type: " + document.data()['medicinetype']),
                          Text("Manufacturing Date: " + document.data()['manufacturing_date']),
                          Text("Expiry Date: " + document.data()['expiry_date']),
                          Text("Cost: " + document.data()['cost']),
                        ],
                      ),
                    );
                  }).toList());
            }
          }),
    );
  }
}