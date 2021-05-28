import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toripolliisi/Place.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:collection/collection.dart';

import 'main.dart';

class _placeInfo extends State<placeInfo> {

  Place place;
  List<bool> isSelected;
  int initialVotes;
  Set<Marker> _markers = {};

  String infoText = "";
  String funFactText = "";

  Function eq = const ListEquality().equals;

  _placeInfo(this.place);

  //Sets initial values
  @override
  void initState() {
    initialVotes = place.votes;
    isSelected = place.usersVote;
    infoText = place.englishText;
    funFactText = place.funFactEnglish;
    checkVotes();
    super.initState();
  }

  //Changes text language
  void changeLanguage() {
    if (infoText == place.infoText) {
      setState(() {
        infoText = place.englishText;
      });
    } else {
      setState(() {
        infoText = place.infoText;
      });
    }
  }

  //Changes fun fact language
  void changeFunFactLanguage() {
    if (funFactText == place.funFact) {
      setState(() {
        funFactText = place.funFactEnglish;
      });
    } else {
      setState(() {
        funFactText = place.funFact;
      });
    }
  }

  //Checks votes and if user has voted already
  void checkVotes() {
    if (eq(isSelected, [false, false])) {
      initialVotes = place.votes;
    } else if (eq(isSelected, [true, false])) {
      initialVotes = place.votes - 1;
    } else if (eq(isSelected, [false, true])) {
      initialVotes = place.votes + 1;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyle);
    setState(() {
      //set markers
      setMarkerToMap();

    });
  }

  //Shows place icon on map
  void setMarkerToMap() {
    BitmapDescriptor iconColor;
    if (place.category == "goodToKnow") {
      iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
    } else if (place.category == "sports") {
      iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else if (place.category == "restaurantOrBar") {
      iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else if (place.category == "sight") {
      iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    } else if (place.category == "forStudent") {
      iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
    _markers.add(
      Marker(
        markerId: MarkerId(place.name),
        position: LatLng(place.coordinates[0], place.coordinates[1]),
        icon: iconColor,
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
                  Navigator.pop(context, isSelected);
                },
              ),
              title: Text(place.name),
              elevation: 0.0,
              actions: [
                IconButton(
                  icon: Image.asset('assets/language.png'),
                  onPressed: () => {
                    changeLanguage(),
                    changeFunFactLanguage()
                  },
                )
              ],
            ),
          ),
          body: SafeArea(
            child: Container(
            child: ListView(
            children: [
              Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              place.votes.toString() + " Votes!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                              ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 13,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(8.0),
                            children: <Widget>[
                              Container(width: (MediaQuery.of(context).size.width)/6.5, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Icon(Icons.plus_one),new SizedBox(width: 4.0,)],)),
                              Container(width: (MediaQuery.of(context).size.width)/6.5, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Icon(Icons.exposure_minus_1),new SizedBox(width: 4.0,)],)),
                            ],
                          selectedColor: Colors.white,
                          fillColor: Colors.blue,
                          isSelected: isSelected,
                          onPressed: (int index) {
                            setState(() {
                              if (isSelected[index] == true) {
                                isSelected[0] = false;
                                isSelected[1] = false;
                              } else {
                                isSelected[0] = false;
                                isSelected[1] = false;
                                isSelected[index] = true;
                              }
                              if (isSelected[0] == true) {
                                place.votes = initialVotes;
                                place.votes = place.votes + 1;
                              } else if (isSelected[1] == true) {
                                place.votes = initialVotes;
                                place.votes = place.votes - 1;
                              } else {
                                place.votes = initialVotes;
                              }
                            });
                          },
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 300,
                  color: Colors.grey,
                ),
                Bubble(
                      margin: BubbleEdges.only(top: 10),
                      alignment: Alignment.topLeft,
                      child: Text(infoText),
                ),
                Bubble(
                  margin: BubbleEdges.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Image.asset("assets/photos/" + place.imgName),
                  ),
                ),
                Bubble(
                  margin: BubbleEdges.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Column(
                      children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconTheme(
                                data: new IconThemeData(
                                    color: Colors.amberAccent),
                                child: new Icon(Icons.lightbulb),
                              ),
                              Text("Fun Fact!", style: TextStyle(fontSize: 20),),
                            ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        Text(funFactText),
                      ],
                    ),
                  ),
                ),
                Bubble(
                  margin: BubbleEdges.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Container(
                      height: MediaQuery.of(context).size.height /3,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(place.coordinates[0], place.coordinates[1]),
                          zoom: 11,
                        ),)
                  ),
                ),
              ],
            ),
            ],
            ),
            ),
          ),
        ));
  }
}


class placeInfo extends StatefulWidget {

  Place place;

  placeInfo(this.place);

  @override
  _placeInfo createState() => _placeInfo(place);
}
