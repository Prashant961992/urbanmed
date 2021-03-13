import 'package:flutter/material.dart';

Future<void> showMyDialog(
    BuildContext context, String title, String subTitle) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subTitle),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

const double margin = 16.0;
const double component_padding = 8.0;

void showProgressDialog(String text, BuildContext context) {
  try {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(children: <Widget>[
                Center(
                  child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(component_padding),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(margin),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(
                                height: margin,
                              ),
                              Text(
                                text,
                                style: black16TextFieldStyle(),
                              )
                            ]),
                      )),
                )
              ]));
        });
  } catch (e) {
    print(e.toString());
  }
}

TextStyle black16TextFieldStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
