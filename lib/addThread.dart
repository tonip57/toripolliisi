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

  //Sets initial values
  @override
  void initState() {
    setUserMarker();
    setThreadMarker();
    super.initState();
  }

  //Sets user icon
  void setUserMarker() async {
    userMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/userLocationBigger.png");
  }

  //Sets thread icon
  void setThreadMarker() async {
    threadMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/thread.png");
  }

  //Empty controller
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

  //Sets user and thread marker to map
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
                    icon: Icon(Icons.help_rounded))
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
                          hintText: 'Enter the title'
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
                                  content: Text('Add title for your thread!'),
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
      title: Text('Thread Info'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Text("Thread will be created to your current location. DO NOT create a thread if you don't want to show your current location to everybody.", style: TextStyle(fontSize: 14)),
          ),
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