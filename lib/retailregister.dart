import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/commons.dart';
import 'package:urbanmed/constant.dart';
import 'package:urbanmed/loading.dart';
import 'package:urbanmed/shopregister.dart';

// ignore: must_be_immutable
class Retailregister extends StatefulWidget {
  //final doc;
  //Retailregister(this.doc);
  Retailregister({Key key, this.uid}) : super(key: key);
  String uid;

  @override
  Rregister createState() => Rregister();
}

class Rregister extends State<Retailregister> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String error = '';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ownernameInputController = new TextEditingController();
  final contactInputController = new TextEditingController();
  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();
  final retaildatabase =
      FirebaseDatabase.instance.reference().child("Retailer");

  String ownername = '';
  String contact = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFFff4060),
              elevation: 0.0,
              title: Text('Register as a Retailer'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Owner Name'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your Owner Name' : null,
                      controller: ownernameInputController,
                      onChanged: (val) {
                        setState(() => ownername = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Contact Number'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your Contact Number' : null,
                      controller: contactInputController,
                      onChanged: (val) {
                        setState(() => contact = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your Email' : null,
                      controller: emailInputController,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      controller: passwordInputController,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            var query = await FirebaseFirestore.instance
                                .collection('Retailer')
                                .where('email',
                                    isEqualTo: emailInputController.text)
                                .get();
                            if (query.docs.isEmpty) {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailInputController.text,
                                      password: passwordInputController.text)
                                  .then((currentUser) => FirebaseFirestore
                                      .instance
                                      .collection("Retailer")
                                      .add({
                                        "uid": currentUser.user.uid,
                                        "ownername":
                                            ownernameInputController.text,
                                        "contact": contactInputController.text,
                                        "email": emailInputController.text,
                                        "password":
                                            passwordInputController.text,
                                      })
                                      .then((result) => {
                                            ownernameInputController.clear(),
                                            contactInputController.clear(),
                                            emailInputController.clear(),
                                            passwordInputController.clear(),
                                          })
                                      .catchError((err) => print(err)))
                                  .catchError((err) => print(err));

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShopRegister(widget.uid, false),
                                ),
                              );
                            } else {
                              setState(() => loading = false);
                              print('Email Already Exist');
                              showMyDialog(
                                  context, 'Error!!', 'Email Already Exist');
                            }
                          }
                        }),
                    SizedBox(height: 12.0),
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
