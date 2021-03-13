import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckOutData {
  double price;
  String productName;

  CheckOutData({this.price, this.productName});
}

class CheckOutScreen extends StatefulWidget {
  CheckOutScreen({Key key}) : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var listcartData = <CheckOutData>[];
  var total = 0.0;
  var subTotal = 0.0;
  var deliveryCharge = 25.0;
  var tax = 0.0;

  @override
  void initState() {
    super.initState();
    calculateTotal();
  }

  void calculateTotal() async {
    var cartData = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(auth.currentUser.uid)
        .collection('Cart')
        .get();

    for (var i = 0; i < cartData.docs.length; i++) {
      var data = cartData.docs[i].data();

      var shopDatas = CheckOutData();
      shopDatas.price = double.parse(data['cost']);
      shopDatas.productName = data['productname'];
      subTotal = subTotal + shopDatas.price;
      listcartData.add(shopDatas);
    }

    tax = subTotal * 18 / 100;
    total = subTotal + tax + deliveryCharge;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: listcartData.length,
                itemBuilder: (context, index) {
                  return ProductName(
                    title: listcartData[index].productName,
                    value: listcartData[index].price.toString(),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 0.5,
                child: Container(
                  child: Column(
                    children: [
                      ProductName(
                        title: 'Sub Total',
                        value: subTotal.toString(),
                      ),
                      ProductName(title: 'Tax', value: tax.toString()),
                      ProductName(
                          title: 'Delivery Charge',
                          value: deliveryCharge.toString()),
                      ProductName(
                        title: 'Total',
                        value: total.toString(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton(
              child: Text('Pay Now Rs. ${total.toString()}'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class ProductName extends StatelessWidget {
  final String title;
  final String value;

  const ProductName({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Text('Rs. $value'),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
