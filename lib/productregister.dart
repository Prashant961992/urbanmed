import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/commons.dart';
import 'package:urbanmed/constant.dart';
import 'package:urbanmed/dealdashboard.dart';
import 'package:urbanmed/loading.dart';

// ignore: must_be_immutable
class ProductRegister extends StatefulWidget {
  final uid;

  ProductRegister(this.uid);

  @override
  Product createState() => Product();
}

class Product extends State<ProductRegister> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String error = '';
  bool loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //final Authentication _auth = Authentication();
  final _formKey = GlobalKey<FormState>();
  final productnameInputController = new TextEditingController();
  final medicineTypeInputController = new TextEditingController();

  // ignore: non_constant_identifier_names
  final manufacturing_dateInputController = new TextEditingController();

  // ignore: non_constant_identifier_names
  final expiring_dateInputController = new TextEditingController();
  final costInputController = new TextEditingController();
  final productcompanyInputController = new TextEditingController();

  // ignore: non_constant_identifier_names
  // final ProductDatabase = FirebaseDatabase.instance
  //     .reference()
  //     .child("Retailer")
  //     .child("Shopdata")
  //     .child("ProductData");
  String productname = '';
  String medicinetype = '';

  // ignore: non_constant_identifier_names
  String manufacturing_date = '';

  // ignore: non_constant_identifier_names
  String expiring_date = '';
  String cost = '';
  String productcompany = '';
  var query;
  var shopID = '';

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  void getDetails() async {
    query = await FirebaseFirestore.instance
        .collection('Retailer')
        .where('email', isEqualTo: firebaseUser.email)
        .get();
    if (query.docs.isNotEmpty) {
      shopID = query.docs[0].id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Register your Product'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Product Name'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your Product Name' : null,
                      controller: productnameInputController,
                      onChanged: (val) {
                        setState(() => productname = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Medicine Type Like Homeopathy ...'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter the Type of Medicine ' : null,
                        controller: medicineTypeInputController,
                        onChanged: (val) {
                          setState(() => medicinetype = val);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText:
                                'Product Manufacturing Date (DD/MM/YYYY)'),
                        validator: (val) => val.isEmpty
                            ? 'Enter your product manufacturing date'
                            : null,
                        controller: manufacturing_dateInputController,
                        onChanged: (val) {
                          setState(() => manufacturing_date = null);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Product Expiring Date (DD/MM/YYYY)'),
                      validator: (val) => val.isEmpty
                          ? 'Enter your product expring date'
                          : null,
                      controller: expiring_dateInputController,
                      onChanged: (val) {
                        setState(() => expiring_date = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Product Cost per unit'),
                      validator: (val) => val.isEmpty
                          ? 'Enter your product cost per unit'
                          : null,
                      controller: costInputController,
                      onChanged: (val) {
                        setState(() => cost = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Product Company'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter Product Company name' : null,
                      controller: productcompanyInputController,
                      onChanged: (val) {
                        setState(() => cost = val);
                      },
                    ),
                    ElevatedButton(
                        child: Text(
                          'Add Product',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Map<String, dynamic> data = {
                              'productname': productnameInputController.text,
                              'medicinetype': medicineTypeInputController.text,
                              'manufacture_date':
                                  manufacturing_dateInputController.text,
                              'expiry_date': expiring_dateInputController.text,
                              'cost': costInputController.text,
                              'productcompany':
                                  productcompanyInputController.text,
                            };

                            try {
                              await FirebaseFirestore.instance
                                  .collection('Retailer')
                                  .doc(shopID)
                                  .collection("ProductData")
                                  .add(data);

                              productnameInputController.clear();
                              medicineTypeInputController.clear();
                              manufacturing_dateInputController.clear();
                              expiring_dateInputController.clear();
                              costInputController.clear();
                              productcompanyInputController.clear();
                            } catch (e) {
                              showMyDialog(context, 'Error!!', e.message);
                            }
                          } else {
                            print("Error");
                          }
                        }),
                    SizedBox(height: 12.0),
                    ElevatedButton(
                      child: Text(
                        'Back to Dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Ddashboard(), //(User),
                        ));
                      },
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
