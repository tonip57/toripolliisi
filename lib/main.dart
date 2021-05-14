import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:toripolliisi/addThread.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: new Color(0xff622F74),
      ),
      home: MyHomePage(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;

  var markerMap = {
    '1':[65.013287, 25.464802],
    '2':[65.030257, 25.411896],
    '3':[65.057783, 25.4713],
    '4':[65.058909, 25.467855],
  };

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/marker.png");
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyle);
    setState(() {

        for (int i = 1; i<markerMap.length+1; i++) {
          double x = markerMap[i.toString()][0];
          double y = markerMap[i.toString()][1];
          _markers.add(
            Marker(
              markerId: MarkerId(i.toString()),
              position: LatLng(x, y),
            ),
          );
        }
    });
  }

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:  Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0), // here the desired height
              child: AppBar(
                title: Text("Toripolliisi"),
                elevation: 0.0,
                actions: [
                  IconButton(onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (context) => AboutWidget(),
                    ),
                  },
                      icon: Icon(Icons.search))
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height /1.4,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: _markers,
                      initialCameraPosition: CameraPosition(
                      target: LatLng(65.013287, 25.464802),
                      zoom: 11,
                ),)),]
              ),
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addThread()),
              );
            },
            tooltip: "Google",
            child: Icon(Icons.pin_drop_outlined),
          ),
        ));
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Utils {
  static String mapStyle = '''
  [
  {
    "featureType": "poi",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]
  ''';
}

class AboutWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(' HELP'),
      content: Column(
        children: [
          Container(
            child: Text("NativeAlloc concurrent copying GC freed 55213(2493KB) AllocSpace objects, 0(0B) LOS objects, 49% free, 8042KB/15MB, paused 355us total 146.650ms "
                "NativeAlloc concurrent copying GC freed 55213(2493KB) AllocSpace objects, 0(0B) LOS objects, 49% free, 8042KB/15MB, paused 355us total 146.650ms"),
          ),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.purple,),
                Text("Nähtävyys"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.redAccent,),
                Text("Nähtävyys"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.greenAccent,),
                Text("Nähtävyys"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.blue.shade400,),
                Text("Nähtävyys"),
              ],),),
        ],
      ),
      actions: [
        TextButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // background
            onPrimary: Colors.blue, // foreground
          ),
          child: Text("close"),
          onPressed: () {Navigator.pop(context);},
        ),
      ],
    );
  }
}
