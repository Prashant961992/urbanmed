import 'package:flutter/material.dart';

class Helppage extends StatefulWidget {
  @override
  _HelppageState createState() => _HelppageState();
}

class _HelppageState extends State<Helppage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body:Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 50.0,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 7.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0,right: 10.0),
              child: Card(
                child: Container(
                  //  padding: EdgeInsets.only(left: 10.0,top: 15.0,bottom: 5.0,right: 5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 15.0, bottom: 15.0),
                        child: GestureDetector(
                          child:Row(
                            children: <Widget>[
                              Icon(Icons.mail, color: Colors.black54),
                              Container(
                                margin: EdgeInsets.only(left: 5.0),
                              ),
                              Text(
                                'Email Us',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ) ,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 15.0, bottom: 15.0),
                        child: GestureDetector(
                          child:Row(
                            children: <Widget>[
                              Icon(Icons.info_outline, color: Colors.black54),
                              Container(
                                margin: EdgeInsets.only(left: 5.0),
                              ),
                              Text(
                                'About Us',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ) ,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 15.0, bottom: 15.0),
                        child: GestureDetector(
                          child:Row(
                            children: <Widget>[
                              Icon(Icons.feedback, color: Colors.black54),
                              Container(
                                margin: EdgeInsets.only(left: 5.0),
                              ),
                              Text(
                                'Send Feedback',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ) ,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
