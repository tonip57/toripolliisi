import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'main.dart';

class _addThread extends State<addThread> {

  List coordinates;
  List threadInfo = [];
  Set<Marker> _markers = {};
  BitmapDescriptor userMarker;
  BitmapDescriptor threadMarker;

  final myController = TextEditingController();

  _addThread(this.coordinates);

  @override
  void initState() {
    setUserMarker();
    setThreadMarker();
    super.initState();
  }

  void setUserMarker() async {
    userMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/userLocationBigger.png");
  }

  void setThreadMarker() async {
    threadMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/thread.png");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyle);
    setState(() {
      //set markers
      setMarkersToMap();

    });
  }

  void setMarkersToMap() {
    _markers.add(
      Marker(
        markerId: MarkerId("user"),
        position: LatLng(coordinates[0], coordinates[1]),
        icon: userMarker,
        anchor: const Offset(0.5, 0.5),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId("thread"),
        position: LatLng(coordinates[0], coordinates[1]),
        icon: threadMarker,
        anchor: const Offset(0.5, 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:  Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: AppBar(
              leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                  },
              ),
              title: Text("Create a thread"),
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
             child: ListView(
             children: [
             Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height /3,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(coordinates[0], coordinates[1]),
                          zoom: 11,
                        ),)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter the topic'
                      ),
                      controller: myController,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (myController.text.isNotEmpty) {
                          threadInfo.add(myController.text);
                          threadInfo.add(coordinates);
                          Navigator.pop(context, threadInfo);
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context).pop(true);
                                });
                                return AlertDialog(
                                  content: Text('Add topic for your thread!'),
                                );
                              });
                        }
                      },
                      child: Text("Create"),
                  ),
                ],
              ),
              ],
             ),
          ),
        ));
  }
}


class addThread extends StatefulWidget {

  List coordinates;

  addThread(this.coordinates);

  @override
  _addThread createState() => _addThread(coordinates);
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
          child: Text("Close"),
          onPressed: () {Navigator.pop(context);},
        ),
      ],
    );
  }
}