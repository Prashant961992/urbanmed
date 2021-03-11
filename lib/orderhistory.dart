import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Orderhistory extends StatefulWidget {
  @override
  _OrderhistoryState createState() => _OrderhistoryState();
}

class Item {
  final String name;
  final String deliveryTime;
  final String oderId;
  final String oderAmount;
  final String paymentType;
  final String address;
  final String cancelOder;

  Item(
      {this.name,
        this.deliveryTime,
        this.oderId,
        this.oderAmount,
        this.paymentType,
        this.address,
        this.cancelOder});
}

class _OrderhistoryState extends State<Orderhistory> {
  List<Item> itemList = <Item>[
    Item(
        name: 'Jhone Miller',
        deliveryTime: '265-2106',
        oderId: '#CN23656',
        oderAmount: '\â‚¹ 650',
        paymentType: 'online',
        address: '1338 Karen Lane,Louisville,Kentucky',
        cancelOder: 'Cancel Order'),

    Item(
        name: 'Lag Gilli',
        deliveryTime: '26-10-2107',
        oderId: '#CN69532',
        oderAmount: '\â‚¹ 1120',
        paymentType: 'online',
        address: '8 Clarksburg Park,Marble Canyon,Arizona',
        cancelOder: 'View Receipt'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (BuildContext cont, int ind){
            return SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                    color: Colors.black12,
                    child: Card(
                      elevation: 4.0,
                      child:Container(
                        padding: const EdgeInsets.fromLTRB(
                            10.0, 10.0, 10.0, 10.0),
                        child: GestureDetector(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:<Widget> [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  itemList[ind].name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3.0),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'To Deliver On :' +
                                      itemList[ind].deliveryTime,
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.black54),
                                ),
                              ),
                              Divider(
                                height: 10.0,
                                color: Colors.amber.shade500,
                              ),
                              Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(3.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Order Id',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black54),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 3.0),
                                            child: Text(
                                              itemList[ind].oderId,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Order Amount',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black54),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 3.0),
                                            child: Text(
                                              itemList[ind].oderAmount,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Payment Type',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black54),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 3.0),
                                            child: Text(
                                              itemList[ind].paymentType,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                              Divider(
                                height: 10.0,
                                color: Colors.amber.shade500,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 20.0,
                                    color: Colors.amber.shade500,
                                  ),
                                  Text(itemList[ind].address,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54)),
                                ],
                              ),
                              Divider(
                                height: 10.0,
                                color: Colors.amber.shade500,
                              ),
                              Container(
                                  child: _status(itemList[ind].cancelOder))

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}

Widget _status(status) {
  if (status == 'Cancel Order') {
    return FlatButton.icon(
        label: Text(
          status,
          style: TextStyle(color: Colors.red),
        ),
        icon: const Icon(
          Icons.highlight_off,
          size: 18.0,
          color: Colors.red,
        ),
        onPressed: () {
          // Perform some action
        });
  } else {
    return FlatButton.icon(
        label: Text(
          status,
          style: TextStyle(color: Colors.green),
        ),
        icon: const Icon(
          Icons.check_circle,
          size: 18.0,
          color: Colors.green,
        ),
        onPressed: () {
          // Perform some action
        });
  }

}