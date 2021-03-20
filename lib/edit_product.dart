import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/commons.dart';
import 'package:urbanmed/constant.dart';
import 'loading.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;

  EditProductScreen({Key key, this.productId}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String error = '';
  bool loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //final Authentication _auth = Authentication();
  final _formKey = GlobalKey<FormState>();
  final productnameInputController = TextEditingController();
  final medicineTypeInputController = TextEditingController();
  final manufacturingdateInputController = TextEditingController();
  final expiringdateInputController = TextEditingController();
  final costInputController = TextEditingController();
  final productcompanyInputController = TextEditingController();

  String productname = '';
  String medicinetype = '';
  String manufacturingdate = '';
  String expiringdate = '';
  String cost = '';
  String productcompany = '';

  var query;
  var productquery;
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

      var productquery = await FirebaseFirestore.instance
          .collection('Retailer')
          .doc(shopID)
          .collection('ProductData')
          .doc(widget.productId)
          .get();
      print(productquery);
      if (productquery.data().isNotEmpty) {
        var data = productquery.data();
        productnameInputController.text = data['productname'].toString();
        medicineTypeInputController.text = data['medicinetype'].toString();
        manufacturingdateInputController.text =
            data['manufacture_date'].toString();
        expiringdateInputController.text = data['expiry_date'].toString();
        costInputController.text = data['cost'].toString();
        productcompanyInputController.text = data['productcompany'].toString();
        print(data);
      } else {
        showMyDialog(context, 'Error!!', 'Product Not Found');
      }
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
              title: Text('Edit your Product'),
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
                        controller: manufacturingdateInputController,
                        onChanged: (val) {
                          setState(() => manufacturingdate = null);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Product Expiring Date (DD/MM/YYYY)'),
                      validator: (val) => val.isEmpty
                          ? 'Enter your product expring date'
                          : null,
                      controller: expiringdateInputController,
                      onChanged: (val) {
                        setState(() => expiringdate = val);
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
                    SizedBox(height: 25.0),
                    ElevatedButton(
                        child: Text(
                          'Update Product',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Map<String, dynamic> data = {
                              'productname': productnameInputController.text,
                              'medicinetype': medicineTypeInputController.text,
                              'manufacture_date':
                                  manufacturingdateInputController.text,
                              'expiry_date': expiringdateInputController.text,
                              'cost': costInputController.text,
                              'productcompany':
                                  productcompanyInputController.text,
                            };

                            try {
                              await FirebaseFirestore.instance
                                  .collection('Retailer')
                                  .doc(shopID)
                                  .collection("ProductData")
                                  .doc(widget.productId)
                                  .update(data);

                              Navigator.of(context).pop();
                              showMyDialog(context, 'Success',
                                  'Product update successfully....');
                            } catch (e) {
                              showMyDialog(context, 'Error!!', e.message);
                            }
                          } else {
                            showMyDialog(context, 'Error!!', 'Fail to load');
                          }
                        }),
                    // SizedBox(height: 12.0),
                    // ElevatedButton(
                    //   child: Text(
                    //     'Back to Dashboard',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //   },
                    // ),
                    // Text(
                    //   error,
                    //   style: TextStyle(color: Colors.red, fontSize: 14.0),
                    // )
                  ],
                ),
              ),
            ),
          );
  }
}
