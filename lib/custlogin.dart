import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanmed/commons.dart';
import 'package:urbanmed/constant.dart';
import 'package:urbanmed/cusdashboard.dart';
import 'package:urbanmed/cusregister.dart';
import 'package:urbanmed/customerforgotpassword.dart';
import 'package:urbanmed/loading.dart';

// ignore: must_be_immutable
class CusLogin extends StatefulWidget {
  //CusLogin({Key key}) : super(key: key);

  @override
  Login createState() => Login();
}

class Login extends State<CusLogin> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailInputController;
  TextEditingController passwordInputController;

  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  initState() {
    emailInputController = new TextEditingController();
    passwordInputController = new TextEditingController();
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
              title: Text('Welcome to UrbanMed'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      controller: emailInputController,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      controller: passwordInputController,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            'Forgot Password ?',
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Forgetpassword()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.cyan,
                        child: Text(
                          'Log In',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            // setState(() => loading = true);

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailInputController.text,
                                      password: passwordInputController.text);

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('islogin', true);
                              await prefs.setString('type', 'customer');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerDashboard(),
                                ),
                              );
                            } catch (e) {
                              // setState(() {
                              //   loading = false;
                              // });
                              showMyDialog(context, 'Error!!', e.message);
                            }
                            // FirebaseAuth.instance
                            //     .signInWithEmailAndPassword(
                            //     email: emailInputController.text,
                            //     password: passwordInputController.text)
                            //     .then((currentUser) => FirebaseFirestore.instance
                            //     .collection("Customers")
                            //     .doc(currentUser.user.uid)
                            //     .get()
                            //     .then((DocumentSnapshot result) =>
                            //     Navigator.pushReplacement(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => Cusboard()))
                            // )

                            //     .catchError((err) => print(err)))
                            //     .catchError((err) => print(err));
                            // if(null) {
                            //   setState(() {
                            //     loading = false;
                            //     error = 'Could not Log in with those Details';
                            //   });
                            // }
                            // else{
                            //   {Navigator.of(context).pushReplacement(MaterialPageRoute(
                            //     builder: (context) => Cusboard(),
                            //   ),);}
                            // }
                          }
                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: 12.0),
                    new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Cusregister(),
                        ));
                      },
                      child: new Text("New to UrbanMed !! Click here"),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
