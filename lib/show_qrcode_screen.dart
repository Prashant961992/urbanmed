import 'package:flutter/material.dart';
import 'package:urbanmed/cusdashboard.dart';

class ShowQrCodeScreen extends StatefulWidget {
  ShowQrCodeScreen({Key key}) : super(key: key);

  @override
  _ShowQrCodeScreenState createState() => _ShowQrCodeScreenState();
}

class _ShowQrCodeScreenState extends State<ShowQrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan and pay'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'Images/qr_code.jpeg',
            ),
            RaisedButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => CustomerDashboard(),
                    ),
                    (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
