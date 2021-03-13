import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  FAQScreen({Key key}) : super(key: key);

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Faq')),
    );
  }
}
