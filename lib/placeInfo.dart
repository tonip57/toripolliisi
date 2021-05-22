import 'dart:ui';

import 'package:toripolliisi/Place.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:collection/collection.dart';

class _placeInfo extends State<placeInfo> {

  Place place;
  List<bool> isSelected;
  int initialVotes;

  Function eq = const ListEquality().equals;

  _placeInfo(this.place);

  @override
  void initState() {
    initialVotes = place.votes;
    isSelected = place.usersVote;
    checkVotes();
    super.initState();
  }

  void checkVotes() {
    if (eq(isSelected, [false, false])) {
      initialVotes = place.votes;
    } else if (eq(isSelected, [true, false])) {
      initialVotes = place.votes - 1;
    } else if (eq(isSelected, [false, true])) {
      initialVotes = place.votes + 1;
    }
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
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 11,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Align(
                          alignment: Alignment.center,
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
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: ToggleButtons(
                          children: [
                            Icon(Icons.plus_one),
                            Icon(Icons.exposure_minus_1),
                          ],
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
                    Container(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 300,
                  color: Colors.blueGrey,
                ),
                Bubble(
                      margin: BubbleEdges.only(top: 10),
                      alignment: Alignment.topLeft,
                      child: Text(place.infoText),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                Image.asset("assets/photos/" + place.imgName),
              ],
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
