import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/dealdrawer.dart';


class Ddashboard extends StatefulWidget {
  @override
  Dashboard createState() => Dashboard();
}

class Dashboard extends State<Ddashboard> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Icon cusIcon= Icon(Icons.search);
  Widget cusSearchbar=Text("UrbanMed");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: <Widget>[
          //InkWell(   if want to give space between search and dots.
          //child: SizedBox(
          //width: 100.0,
          //child: Icon(Icons.search),
          //),
          //),
          IconButton(
            onPressed: (){
              setState(() {
                if(this.cusIcon.icon==Icons.search)
                {
                  this.cusIcon=Icon(Icons.cancel);
                  this.cusSearchbar=Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.only(
                        top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50)
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20
                          )
                        ]
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Hey, Searching Something????"
                      ),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                else{
                  this.cusIcon= Icon(Icons.search);
                  this.cusSearchbar=Text("UrbanMed");
                }
              });
            },
            icon: cusIcon,
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.more_vert),
          ),
        ],
        title: cusSearchbar,
      ),
      drawer: Dealdrawer(),
      floatingActionButton: IconButton(
          icon: Icon(Icons.message),
          onPressed: (){}
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height:60.0,
                  child:InkWell(
                    onTap: (){},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.card_travel),
                        Text(
                          'Your Medicine Data',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Location',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              if (_currentPosition != null &&
                                  _currentAddress != null)
                                Text(_currentAddress,
                                    style:
                                    Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );

    /*FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString("asset/data.json"),
        builder: (context,snapshot) {
          var mydata = json.decode(snapshot.data.toString());
          if (mydata == null) {
            return Center(
              child: Text(
                'Loading',
              ),
            );
          }
          else {
            return Center(
              child: Text(
                mydata[1]["name"],
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
            );
          }
        },
      ),*/
  }
}

