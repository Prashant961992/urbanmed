import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/constant.dart';
import 'package:urbanmed/custlogin.dart';
import 'package:urbanmed/loading.dart';

class Cusregister extends StatefulWidget {
//Cusregister ({Key key}) : super(key : key);
  @override
  Cregister createState() => Cregister();
}

class Cregister extends State<Cusregister> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String error = '';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final fullnameInputController = new TextEditingController();
  final addressInputController = new TextEditingController();
  final contactInputController = new TextEditingController();
  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();

  final customerdatabase =
      FirebaseDatabase.instance.reference().child("Customer");

  String fullname = '';
  String address = '';
  String contact = '';
  String email = '';
  String password = '';

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
              title: Text('Register as Customer'),
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
                          textInputDecoration.copyWith(hintText: 'Fullname'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your Fullname' : null,
                      controller: fullnameInputController,
                      onChanged: (val) {
                        setState(() => fullname = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Address'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your Address' : null,
                      controller: addressInputController,
                      onChanged: (val) {
                        setState(() => address = val);
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
                          textInputDecoration.copyWith(hintText: 'password'),
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
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: passwordInputController.text)
                                .then((currentUser) => FirebaseFirestore
                                    .instance
                                    .collection("Customers")
                                    .doc(currentUser.user.uid)
                                    .set({
                                      "uid": currentUser.user.uid,
                                      "fullname": fullnameInputController.text,
                                      "address": addressInputController.text,
                                      "contact": contactInputController.text,
                                      "email": emailInputController.text,
                                      "password": passwordInputController.text,
                                    })
                                    .then((result) => {
                                          fullnameInputController.clear(),
                                          addressInputController.clear(),
                                          contactInputController.clear(),
                                          emailInputController.clear(),
                                          passwordInputController.clear(),
                                        })
                                    .catchError((err) => print(err)))
                                .catchError((err) => print(err));

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CusLogin(),
                              ),
                            );

                            /// database mate no codee

                            customerdatabase.push().set({
                              "fullname": fullnameInputController.text,
                              "address": addressInputController.text,
                              "contact": contactInputController.text,
                              "email": emailInputController.text,
                              "password": passwordInputController.text,
                            }).then((_) {
                              fullnameInputController.clear();
                              addressInputController.clear();
                              contactInputController.clear();
                              emailInputController.clear();
                              passwordInputController.clear();
                            }).catchError((onError) {});
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
